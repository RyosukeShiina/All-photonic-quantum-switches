clear;
clc;

% I add all folders needed by the shared-pooling simulation.
addpath("shared");
addpath("bell");
addpath("ghz");
addpath("existing_physics_functions");

% ------------------------------------------------------------
% I define the physical parameters.
% A, B, and C all have 9 km spacing.
% ------------------------------------------------------------

params = struct();

params.LA = 9;
params.LB = 9;
params.LC = 9;

params.sigGKP  = 0.12;
params.etas    = 0.995;
params.etam    = 0.999995;
params.etad    = 0.9975;
params.etac    = 0.99;
params.Lcavity = 2;

params.v = 0.3;
params.N = 100;

% ------------------------------------------------------------
% I define the six test points for kTotal = 40.
% These are raw resource-budget pairs, not mode counts.
% ------------------------------------------------------------

kTotal = 40;

testPairs = [
    31,  9;
    30, 10;
    29, 11;
    28, 12;
    27, 13;
    26, 14
];

poolingPolicies = ["favor_Bell", "favor_GHZ"];

% ------------------------------------------------------------
% I prepare the results folder.
% This folder is created automatically if it does not exist.
% ------------------------------------------------------------

resultsFolder = "pooling_policy_results";

if ~exist(resultsFolder, "dir")
    mkdir(resultsFolder);
end

tstart = tic;

fprintf("******* Six-point shared-pooling test has started. *******\n");

% ------------------------------------------------------------
% I prepare separate output matrices for the two policies.
% ------------------------------------------------------------

numPairs = size(testPairs, 1);
outFavorBell = zeros(numPairs, 11);
outFavorGHZ  = zeros(numPairs, 11);

for pairIndex = 1:numPairs

    kBellBudget = testPairs(pairIndex, 1);
    kGHZBudget  = testPairs(pairIndex, 2);

    if kBellBudget + kGHZBudget ~= kTotal
        error("Each test pair must satisfy kBell + kGHZ = kTotal.");
    end

    % I convert raw resource budgets into actual Bell/GHZ mode counts.
    kBellModes = floor(kBellBudget / 2);
    kGHZModes  = floor(kGHZBudget  / 3);

    kA = kBellModes + kGHZModes;
    kB = kBellModes + kGHZModes;
    kC = kGHZModes;

    fprintf("\nPair %d / %d\n", pairIndex, numPairs);
    fprintf("  raw budgets: kBell = %d, kGHZ = %d\n", kBellBudget, kGHZBudget);
    fprintf("  modes:       Bell = %d, GHZ = %d\n", kBellModes, kGHZModes);
    fprintf("  users:       kA = %d, kB = %d, kC = %d\n", kA, kB, kC);
    fprintf("  elapsed %.1f s\n", toc(tstart));

    % ------------------------------------------------------------
    % I create one shared sorted outer-leaf pool for this pair.
    %
    % Important:
    % I generate the outer pool once, then evaluate both policies on that
    % same pool. This makes the favor_Bell versus favor_GHZ comparison
    % less noisy.
    % ------------------------------------------------------------

    outerPools = make_shared_outer_pools(kBellModes, kGHZModes, params);

    for policyIndex = 1:numel(poolingPolicies)

        poolingPolicy = poolingPolicies(policyIndex);

        fprintf("    Policy: %s\n", poolingPolicy);

        % I split the same shared pool according to the current policy.
        allocation = split_shared_outer_pools_by_policy(outerPools, poolingPolicy);

        % I compute Bell from the Bell-assigned outer leaves.
        [rateBell, ~] = BellRate_from_outer_errors( ...
            allocation.Bell.xA, allocation.Bell.zA, ...
            allocation.Bell.xB, allocation.Bell.zB, ...
            params);

        % I compute GHZ from the GHZ-assigned outer leaves.
        [rateGHZ, ~] = GHZRate_from_outer_errors( ...
            allocation.GHZ.xA, allocation.GHZ.zA, ...
            allocation.GHZ.xB, allocation.GHZ.zB, ...
            allocation.GHZ.xC, allocation.GHZ.zC, ...
            params);

        rateTotal = rateBell + rateGHZ;

        row = [ ...
            kTotal, ...
            kBellBudget, ...
            kGHZBudget, ...
            rateTotal, ...
            rateBell, ...
            rateGHZ, ...
            kBellModes, ...
            kGHZModes, ...
            kA, ...
            kB, ...
            kC];

        if poolingPolicy == "favor_Bell"
            outFavorBell(pairIndex, :) = row;
        elseif poolingPolicy == "favor_GHZ"
            outFavorGHZ(pairIndex, :) = row;
        else
            error("Unknown pooling policy.");
        end

        fprintf("      R_Bell  = %.12g\n", rateBell);
        fprintf("      R_GHZ   = %.12g\n", rateGHZ);
        fprintf("      R_total = %.12g\n", rateTotal);

    end
end

% ------------------------------------------------------------
% I convert the output matrices into tables.
% ------------------------------------------------------------

variableNames = { ...
    'kTotal', ...
    'kBell', ...
    'kGHZ', ...
    'rateTotal', ...
    'rateBell', ...
    'rateGHZ', ...
    'kBellModes', ...
    'kGHZModes', ...
    'kA', ...
    'kB', ...
    'kC'};

T_favorBell = array2table(outFavorBell, 'VariableNames', variableNames);
T_favorGHZ  = array2table(outFavorGHZ,  'VariableNames', variableNames);

% ------------------------------------------------------------
% I save one CSV file for each policy.
% ------------------------------------------------------------

csvFavorBell = fullfile(resultsFolder, ...
    sprintf("six_point_kTotal_%d_favor_Bell_N_%d.csv", kTotal, params.N));

csvFavorGHZ = fullfile(resultsFolder, ...
    sprintf("six_point_kTotal_%d_favor_GHZ_N_%d.csv", kTotal, params.N));

writetable(T_favorBell, csvFavorBell);
writetable(T_favorGHZ,  csvFavorGHZ);

% I also save one MAT file with both tables and parameters.
matPath = fullfile(resultsFolder, ...
    sprintf("six_point_kTotal_%d_both_policies_N_%d.mat", kTotal, params.N));

save(matPath, ...
    "T_favorBell", ...
    "T_favorGHZ", ...
    "params", ...
    "kTotal", ...
    "testPairs");

fprintf("\n******* Six-point test completed. *******\n");
fprintf("Saved files:\n");
fprintf("  %s\n", csvFavorBell);
fprintf("  %s\n", csvFavorGHZ);
fprintf("  %s\n", matPath);

elapsedTime = toc(tstart);
fprintf("Simulation duration: %.3f seconds\n", elapsedTime);