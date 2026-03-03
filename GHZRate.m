function [Rate, lambda] = GHZRate(LA, rB, rC, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N)

%[Rate, lambda] = GHZRate(3, 2, 3, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 3, 0.3, 1000)

SingleResults = SingleResults_from_ESs(LA, rB, rC, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);
%P = sourcePaulis();

CombinedResults = CombinedResults_from_SingleResults(SingleResults, k);

[Qx, Qz, Qab, lambda] = QxQzQab_from_CombinedResults(CombinedResults);

Rate = Rate_from_QxQzQab(Qx, Qz, Qab);

