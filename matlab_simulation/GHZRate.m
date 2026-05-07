function rateGHZ = GHZRate(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)

% The function first computes the GHZ source Pauli-operator probabilities
% for all available GHZ attempts. For each matched GHZ attempt, it maps the
% 24 source Pauli-operator probabilities to a combined 64-component
% three-qubit Pauli distribution, maps that distribution to GHZ-basis
% lambdas and Q quantities, and then computes the secret key rate.

if kA == 0 || kB == 0 || kC == 0
    rateGHZ = 0;
    return;
end

ghzPauliOperatorProbabilities = map_swapping_results_to_pauli_operator_probabilities(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

pauliTable = ghzPauliOperatorProbabilities.PauliOperators;
numPaulis = size(pauliTable, 1);

if numPaulis ~= 24
    error('Expected 24 GHZ source Pauli-operator probability entries.');
end

numkGHZ = ghzPauliOperatorProbabilities.numkGHZ;

rateList = zeros(numkGHZ, 1);

for ell = 1:numkGHZ

    singleResultsEll = struct();
    singleResultsEll.PauliOperators = pauliTable;
    singleResultsEll.Probs = cell(numPaulis, 1);

    for sourceIndex = 1:numPaulis
        probVector = ghzPauliOperatorProbabilities.Probs{sourceIndex};
        singleResultsEll.Probs{sourceIndex} = probVector(ell);
    end

    combinedPauliOperatorResults = ...
        map_pauli_operator_probs_to_combined_pauli_operator_probs(singleResultsEll);

    [ghz_basis_lambdas, Qx, Qz, Qab] = ...
        map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedPauliOperatorResults);

    rateList(ell) = map_Qs_to_secret_key_rate(Qx, Qz, Qab);

end

rateGHZ = sum(rateList);

end
