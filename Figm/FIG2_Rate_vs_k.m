LA = 9;
rB = 1;
rC = 1;

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

k = 0;
N = 10000;

xdata = [];
out = [];

tic;
disp("*******The simulation has started.*******");
for i = 1:1:20
    disp("Starting loop k=" + string(i))
    RateList = GHZRateList(LA, rB, rC, sigGKP, etas, etam, etad, etac, Lcavity, i, v, N)
    xdata = [xdata, i];
    out = [out, RateList(1)];
    disp("*******The loop has completed.*******")
end

writematrix(out, 'FIG2_Rate_vs_k.csv');

disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
