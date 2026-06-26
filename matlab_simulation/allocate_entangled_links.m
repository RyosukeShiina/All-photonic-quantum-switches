function entangledLinkAllocation = allocate_entangled_links(entangledLinkPools, policy, kA_GHZ, kB_GHZ, kC_GHZ, kA_Bell, kC_Bell, kA_Joint, kB_Joint, kC_Joint)

policy = string(policy);

if kA_Joint ~= kA_GHZ + kA_Bell
    error("Expected kA_Joint = kA_GHZ + kA_Bell.");
end

if kB_Joint ~= kB_GHZ
    error("Expected kB_Joint = kB_GHZ.");
end

if kC_Joint ~= kC_GHZ + kC_Bell
    error("Expected kC_Joint = kC_GHZ + kC_Bell.");
end

if numel(entangledLinkPools.A.x) < kA_Joint
    error("The A entangled-link pool is smaller than kA_Joint.");
end

if numel(entangledLinkPools.B.x) < kB_Joint
    error("The B entangled-link pool is smaller than kB_Joint.");
end

if numel(entangledLinkPools.C.x) < kC_Joint
    error("The C entangled-link pool is smaller than kC_Joint.");
end

entangledLinkAllocation = struct();
entangledLinkAllocation.policy = policy;

switch policy

    case "GHZ_priority"

        A_GHZ_idx = 1:kA_GHZ;
        B_GHZ_idx = 1:kB_GHZ;
        C_GHZ_idx = 1:kC_GHZ;

        A_Bell_idx = (kA_GHZ + 1):kA_Joint;
        C_Bell_idx = (kC_GHZ + 1):kC_Joint;

    case "Bell_priority"

        A_Bell_idx = 1:kA_Bell;
        C_Bell_idx = 1:kC_Bell;

        A_GHZ_idx = (kA_Bell + 1):kA_Joint;
        B_GHZ_idx = 1:kB_GHZ;
        C_GHZ_idx = (kC_Bell + 1):kC_Joint;

    otherwise
        error('Unknown policy. Use "Bell_priority" or "GHZ_priority".');
end


entangledLinkAllocation.A_GHZ_idx = A_GHZ_idx;
entangledLinkAllocation.B_GHZ_idx = B_GHZ_idx;
entangledLinkAllocation.C_GHZ_idx = C_GHZ_idx;

entangledLinkAllocation.A_Bell_idx = A_Bell_idx;
entangledLinkAllocation.C_Bell_idx = C_Bell_idx;



entangledLinkAllocation.GHZ.A.x = entangledLinkPools.A.x(A_GHZ_idx);
entangledLinkAllocation.GHZ.A.z = entangledLinkPools.A.z(A_GHZ_idx);

entangledLinkAllocation.GHZ.B.x = entangledLinkPools.B.x(B_GHZ_idx);
entangledLinkAllocation.GHZ.B.z = entangledLinkPools.B.z(B_GHZ_idx);

entangledLinkAllocation.GHZ.C.x = entangledLinkPools.C.x(C_GHZ_idx);
entangledLinkAllocation.GHZ.C.z = entangledLinkPools.C.z(C_GHZ_idx);

entangledLinkAllocation.Bell.A.x = entangledLinkPools.A.x(A_Bell_idx);
entangledLinkAllocation.Bell.A.z = entangledLinkPools.A.z(A_Bell_idx);

entangledLinkAllocation.Bell.C.x = entangledLinkPools.C.x(C_Bell_idx);
entangledLinkAllocation.Bell.C.z = entangledLinkPools.C.z(C_Bell_idx);


end

