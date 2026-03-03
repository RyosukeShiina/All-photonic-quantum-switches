function RateList = GHZRateList_Distance_k_Long(Ltotal, L, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)

%FIG1
%RateList = GHZRateList_Distance_k(9, 9, 9, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 10, 10, 10, 0.3, 1000)

tic;

SingleResults_all = SingleResults_from_ESs_Distance_k_Long(Ltotal, L, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

PauliTable = sourcePaulis();
Ns = size(PauliTable, 1);

Sk = min([kA, kB, kC]);

RateList   = zeros(Sk,1);
lambdaList = zeros(8,Sk);

for ell = 1:Sk
    SingleResults_ell = struct();
    SingleResults_ell.Probs = cell(Ns,1);

    for s = 1:Ns
        vec = SingleResults_all.Probs{s};
        if ~isvector(vec)
            error('Probs{%d} must be a vector, got size %s', s, mat2str(size(vec)));
        end
        if length(vec) < ell
            error('Probs{%d} has length %d < ell=%d', s, length(vec), ell);
        end

        SingleResults_ell.Probs{s} = vec(ell);
    end

    CombinedResults = CombinedResults_from_SingleResults(SingleResults_ell);
    [Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);
    Rate = Rate_from_QxQzQab(Qx, Qz, Qab);

    RateList(ell)     = Rate;
    lambdaList(:,ell) = lambda;
end

elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
end
