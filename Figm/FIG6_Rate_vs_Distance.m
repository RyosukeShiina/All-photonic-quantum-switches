LA = 9;
LB = 9;
LC = 9;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

N = 10000;

xdata = [];
out = zeros(9*9, 3);
idx = 1;

tic;

kA = 8;
kB = 10;
kC = 12;
disp("*******The simulation has started.*******");
for i = 1:1:9
    disp("Starting loop i=" + string(i))
    for j = 9:1:17
        RateList = GHZRateList_Distance_k(i, LB, j, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);
        out(idx,:) = [i, j, RateList(1)];
        idx = idx + 1;
    end
    disp("*******The loop has completed.*******")
end

T = array2table(out, 'VariableNames', {'LA','LC','Rate'});
writetable(T, 'FIG6_Rate_map_8p10p12.csv');


kA = 7;
kB = 10;
kC = 13;
disp("*******The simulation has started.*******");
for i = 1:1:9
    disp("Starting loop i=" + string(i))
    for j = 9:1:17
        RateList = GHZRateList_Distance_k(i, LB, j, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);
        out(idx,:) = [i, j, RateList(1)];
        idx = idx + 1;
    end
    disp("*******The loop has completed.*******")
end

T = array2table(out, 'VariableNames', {'LA','LC','Rate'});
writetable(T, 'FIG6_Rate_map_7p10p13.csv');






disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
