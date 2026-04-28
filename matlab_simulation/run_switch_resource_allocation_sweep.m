LA = 9;
LB = 9;
LC = 9;
LD = 9;
LE = 9;

kTotalMax = 50;
N = 1000000;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

tstart = tic;

kAMax = floor(kTotalMax/3);
kDMax = floor(kTotalMax/2);

GHZRateCache  = zeros(kAMax+1, 1);
BellRateCache = zeros(kDMax+1, 1);

fprintf("Precomputing GHZ rate cache...\n");
for kA = 0:kAMax
    fprintf("kA=%d/%d\n", kA, kAMax);
    GHZRateCache(kA+1) = GHZRate(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);
end

fprintf("Precomputing Bell rate cache...\n");
for kD = 0:kDMax
    fprintf("kD=%d/%d\n", kD, kDMax);
    BellRateCache(kD+1) = BellRate(LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kD, kE, v, N);
end

numRows = 0;
for kTotal = 1:kTotalMax
    numRows = numRows + (kTotal+1)*(kTotal+2)/2;
end

out = zeros(numRows, 6);
idx = 1;

disp("*******The simulation has started.*******");
for kTotal = 1:kTotalMax
    fprintf("kTotal=%d/%d | elapsed %.1f s\n", kTotal, kTotalMax, toc(tstart));
    for kBell = 0:kTotal
        for kGHZ = 0:(kTotal - kBell)

            kA = floor(kGHZ/3);
            kD = floor(kBell/2);

            rateBell = BellRateCache(kD+1);
            rateGHZ = GHZRateCache(kA+1);
            rateTotal = rateBell + rateGHZ;

            out(idx,:) = [kTotal, kBell, kGHZ, rateTotal, rateBell, rateGHZ];
            idx = idx + 1;
        end
    end
end

disp("*******All loops completed.*******");

T = array2table(out, 'VariableNames', {'kTotal','kBell','kGHZ','rateTotal','rateBell','rateGHZ'});

writetable(T, 'switch_resource_allocation_sweep.csv');

disp("*******The simulation has finished.*******");
elapsedTime = toc(tstart);
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
