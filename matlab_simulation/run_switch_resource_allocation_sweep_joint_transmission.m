LA = 9;
LB = 9;
LC = 9;

kSWMax = 50;
N = 1000000;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

tstart = tic;

disp("*******The simulation has started.*******");

policies = ["GHZ_priority", "Bell_priority"];

numRows = 0;
for kSW = 1:kSWMax
    numRows = numRows + numel(policies)*(kSW + 1);
end

out = zeros(numRows, 15);
idx = 1;

for kSW = 1:kSWMax
    fprintf("kSW=%d/%d | elapsed %.1f s\n", kSW, kSWMax, toc(tstart));

    for kGHZ = 0:kSW
        kBell = kSW - kGHZ;

        kA_GHZ = floor(kGHZ/3);
        kB_GHZ = floor(kGHZ/3);
        kC_GHZ = floor(kGHZ/3);

        kA_Bell = floor(kBell/2);
        kC_Bell = floor(kBell/2);

        kA_Joint = kA_GHZ + kA_Bell;
        kB_Joint = kB_GHZ;
        kC_Joint = kC_GHZ + kC_Bell;

        entangledLinkPools = make_entangled_link_pools(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA_Joint, kB_Joint, kC_Joint, v, N);

        for policyIndex = 1:numel(policies)
            policy = policies(policyIndex);

            entangledLinkAllocation = allocate_entangled_links(entangledLinkPools, policy, kA_GHZ, kB_GHZ, kC_GHZ, kA_Bell, kC_Bell, kA_Joint, kB_Joint, kC_Joint);

            rateGHZ = GHZRate_from_allocated_links(entangledLinkAllocation, LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, v, N);

            rateBell = BellRate_from_allocated_links(entangledLinkAllocation, LA, LC, sigGKP, etas, etam, etad, etac, Lcavity, v, N);

            rateSum = rateGHZ + rateBell;

            out(idx,:) = [kSW, kGHZ, kBell, kA_GHZ, kB_GHZ, kC_GHZ, kA_Bell, kC_Bell, kA_Joint, kB_Joint, kC_Joint, policyIndex, rateSum, rateGHZ, rateBell];

            idx = idx + 1;
        end
    end
end

disp("*******All loops completed.*******");

T = array2table(out, 'VariableNames', { ...
    'kSW', ...
    'kGHZ', ...
    'kBell', ...
    'kA_GHZ', ...
    'kB_GHZ', ...
    'kC_GHZ', ...
    'kA_Bell', ...
    'kC_Bell', ...
    'kA_Joint', ...
    'kB_Joint', ...
    'kC_Joint', ...
    'policy', ...
    'rateSum', ...
    'rateGHZ', ...
    'rateBell'});

T.policy = policies(T.policy).';

writetable(T, 'run_switch_resource_allocation_sweep_joint_transmission.csv');

disp("*******The simulation has finished.*******");
elapsedTime = toc(tstart);
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
