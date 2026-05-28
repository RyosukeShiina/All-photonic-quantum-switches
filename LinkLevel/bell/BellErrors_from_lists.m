function bellErr = BellErrors_from_lists( ...
    LA, LB, sigGKP, etas, etam, etad, etac, Lcavity, ...
    Aidx, Bidx, v, N)

if isempty(Aidx) || isempty(Bidx)
    bellErr.Xerr = [];
    bellErr.Zerr = [];
    bellErr.numBell = 0;
    return;
end

Aidx = Aidx(:).';
Bidx = Bidx(:).';

Aidx = Aidx(Aidx > 0);
Bidx = Bidx(Bidx > 0);

if isempty(Aidx) || isempty(Bidx)
    bellErr.Xerr = [];
    bellErr.Zerr = [];
    bellErr.numBell = 0;
    return;
end

if any(mod(Aidx, 1) ~= 0) || any(mod(Bidx, 1) ~= 0)
    error("Aidx and Bidx must contain positive integer indices.");
end

kAmax = max(Aidx);
kBmax = max(Bidx);

[xOuterAAll, zOuterAAll] = outer_leaves_swapping_and_construction( ...
    LA, sigGKP, etas, etam, etad, etac, Lcavity, kAmax, v, N);

[xOuterBAll, zOuterBAll] = outer_leaves_swapping_and_construction( ...
    LB, sigGKP, etas, etam, etad, etac, Lcavity, kBmax, v, N);

xOuterA = xOuterAAll(Aidx);
zOuterA = zOuterAAll(Aidx);

xOuterB = xOuterBAll(Bidx);
zOuterB = zOuterBAll(Bidx);

[xOuterA, zOuterA] = sort_xz_by_total_error(xOuterA, zOuterA);
[xOuterB, zOuterB] = sort_xz_by_total_error(xOuterB, zOuterB);

numBell = min(numel(xOuterA), numel(xOuterB));

xOuterA = xOuterA(1:numBell);
zOuterA = zOuterA(1:numBell);

xOuterB = xOuterB(1:numBell);
zOuterB = zOuterB(1:numBell);

LAB = max(LA, LB);

[xInner, zInner] = inner_leaves_swapping_and_construction( ...
    LAB, sigGKP, etas, etam, etad, etac, Lcavity, numBell, v, N);

Zerr = odd_parity_3(zOuterA, zInner, zOuterB);
Xerr = odd_parity_3(xOuterA, xInner, xOuterB);

bellErr.Xerr = Xerr(:);
bellErr.Zerr = Zerr(:);
bellErr.numBell = numBell;

end