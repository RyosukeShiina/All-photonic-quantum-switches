function [RateList, lambdaList] = GHZRateList_Full(LA, rB, rC, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N)

tic;

SingleResults_all = SingleResults_from_ESs(LA, rB, rC, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

PauliTable = sourcePaulis();
Ns = size(PauliTable, 1);

RateList   = zeros(k,1);
lambdaList = zeros(8,k);

for ell = 1:k
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


labels = ["λ0^+","λ0^-","λ1^+","λ1^-","λ2^+","λ2^-","λ3^+","λ3^-"];

fprintf("========= λ (GHZ basis weights) =========\n");
for ell = 1:k
    fprintf("\n=== ℓ = %d ===\n", ell);
    for i = 1:8
        fprintf("%5s : %.4f\n", labels(i), lambdaList(i,ell));
        if mod(i,2) == 0
            fprintf("---------------------------\n");
        end
    end
end
fprintf("=========================================\n");


elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
end
