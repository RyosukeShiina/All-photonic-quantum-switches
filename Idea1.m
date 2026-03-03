LA = 9;
LB = 9;
LC = 9;
LD = 9;
LE = 9;

ktotalmax = 25;
N = 100000;


sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

tstart = tic;

AllRows = 0;
for ktotal = 1:1:ktotalmax
    AllRows = AllRows+(ktotal+1)*(ktotal+2)/2;
end

out = zeros(AllRows, 6);
idx = 1;

disp("*******The simulation has started.*******");
for ktotal = 1:1:ktotalmax
    %disp("Starting loop ktotal=" + string(ktotal))
    fprintf("ktotal=%d/%d | elapsed %.1f s\n", ktotal, ktotalmax, toc(tstart));
    for kBell = 0:1:ktotal
        for kGHZ = 0:(ktotal - kBell)
            kA = kGHZ; kB = kGHZ; kC = kGHZ;
            kD = kBell; kE = kBell;
            [TotalRate, TotalRateBell, TotalRateGHZ, kswitch] = GHZRateList_Allocation(LA, LB, LC, LD, LE, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, kD, kE, v, N);
            out(idx,:) = [ktotal, kBell, kGHZ, TotalRate, TotalRateBell, TotalRateGHZ];
            idx = idx + 1;
        end
    end
end
disp("*******All loops completed.*******")

T = array2table(out, 'VariableNames', {'ktotal','kBell','kGHZ','TotalRate','TotalRateBell','TotalRateGHZ'});

writetable(T, 'Idea1.csv');

disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
