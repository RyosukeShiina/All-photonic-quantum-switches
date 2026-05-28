function allocation = split_shared_outer_pools_by_policy(outerPools, poolingPolicy)

% I split the already-sorted shared outer-leaf pools according to the
% switch policy.
%
% poolingPolicy = "favor_Bell":
%   Bell receives the best A/B outer leaves first.
%   GHZ receives the remaining A/B resources and all C resources.
%
% poolingPolicy = "favor_GHZ":
%   GHZ receives the best A/B/C outer leaves first.
%   Bell receives the remaining A/B resources.

poolingPolicy = string(poolingPolicy);

kBell = outerPools.kBell;
kGHZ  = outerPools.kGHZ;

kA = outerPools.kA;
kB = outerPools.kB;
kC = outerPools.kC;

if kA ~= kBell + kGHZ
    error("Expected kA = kBell + kGHZ.");
end

if kB ~= kBell + kGHZ
    error("Expected kB = kBell + kGHZ.");
end

if kC ~= kGHZ
    error("Expected kC = kGHZ.");
end

allocation = struct();
allocation.poolingPolicy = poolingPolicy;

switch poolingPolicy

    case "favor_Bell"

        A_Bell_idx = 1:kBell;
        B_Bell_idx = 1:kBell;

        A_GHZ_idx = (kBell + 1):(kBell + kGHZ);
        B_GHZ_idx = (kBell + 1):(kBell + kGHZ);
        C_GHZ_idx = 1:kGHZ;

    case "favor_GHZ"

        A_GHZ_idx = 1:kGHZ;
        B_GHZ_idx = 1:kGHZ;
        C_GHZ_idx = 1:kGHZ;

        A_Bell_idx = (kGHZ + 1):(kGHZ + kBell);
        B_Bell_idx = (kGHZ + 1):(kGHZ + kBell);

    otherwise
        error('Unknown poolingPolicy. Use "favor_Bell" or "favor_GHZ".');
end

% I store the chosen sorted-pool indices.
allocation.A_Bell_idx = A_Bell_idx;
allocation.B_Bell_idx = B_Bell_idx;

allocation.A_GHZ_idx = A_GHZ_idx;
allocation.B_GHZ_idx = B_GHZ_idx;
allocation.C_GHZ_idx = C_GHZ_idx;

% I extract the Bell outer errors from the shared pool.
allocation.Bell.xA = outerPools.A.x(A_Bell_idx);
allocation.Bell.zA = outerPools.A.z(A_Bell_idx);

allocation.Bell.xB = outerPools.B.x(B_Bell_idx);
allocation.Bell.zB = outerPools.B.z(B_Bell_idx);

% I extract the GHZ outer errors from the same shared pool.
allocation.GHZ.xA = outerPools.A.x(A_GHZ_idx);
allocation.GHZ.zA = outerPools.A.z(A_GHZ_idx);

allocation.GHZ.xB = outerPools.B.x(B_GHZ_idx);
allocation.GHZ.zB = outerPools.B.z(B_GHZ_idx);

allocation.GHZ.xC = outerPools.C.x(C_GHZ_idx);
allocation.GHZ.zC = outerPools.C.z(C_GHZ_idx);

end