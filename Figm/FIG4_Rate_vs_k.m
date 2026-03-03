

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

k = 0;
N = 10000;

tic;
disp("*******The simulation has started.*******");


disp("*******[3, 4, 5]*******");
xdata = [];
out = [];
LA = 3;
LB = 4;
LC = 5;
for i = 1:1:20
    disp("Starting loop k=" + string(i))
    RateList = GHZRateList_Distance(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, i, v, N);
    xdata = [xdata, i];
    out = [out, RateList(1)];
    disp("*******The loop has completed.*******")
end

writematrix(out, 'FIG4_Rate_vs_k_7p4p5.csv');


disp("*******[7, 9, 11]*******");
xdata = [];
out = [];
LA = 7;
LB = 9;
LC = 11;
for i = 1:1:20
    disp("Starting loop k=" + string(i))
    RateList = GHZRateList_Distance(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, i, v, N);
    xdata = [xdata, i];
    out = [out, RateList(1)];
    disp("*******The loop has completed.*******")
end

writematrix(out, 'FIG4_Rate_vs_k_7p9p11.csv');

disp("*******[6, 8, 12]*******");
xdata = [];
out = [];
LA = 6;
LB = 8;
LC = 12;
for i = 1:1:20
    disp("Starting loop k=" + string(i))
    RateList = GHZRateList_Distance(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, i, v, N);
    xdata = [xdata, i];
    out = [out, RateList(1)];
    disp("*******The loop has completed.*******")
end

writematrix(out, 'FIG4_Rate_vs_k_6p8p12.csv');



disp("*******The simulation has finished.*******")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
