L = 9;
sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3; 
leaves = 1;
N = 100000000;

xdata = [];
y0 = [];
y1 = [];
y2 = [];
y3 = [];
y4 = [];
y5 = [];

tic;
disp("*******This simulation starts*******");

disp("*******UW2_8km*******");

[ZerrUW2_8, XerrUW2_8] = UW2_InnerAndOuterLeaves(8, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 8:8:3000
    outUW2_8 = R_SecretKeyRate_per(8, i, ZerrUW2_8, XerrUW2_8);
    y0 = [y0, outUW2_8];
end

writematrix(y0, 'Rate_vs_Distance_UW2_k=15_8km.csv');

disp("*******UW3_8km*******");

[ZerrUW3_8, XerrUW3_8] = UW3_InnerAndOuterLeaves(8, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 8:8:3000
    outUW3_8 = R_SecretKeyRate_per(8, i, ZerrUW3_8, XerrUW3_8);
    y1 = [y1, outUW3_8];
end

writematrix(y1, 'Rate_vs_Distance_UW3_k=15_8km.csv');

disp("*******UW2_9km*******");

[ZerrUW2_9, XerrUW2_9] = UW2_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 9:9:3006
    outUW2_9 = R_SecretKeyRate_per(9, i, ZerrUW2_9, XerrUW2_9);
    y2 = [y2, outUW2_9];
end

writematrix(y2, 'Rate_vs_Distance_UW2_k=15_9km.csv');

disp("*******UW3_9km*******");

[ZerrUW3_9, XerrUW3_9] = UW3_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 9:9:3006
    outUW3_9 = R_SecretKeyRate_per(9, i, ZerrUW3_9, XerrUW3_9);
    y3 = [y3, outUW3_9];
end

writematrix(y3, 'Rate_vs_Distance_UW3_k=15_9km.csv');


disp("*******UW2_10km*******");

[ZerrUW2_10, XerrUW2_10] = UW2_InnerAndOuterLeaves(10, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 10:10:3000
    outUW2_10 = R_SecretKeyRate_per(10, i, ZerrUW2_10, XerrUW2_10);
    y4 = [y4, outUW2_10];
end

writematrix(y4, 'Rate_vs_Distance_UW2_k=15_10km.csv');


disp("*******UW3_10km*******");

[ZerrUW3_10, XerrUW3_10] = UW3_InnerAndOuterLeaves(10, sigGKP, etas, etam, etad, etac, Lcavity, 15, v, leaves, N);

for i = 10:10:3000
    outUW3_10 = R_SecretKeyRate_per(10, i, ZerrUW3_10, XerrUW3_10);
    y5 = [y5, outUW3_10];
end

writematrix(y5, 'Rate_vs_Distance_UW3_k=15_10km.csv');

disp("******This simulation was finished*****")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
