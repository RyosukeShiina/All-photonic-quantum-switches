function rateGHZ = GHZRate_from_pauli_probabilities(ghzPauliOperatorProbabilities)

pauliTable = ghzPauliOperatorProbabilities.PauliOperators;
numPaulis = size(pauliTable, 1);

if numPaulis ~= 24
    error("Expected 24 GHZ source Pauli-operator probability entries.");
end

numkGHZ = ghzPauliOperatorProbabilities.numkGHZ;

if numkGHZ == 0
    rateGHZ = 0;
    return;
end

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

    [~, Qx, Qz, Qab] = ...
        map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedPauliOperatorResults);

    rateList(ell) = map_Qs_to_secret_key_rate(Qx, Qz, Qab);

end

rateGHZ = sum(rateList);

end