function rateBell = BellRate_from_allocated_links(entangledLinkAllocation, LA, LC, sigGKP, etas, etam, etad, etac, Lcavity, v, N)

if isempty(entangledLinkAllocation.Bell.A.x) || ...
   isempty(entangledLinkAllocation.Bell.A.z) || ...
   isempty(entangledLinkAllocation.Bell.C.x) || ...
   isempty(entangledLinkAllocation.Bell.C.z)
    rateBell = 0;
    return;
end

XerrOuterA = entangledLinkAllocation.Bell.A.x;
ZerrOuterA = entangledLinkAllocation.Bell.A.z;

XerrOuterC = entangledLinkAllocation.Bell.C.x;
ZerrOuterC = entangledLinkAllocation.Bell.C.z;

numMatchedOuterLeaves = min([numel(ZerrOuterA), numel(XerrOuterA), numel(ZerrOuterC), numel(XerrOuterC)]);

ZerrOuterA = ZerrOuterA(1:numMatchedOuterLeaves);
XerrOuterA = XerrOuterA(1:numMatchedOuterLeaves);

ZerrOuterC = ZerrOuterC(1:numMatchedOuterLeaves);
XerrOuterC = XerrOuterC(1:numMatchedOuterLeaves);



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






%Inner-leaves swapping
LAC = max(LA, LC);

ZerrInner = 0;
XerrInner = 0;

parfor i = 1:N
    logErrInner = UW3_InnerLeaves(LAC, sigGKP, etas, etam, etad, etac, Lcavity, ErrProbVec);
    ZerrInner = ZerrInner + logErrInner(1);
    XerrInner = XerrInner + logErrInner(2);
end

ZerrInner = ZerrInner/N;
XerrInner = XerrInner/N;





Zerr = ZerrOuterA .* (1 - ZerrInner) .* (1 - ZerrOuterC) ...
     + (1 - ZerrOuterA) .* ZerrInner .* (1 - ZerrOuterC) ...
     + (1 - ZerrOuterA) .* (1 - ZerrInner) .* ZerrOuterC ...
     + ZerrOuterA .* ZerrInner .* ZerrOuterC;

Xerr = XerrOuterA .* (1 - XerrInner) .* (1 - XerrOuterC) ...
     + (1 - XerrOuterA) .* XerrInner .* (1 - XerrOuterC) ...
     + (1 - XerrOuterA) .* (1 - XerrInner) .* XerrOuterC ...
     + XerrOuterA .* XerrInner .* XerrOuterC;

rateBell = R_SecretKey6State_total(Zerr, Xerr);
end
