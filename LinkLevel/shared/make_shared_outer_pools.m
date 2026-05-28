function outerPools = make_shared_outer_pools(kBell, kGHZ, params)

% I create one shared outer-leaf resource pool for users A, B, and C.
%
% Here kBell and kGHZ are the actual number of Bell and GHZ modes,
% not the raw resource budgets.
%
% The resource accounting is:
%
%   kA = kBell + kGHZ
%   kB = kBell + kGHZ
%   kC = kGHZ

if kBell < 0 || kGHZ < 0
    error("kBell and kGHZ must be nonnegative.");
end

if mod(kBell, 1) ~= 0 || mod(kGHZ, 1) ~= 0
    error("kBell and kGHZ must be integers.");
end

kA = kBell + kGHZ;
kB = kBell + kGHZ;
kC = kGHZ;

% ------------------------------------------------------------
% I generate A's outer pool if A has any assigned resources.
% ------------------------------------------------------------

if kA > 0
    [xOuterA, zOuterA] = outer_leaves_swapping_and_construction( ...
        params.LA, ...
        params.sigGKP, params.etas, params.etam, ...
        params.etad, params.etac, params.Lcavity, ...
        kA, params.v, params.N);

    [xOuterA, zOuterA] = sort_xz_by_total_error(xOuterA, zOuterA);
else
    xOuterA = [];
    zOuterA = [];
end

% ------------------------------------------------------------
% I generate B's outer pool if B has any assigned resources.
% ------------------------------------------------------------

if kB > 0
    [xOuterB, zOuterB] = outer_leaves_swapping_and_construction( ...
        params.LB, ...
        params.sigGKP, params.etas, params.etam, ...
        params.etad, params.etac, params.Lcavity, ...
        kB, params.v, params.N);

    [xOuterB, zOuterB] = sort_xz_by_total_error(xOuterB, zOuterB);
else
    xOuterB = [];
    zOuterB = [];
end

% ------------------------------------------------------------
% I generate C's outer pool only if there are GHZ modes.
% ------------------------------------------------------------

if kC > 0
    [xOuterC, zOuterC] = outer_leaves_swapping_and_construction( ...
        params.LC, ...
        params.sigGKP, params.etas, params.etam, ...
        params.etad, params.etac, params.Lcavity, ...
        kC, params.v, params.N);

    [xOuterC, zOuterC] = sort_xz_by_total_error(xOuterC, zOuterC);
else
    xOuterC = [];
    zOuterC = [];
end

outerPools = struct();

outerPools.kBell = kBell;
outerPools.kGHZ  = kGHZ;

outerPools.kA = kA;
outerPools.kB = kB;
outerPools.kC = kC;

outerPools.A.x = xOuterA(:);
outerPools.A.z = zOuterA(:);

outerPools.B.x = xOuterB(:);
outerPools.B.z = zOuterB(:);

outerPools.C.x = xOuterC(:);
outerPools.C.z = zOuterC(:);

end