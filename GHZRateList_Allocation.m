function [TotalRate, TotalRateBell, TotalRateGHZ, kswitch, kGHZ, kBell] = GHZRateList_Allocation(LA, LB, LC, LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, kD, kE, v, N)



%[TotalRate, TotalRateBell, TotalRateGHZ, kswitch, kGHZ, kBell] = GHZRateList_Allocation(5, 5, 5, 5, 5, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 10, 10, 10, 10, 10, 0.3, 1000)

tic;

kswitch = kA + kB + kC + kD + kE;


%%%%%%%%%%%%%%%%%Bell Group%%%%%%%%%%%%%%%%%%%

sigmasPostselect = zeros(1, 11);
sigmasPostselect(1) = sqrt(3*sigGKP^2 + (1-etad)/etad);
sigmasPostselect(2) = sqrt(3*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(3) = sqrt(3*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(4) = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(5) = sqrt(2*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(6) = sqrt(3*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(7) = sqrt(3*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(8) = sqrt(2*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(9) = sqrt(2*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(10) = sqrt(3*sigGKP^2 + 1 - etas + (1-etad)/etad);
sigmasPostselect(11) = sqrt(2*sigGKP^2 + 1 - etas + (1-etad)/etad);
% Measurement without postselection
sigmasNoPost = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
vVec = R_Find_v(sigmasPostselect, R_LogErrAfterPost(sigmasPostselect(7),v), v+0.1);
ErrProbVec = zeros(1,12);
pVec = zeros(1,12);
for i = 1:11
    [ErrProbVec(i), pVec(i)] = R_LogErrAfterPost(sigmasPostselect(i), vVec(i));
end
[ErrProbVec(12), pVec(12)] = R_LogErrAfterPost(sigmasNoPost, 0);



ZerrOuterD = zeros(kD, 1);
XerrOuterD = zeros(kD, 1);
parfor i = 1:N
    logErrOuter = UW3_OuterLeaves(LD, sigGKP, etas, etad, etac, kD, ErrProbVec);
    ZerrOuterD = ZerrOuterD + logErrOuter(:,1);
    XerrOuterD = XerrOuterD + logErrOuter(:,2);
end
ZerrOuterD = ZerrOuterD/N;
XerrOuterD = XerrOuterD/N;

ZerrOuterE = zeros(kE, 1);
XerrOuterE = zeros(kE, 1);
parfor i = 1:N
    logErrOuter = UW3_OuterLeaves(LE, sigGKP, etas, etad, etac, kE, ErrProbVec);
    ZerrOuterE = ZerrOuterE + logErrOuter(:,1);
    XerrOuterE = XerrOuterE + logErrOuter(:,2);
end
ZerrOuterE = ZerrOuterE/N;
XerrOuterE = XerrOuterE/N;

LDE = max(LE, LD);
ZerrInner = 0;
XerrInner = 0;
parfor i = 1:N
    logErrInner = UW3_InnerLeaves(LDE, sigGKP, etas, etam, etad, etac, Lcavity, ErrProbVec);
    ZerrInner = ZerrInner + logErrInner(1);
    XerrInner = XerrInner + logErrInner(2);
end
ZerrInner = ZerrInner/N;
XerrInner = XerrInner/N;

k = min([size(ZerrOuterD,1), size(ZerrOuterE,1)]);
ZerrOuterD = ZerrOuterD(1:k);
ZerrOuterE = ZerrOuterE(1:k);
XerrOuterD = XerrOuterD(1:k);
XerrOuterE = XerrOuterE(1:k);
ZerrInnerVec = ZerrInner*ones(k,1);
XerrInnerVec = XerrInner*ones(k,1);


Zerr = ZerrOuterD .* (1 - ZerrInnerVec) .* (1 - ZerrOuterE) ...
     + (1 - ZerrOuterD) .* ZerrInnerVec .* (1 - ZerrOuterE) ...
     + (1 - ZerrOuterD) .* (1 - ZerrInnerVec) .* ZerrOuterE ...
     + ZerrOuterD .* ZerrInnerVec .* ZerrOuterE;


Xerr = XerrOuterD .* (1 - XerrInnerVec) .* (1 - XerrOuterE) ...
     + (1 - XerrOuterD) .* XerrInnerVec .* (1 - XerrOuterE) ...
     + (1 - XerrOuterD) .* (1 - XerrInnerVec) .* XerrOuterE ...
     + XerrOuterD .* XerrInnerVec .* XerrOuterE;


TotalRateBell = R_SecretKey6State_total(Zerr, Xerr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SingleResults_all = SingleResults_from_ESs_Distance_k(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

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

TotalRateGHZ = sum(RateList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TotalRate = TotalRateBell + TotalRateGHZ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elapsedTime = toc;
%fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
end
