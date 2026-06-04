LA = 9;
LB = 9;
LC = 9;
LD = 9;
LE = 9;

kSWMax = 50;
N = 10000000;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

tstart = tic;

disp("*******The simulation has started.*******");

kAMax = floor(kSWMax/4);
kDMax = floor(kSWMax/2);

GHZRateCache  = zeros(kAMax+1, 1);
BellRateCache = zeros(kDMax+1, 1);

fprintf("Precomputing GHZ rate cache...\n");
tGHZ = tic;
for kA = 0:kAMax
    tIter = tic;
    GHZRateCache(kA+1) = GHZRate_end_node(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kA, kA, kA, v, N);
    iterTime = toc(tIter);
    fprintf("kA=%d/%d | iter %.2f s | GHZ elapsed %.1f s | total elapsed %.1f s\n", kA, kAMax, iterTime, toc(tGHZ), toc(tstart));
end

fprintf("Precomputing Bell rate cache...\n");
tBell = tic;
for kD = 0:kDMax
    tIter = tic;
    BellRateCache(kD+1) = BellRate(LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kD, kD, v, N);
    iterTime = toc(tIter);
    fprintf("kD=%d/%d | iter %.2f s | Bell elapsed %.1f s | total elapsed %.1f s\n", kD, kDMax, iterTime, toc(tBell), toc(tstart));
end

numRows = 0;
for kSW = 1:kSWMax
    numRows = numRows + (kSW + 1);
end

out = zeros(numRows, 8);
idx = 1;

for kSW = 1:kSWMax
    fprintf("kSW=%d/%d | elapsed %.1f s\n", kSW, kSWMax, toc(tstart));
    for kGHZ = 0:kSW
        kBell = kSW - kGHZ;

        kA = floor(kGHZ/4);
        kD = floor(kBell/2);

        rateGHZ = GHZRateCache(kA+1);
        rateBell = BellRateCache(kD+1);
        rateSum = rateGHZ + rateBell;

        out(idx,:) = [kSW, kGHZ, kBell, kA, kD, rateSum, rateGHZ, rateBell];
        idx = idx + 1;
    end
end

disp("*******All loops completed.*******");

T = array2table(out, 'VariableNames', {'kSW', 'kGHZ', 'kBell', 'kA', 'kD', 'rateSum', 'rateGHZ', 'rateBell'});

writetable(T, 'switch_resource_allocation_sweep_end_node.csv');

disp("*******The simulation has finished.*******");
elapsedTime = toc(tstart);
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
