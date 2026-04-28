function rateBell = BellRate(LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kD, kE, v, N)


if kD == 0 || kE == 0
    rateBell = 0;
    return;
end

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



%If the D-side and E-side outer leaves have identical parameters, we only simulate them once and reuse the result for both sides.
%Otherwise, we simulate the two sides separately.
if LD == LE && kD == kE
    ZerrOuterD = zeros(kD, 1);
    XerrOuterD = zeros(kD, 1);
    parfor i = 1:N
        logErrOuter = UW3_OuterLeaves(LD, sigGKP, etas, etad, etac, kD, ErrProbVec);
        ZerrOuterD = ZerrOuterD + logErrOuter(:, 1);
        XerrOuterD = XerrOuterD + logErrOuter(:, 2);
    end
    ZerrOuterD = ZerrOuterD / N;
    XerrOuterD = XerrOuterD / N;
    % Reuse the same outer-leaf error probabilities for the E side.
    ZerrOuterE = ZerrOuterD;
    XerrOuterE = XerrOuterD;
else
    ZerrOuterD = zeros(kD, 1);
    XerrOuterD = zeros(kD, 1);
    ZerrOuterE = zeros(kE, 1);
    XerrOuterE = zeros(kE, 1);
    parfor i = 1:N
        logErrOuterD = UW3_OuterLeaves(LD, sigGKP, etas, etad, etac, kD, ErrProbVec);
        ZerrOuterD = ZerrOuterD + logErrOuterD(:, 1);
        XerrOuterD = XerrOuterD + logErrOuterD(:, 2);
    end
    ZerrOuterD = ZerrOuterD / N;
    XerrOuterD = XerrOuterD / N;
    parfor i = 1:N
        logErrOuterE = UW3_OuterLeaves(LE, sigGKP, etas, etad, etac, kE, ErrProbVec);
        ZerrOuterE = ZerrOuterE + logErrOuterE(:, 1);
        XerrOuterE = XerrOuterE + logErrOuterE(:, 2);
    end
    ZerrOuterE = ZerrOuterE / N;
    XerrOuterE = XerrOuterE / N;
end


% ZerrOuterD, XerrOuterD, ZerrOuterE, and XerrOuterE are already sorted in descending order of quality by UW3_OuterLeaves. Therefore, when kD ~= kE, we keep the first min(kD, kE) entries.

numMatchedOuterLeaves = min(numel(ZerrOuterD), numel(ZerrOuterE));
ZerrOuterD = ZerrOuterD(1:numMatchedOuterLeaves);
XerrOuterD = XerrOuterD(1:numMatchedOuterLeaves);
ZerrOuterE = ZerrOuterE(1:numMatchedOuterLeaves);
XerrOuterE = XerrOuterE(1:numMatchedOuterLeaves);


%Inner-leaves swapping
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





Zerr = ZerrOuterD .* (1 - ZerrInner) .* (1 - ZerrOuterE) ...
     + (1 - ZerrOuterD) .* ZerrInner .* (1 - ZerrOuterE) ...
     + (1 - ZerrOuterD) .* (1 - ZerrInner) .* ZerrOuterE ...
     + ZerrOuterD .* ZerrInner .* ZerrOuterE;

Xerr = XerrOuterD .* (1 - XerrInner) .* (1 - XerrOuterE) ...
     + (1 - XerrOuterD) .* XerrInner .* (1 - XerrOuterE) ...
     + (1 - XerrOuterD) .* (1 - XerrInner) .* XerrOuterE ...
     + XerrOuterD .* XerrInner .* XerrOuterE;

rateBell = R_SecretKey6State_total(Zerr, Xerr);
end
