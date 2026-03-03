L = 9;
sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
k = 0;
v = 0.3; 
leaves = 1;
N = 100000000;
xdata = [];
out_45km = [];
out_90km = [];
out_135km = [];
out_180km = [];
out_225km = [];
out_270km = [];
out_315km = [];
out_360km = [];
out_405km = [];
out_450km = [];
out_495km = [];
out_540km = [];
out_585km = [];
out_630km = [];
out_675km = [];
out_720km = [];
out_765km = [];
out_810km = [];
out_855km = [];
out_900km = [];
out_945km = [];
out_990km = [];
out_1035km = [];

tic;
disp("*******This simulation starts*******");
for i = 1:1:20
    disp(i);
    [ZerrUW2, XerrUW2] = UW2_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, i, v, leaves, N);
    disp("UW2_Zerr")
    disp(ZerrUW2)
    disp("UW2_Xerr")
    disp(XerrUW2)
    xdata = [xdata, i];
    out_45km = [out_45km, R_SecretKeyRate_total(9, 45, ZerrUW2, XerrUW2);];
    out_90km = [out_90km, R_SecretKeyRate_total(9, 90, ZerrUW2, XerrUW2);];
    out_135km = [out_135km, R_SecretKeyRate_total(9, 135, ZerrUW2, XerrUW2);];
    out_180km = [out_180km, R_SecretKeyRate_total(9, 180, ZerrUW2, XerrUW2);];
    out_225km = [out_225km, R_SecretKeyRate_total(9, 225, ZerrUW2, XerrUW2);];
    out_270km = [out_270km, R_SecretKeyRate_total(9, 270, ZerrUW2, XerrUW2);];
    out_315km = [out_315km, R_SecretKeyRate_total(9, 315, ZerrUW2, XerrUW2);];
    out_360km = [out_360km, R_SecretKeyRate_total(9, 360, ZerrUW2, XerrUW2);];
    out_405km = [out_405km, R_SecretKeyRate_total(9, 405, ZerrUW2, XerrUW2);];
    out_450km = [out_450km, R_SecretKeyRate_total(9, 450, ZerrUW2, XerrUW2);];
    out_495km = [out_495km, R_SecretKeyRate_total(9, 495, ZerrUW2, XerrUW2);];
    out_540km = [out_540km, R_SecretKeyRate_total(9, 540, ZerrUW2, XerrUW2);];
    out_585km = [out_585km, R_SecretKeyRate_total(9, 585, ZerrUW2, XerrUW2);];
    out_630km = [out_630km, R_SecretKeyRate_total(9, 630, ZerrUW2, XerrUW2);];
    out_675km = [out_675km, R_SecretKeyRate_total(9, 675, ZerrUW2, XerrUW2);];
    out_720km = [out_720km, R_SecretKeyRate_total(9, 720, ZerrUW2, XerrUW2);];
    out_765km = [out_765km, R_SecretKeyRate_total(9, 765, ZerrUW2, XerrUW2);];
    out_810km = [out_810km, R_SecretKeyRate_total(9, 810, ZerrUW2, XerrUW2);];
    out_855km = [out_855km, R_SecretKeyRate_total(9, 855, ZerrUW2, XerrUW2);];
    out_900km = [out_900km, R_SecretKeyRate_total(9, 900, ZerrUW2, XerrUW2);];
    out_945km = [out_945km, R_SecretKeyRate_total(9, 945, ZerrUW2, XerrUW2);];
    out_990km = [out_990km, R_SecretKeyRate_total(9, 990, ZerrUW2, XerrUW2);];
    out_1035km = [out_1035km, R_SecretKeyRate_total(9, 1035, ZerrUW2, XerrUW2);];
    disp("******This loop was finished*****")
end

writematrix(out_45km, 'Rate_vs_k_UW2_45km.csv');
writematrix(out_90km, 'Rate_vs_k_UW2_90km.csv');
writematrix(out_135km, 'Rate_vs_k_UW2_135km.csv');
writematrix(out_180km, 'Rate_vs_k_UW2_180km.csv');
writematrix(out_225km, 'Rate_vs_k_UW2_225km.csv');
writematrix(out_270km, 'Rate_vs_k_UW2_270km.csv');
writematrix(out_315km, 'Rate_vs_k_UW2_315km.csv');
writematrix(out_360km, 'Rate_vs_k_UW2_360km.csv');
writematrix(out_405km, 'Rate_vs_k_UW2_405km.csv');
writematrix(out_450km, 'Rate_vs_k_UW2_450km.csv');
writematrix(out_495km, 'Rate_vs_k_UW2_495km.csv');
writematrix(out_540km, 'Rate_vs_k_UW2_540km.csv');
writematrix(out_585km, 'Rate_vs_k_UW2_585km.csv');
writematrix(out_630km, 'Rate_vs_k_UW2_630km.csv');
writematrix(out_675km, 'Rate_vs_k_UW2_675km.csv');
writematrix(out_720km, 'Rate_vs_k_UW2_720km.csv');
writematrix(out_765km, 'Rate_vs_k_UW2_765km.csv');
writematrix(out_810km, 'Rate_vs_k_UW2_810km.csv');
writematrix(out_855km, 'Rate_vs_k_UW2_855km.csv');
writematrix(out_900km, 'Rate_vs_k_UW2_900km.csv');
writematrix(out_945km, 'Rate_vs_k_UW2_945km.csv');
writematrix(out_990km, 'Rate_vs_k_UW2_990km.csv');
writematrix(out_1035km, 'Rate_vs_k_UW2_1035km.csv');

disp("******This simulation was finished*****")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
