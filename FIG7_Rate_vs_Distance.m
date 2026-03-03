sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

kA = 15;
kB = 15;
kC = 15;
N = 100000;

L = 7;

xdata = [];
out = [];

tic;
disp("*******The simulation has started.*******");
for i = 7:70:1001
    disp("Starting loop Ltotal=" + string(i))
    RateList = GHZRateList_Distance_k_Long(i, L, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)
    xdata = [xdata, i];
    out = [out, RateList(1)];
    disp("*******The loop has completed.*******")
end

writematrix(out, 'FIG7_Rate_vs_Distance.csv');

disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
