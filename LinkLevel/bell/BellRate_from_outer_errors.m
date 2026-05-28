function [rateBell, bellErr] = BellRate_from_outer_errors( ...
    xOuterA, zOuterA, xOuterB, zOuterB, params)

% I compute the Bell rate from already-generated outer-leaf errors.
%
% This function is for the shared-pooling switch model.
% The outer leaves are not generated here.
% They are generated once at the switch level, sorted once, and then passed
% into this function after the pooling policy assigns them to Bell.

if isempty(xOuterA) || isempty(zOuterA) || isempty(xOuterB) || isempty(zOuterB)
    bellErr.Xerr = [];
    bellErr.Zerr = [];
    bellErr.numBell = 0;
    rateBell = 0;
    return;
end

xOuterA = xOuterA(:);
zOuterA = zOuterA(:);
xOuterB = xOuterB(:);
zOuterB = zOuterB(:);

numBell = min([numel(xOuterA), numel(zOuterA), numel(xOuterB), numel(zOuterB)]);

if numBell == 0
    bellErr.Xerr = [];
    bellErr.Zerr = [];
    bellErr.numBell = 0;
    rateBell = 0;
    return;
end

% I keep the already-sorted, already-assigned Bell resources.
xOuterA = xOuterA(1:numBell);
zOuterA = zOuterA(1:numBell);

xOuterB = xOuterB(1:numBell);
zOuterB = zOuterB(1:numBell);

% I use the Bell waiting distance.
% The Bell inner leaves only need to wait for the slower of users A and B.
LBell = max(params.LA, params.LB);

[xInner, zInner] = inner_leaves_swapping_and_construction( ...
    LBell, ...
    params.sigGKP, params.etas, params.etam, ...
    params.etad, params.etac, params.Lcavity, ...
    numBell, params.v, params.N);

% I combine A outer, inner, and B outer errors using odd parity.
Zerr = odd_parity_3(zOuterA, zInner, zOuterB);
Xerr = odd_parity_3(xOuterA, xInner, xOuterB);

bellErr = struct();
bellErr.Xerr = Xerr(:);
bellErr.Zerr = Zerr(:);
bellErr.numBell = numBell;

rateBell = BellRate_from_errors(bellErr);

end