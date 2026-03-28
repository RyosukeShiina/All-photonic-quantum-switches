function TotalRateGHZ = Precompute_GHZRate(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, v, N)

if kA == 0
    TotalRateGHZ = 0;
    return;
end

SingleResults_all = SingleResults_from_ESs_Distance_k( ...
    LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, ...
    kA, kA, kA, v, N);

PauliTable = sourcePaulis();
Ns = size(PauliTable, 1);
Sk = kA;

RateList = zeros(Sk,1);

for ell = 1:Sk
    SingleResults_ell = struct();
    SingleResults_ell.Probs = cell(Ns,1);

    for s = 1:Ns
        vec = SingleResults_all.Probs{s};
        SingleResults_ell.Probs{s} = vec(ell);
    end

    CombinedResults = CombinedResults_from_SingleResults(SingleResults_ell);
    [Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);
    RateList(ell) = Rate_from_QxQzQab(Qx, Qz, Qab);
end

TotalRateGHZ = sum(RateList);
end
