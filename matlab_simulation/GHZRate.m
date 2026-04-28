function rateGHZ = GHZRate(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)

if kA == 0 || kB == 0 || kC == 0
    rateGHZ = 0;
    return;
end

ghzPauliOperatorProbabilities = map_swapping_results_to_ghz_pauli_operator_probabilities(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

pauliTable = sourcePaulis();
numPaulis = size(pauliTable, 1);

numkGHZ = min([kA, kB, kC]);
rateList = zeros(numkGHZ, 1);

for ell = 1:numkGHZ
    singleResultsEll = struct();
    singleResultsEll.Probs = cell(numPaulis, 1);

    for s = 1:numPaulis
        probVector = singleResultsAll.Probs{s};
        singleResultsEll.Probs{s} = probVector(ell);
    end

    combinedResults = CombinedResults_from_SingleResults(singleResultsEll);
    [Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(combinedResults);

    rateList(ell) = Rate_from_QxQzQab(Qx, Qz, Qab);
end

rateGHZ = sum(rateList);
end
