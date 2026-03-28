LA = 9; LB = 9; LC = 9; LD = 9; LE = 9;
ktotalmax = 50;
N = 1000000;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

tstart = tic;

% unique values actually used
kDmax = floor(ktotalmax/2);   % 12
kAmax = floor(ktotalmax/3);   % 8

BellRateCache = zeros(kDmax+1, 1);
GHZRateCache  = zeros(kAmax+1, 1);

fprintf("Precomputing Bell cache...\n");
for kD = 0:kDmax
    fprintf("  kD=%d/%d\n", kD, kDmax);
    BellRateCache(kD+1) = Precompute_BellRate( ...
        LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kD, v, N);
end

fprintf("Precomputing GHZ cache...\n");
for kA = 0:kAmax
    fprintf("  kA=%d/%d\n", kA, kAmax);
    GHZRateCache(kA+1) = Precompute_GHZRate( ...
        LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, v, N);
end

AllRows = 0;
for ktotal = 1:ktotalmax
    AllRows = AllRows + (ktotal+1)*(ktotal+2)/2;
end

out = zeros(AllRows, 6);
idx = 1;

disp("*******The simulation has started.*******");
for ktotal = 1:ktotalmax
    fprintf("ktotal=%d/%d | elapsed %.1f s\n", ktotal, ktotalmax, toc(tstart));

    for kBell = 0:ktotal
        for kGHZ = 0:(ktotal - kBell)

            kA = floor(kGHZ/3);
            kD = floor(kBell/2);

            TotalRateBell = BellRateCache(kD+1);
            TotalRateGHZ  = GHZRateCache(kA+1);
            TotalRate     = TotalRateBell + TotalRateGHZ;

            out(idx,:) = [ktotal, kBell, kGHZ, TotalRate, TotalRateBell, TotalRateGHZ];
            idx = idx + 1;
        end
    end
end

disp("*******All loops completed.*******");

T = array2table(out, 'VariableNames', ...
    {'ktotal','kBell','kGHZ','TotalRate','TotalRateBell','TotalRateGHZ'});

writetable(T, 'Idea1.csv');

disp("*******The simulation has finished.*******");
elapsedTime = toc(tstart);
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
