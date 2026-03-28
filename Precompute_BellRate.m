function TotalRateBell = Precompute_BellRate(LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kD, v, N)

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

sigmasNoPost = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
vVec = R_Find_v(sigmasPostselect, R_LogErrAfterPost(sigmasPostselect(7),v), v+0.1);

ErrProbVec = zeros(1,12);
pVec = zeros(1,12);
for i = 1:11
    [ErrProbVec(i), pVec(i)] = R_LogErrAfterPost(sigmasPostselect(i), vVec(i));
end
[ErrProbVec(12), pVec(12)] = R_LogErrAfterPost(sigmasNoPost, 0);

if kD == 0
    TotalRateBell = 0;
    return;
end

% Outer: LD=LE and kD=kE in your current setup, so only do once
ZerrOuter = zeros(kD, 1);
XerrOuter = zeros(kD, 1);
parfor i = 1:N
    logErrOuter = UW3_OuterLeaves(LD, sigGKP, etas, etad, etac, kD, ErrProbVec);
    ZerrOuter = ZerrOuter + logErrOuter(:,1);
    XerrOuter = XerrOuter + logErrOuter(:,2);
end
ZerrOuter = ZerrOuter / N;
XerrOuter = XerrOuter / N;

LDE = max(LE, LD);
ZerrInner = 0;
XerrInner = 0;
parfor i = 1:N
    logErrInner = UW3_InnerLeaves(LDE, sigGKP, etas, etam, etad, etac, Lcavity, ErrProbVec);
    ZerrInner = ZerrInner + logErrInner(1);
    XerrInner = XerrInner + logErrInner(2);
end
ZerrInner = ZerrInner / N;
XerrInner = XerrInner / N;

Zerr = ZerrOuter .* (1 - ZerrInner) .* (1 - ZerrOuter) ...
     + (1 - ZerrOuter) .* ZerrInner .* (1 - ZerrOuter) ...
     + (1 - ZerrOuter) .* (1 - ZerrInner) .* ZerrOuter ...
     + ZerrOuter .* ZerrInner .* ZerrOuter;

Xerr = XerrOuter .* (1 - XerrInner) .* (1 - XerrOuter) ...
     + (1 - XerrOuter) .* XerrInner .* (1 - XerrOuter) ...
     + (1 - XerrOuter) .* (1 - XerrInner) .* XerrOuter ...
     + XerrOuter .* XerrInner .* XerrOuter;

TotalRateBell = R_SecretKey6State_total(Zerr, Xerr);
end
