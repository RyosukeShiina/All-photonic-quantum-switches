function [ghz_basis_lambdas, Qx, Qz, Qab] = map_combined_pauli_operator_probabilities_to_ghz_basis_lambdas_and_Qs(combinedPauliOperatorResults)

% QxQzQab_from_CombinedResults
%   Input:
%       CombinedResults.patternLabels : 64x3 string array ("I","X","Y","Z")
%       CombinedResults.patternProbs  : 64x1 probability vector (sums to 1)
%
%   Output:
%       Qx, Qz, Qab : error rates
%       lambda : 8x1 vector of GHZ-basis weights (lambda(1) ... lambda(8))

patternLabels = combinedPauliOperatorResults.patternLabels;
patternProbs  = combinedPauliOperatorResults.patternProbs(:);

if numel(patternProbs) ~= 64
        error('patternProbs must contain 64 probabilities.');
end

if any(patternProbs < -1e-14)
        error('patternProbs contains negative entries.');
end

probabilitySum = sum(patternProbs);
if abs(probabilitySum - 1) > 1e-10
        warning('patternProbs does not sum exactly to 1. Sum = %.16g', probabilitySum);
end


ghz_basis_lambdas = zeros(8, 1);

for patternIndex = 1:64
    [pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, patternIndex);
    ghzBasisIndex = map_three_qubit_pauli_to_ghz_basis_index(pauli1, pauli2, pauli3);
    ghz_basis_lambdas(ghzBasisIndex) = ghz_basis_lambdas(ghzBasisIndex) + patternProbs(patternIndex);
end


%Qx = 1/2 - 1/2 * (lambda_0^+ - lambda_0^-)
Qx = 0.5 - 0.5 * (ghz_basis_lambdas(1) - ghz_basis_lambdas(2));

%Qz = 1 - lambda_0^+ - lambda_0^-
Qz = 1.0 - ghz_basis_lambdas(1) - ghz_basis_lambdas(2);

Qab1 = ghz_basis_lambdas(3) + ghz_basis_lambdas(4);
Qab2 = ghz_basis_lambdas(5) + ghz_basis_lambdas(6);
Qab3 = ghz_basis_lambdas(7) + ghz_basis_lambdas(8);

Qab = max([Qab1, Qab2, Qab3]);

end
