LA = 0;
LB = 9;
LC = 0;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

k = 10;
N = 10000;

xdata = [];
out = zeros(15*15, 3);
idx = 1;

tic;
disp("*******The simulation has started.*******");
for i = 1:1:15
    disp("Starting loop i=" + string(i))
    for j = 1:1:15
        RateList = GHZRateList_Distance(i, LB, j, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);
        out(idx,:) = [i, j, RateList(1)];
        idx = idx + 1;
    end
    disp("*******The loop has completed.*******")
end

T = array2table(out, 'VariableNames', {'LA','LC','Rate'});
writetable(T, 'Rate_map.csv');

disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
