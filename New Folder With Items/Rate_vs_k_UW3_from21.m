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
for i = 21:1:28
    disp(i);
    [ZerrUW3, XerrUW3] = UW3_InnerAndOuterLeaves(9, sigGKP, etas, etam, etad, etac, Lcavity, i, v, leaves, N);
    disp("UW3_Zerr")
    disp(ZerrUW3)
    disp("UW3_Xerr")
    disp(XerrUW3)
    xdata = [xdata, i];
    out_45km = [out_45km, R_SecretKeyRate_total(9, 45, ZerrUW3, XerrUW3);];
    out_90km = [out_90km, R_SecretKeyRate_total(9, 90, ZerrUW3, XerrUW3);];
    out_135km = [out_135km, R_SecretKeyRate_total(9, 135, ZerrUW3, XerrUW3);];
    out_180km = [out_180km, R_SecretKeyRate_total(9, 180, ZerrUW3, XerrUW3);];
    out_225km = [out_225km, R_SecretKeyRate_total(9, 225, ZerrUW3, XerrUW3);];
    out_270km = [out_270km, R_SecretKeyRate_total(9, 270, ZerrUW3, XerrUW3);];
    out_315km = [out_315km, R_SecretKeyRate_total(9, 315, ZerrUW3, XerrUW3);];
    out_360km = [out_360km, R_SecretKeyRate_total(9, 360, ZerrUW3, XerrUW3);];
    out_405km = [out_405km, R_SecretKeyRate_total(9, 405, ZerrUW3, XerrUW3);];
    out_450km = [out_450km, R_SecretKeyRate_total(9, 450, ZerrUW3, XerrUW3);];
    out_495km = [out_495km, R_SecretKeyRate_total(9, 495, ZerrUW3, XerrUW3);];
    out_540km = [out_540km, R_SecretKeyRate_total(9, 540, ZerrUW3, XerrUW3);];
    out_585km = [out_585km, R_SecretKeyRate_total(9, 585, ZerrUW3, XerrUW3);];
    out_630km = [out_630km, R_SecretKeyRate_total(9, 630, ZerrUW3, XerrUW3);];
    out_675km = [out_675km, R_SecretKeyRate_total(9, 675, ZerrUW3, XerrUW3);];
    out_720km = [out_720km, R_SecretKeyRate_total(9, 720, ZerrUW3, XerrUW3);];
    out_765km = [out_765km, R_SecretKeyRate_total(9, 765, ZerrUW3, XerrUW3);];
    out_810km = [out_810km, R_SecretKeyRate_total(9, 810, ZerrUW3, XerrUW3);];
    out_855km = [out_855km, R_SecretKeyRate_total(9, 855, ZerrUW3, XerrUW3);];
    out_900km = [out_900km, R_SecretKeyRate_total(9, 900, ZerrUW3, XerrUW3);];
    out_945km = [out_945km, R_SecretKeyRate_total(9, 945, ZerrUW3, XerrUW3);];
    out_990km = [out_990km, R_SecretKeyRate_total(9, 990, ZerrUW3, XerrUW3);];
    out_1035km = [out_1035km, R_SecretKeyRate_total(9, 1035, ZerrUW3, XerrUW3);];
    disp("******This loop was finished*****")
end

writematrix(out_45km, 'Rate_vs_k_UW3_45km_from21.csv');
writematrix(out_90km, 'Rate_vs_k_UW3_90km_from21.csv');
writematrix(out_135km, 'Rate_vs_k_UW3_135km_from21.csv');
writematrix(out_180km, 'Rate_vs_k_UW3_180km_from21.csv');
writematrix(out_225km, 'Rate_vs_k_UW3_225km_from21.csv');
writematrix(out_270km, 'Rate_vs_k_UW3_270km_from21.csv');
writematrix(out_315km, 'Rate_vs_k_UW3_315km_from21.csv');
writematrix(out_360km, 'Rate_vs_k_UW3_360km_from21.csv');
writematrix(out_405km, 'Rate_vs_k_UW3_405km_from21.csv');
writematrix(out_450km, 'Rate_vs_k_UW3_450km_from21.csv');
writematrix(out_495km, 'Rate_vs_k_UW3_495km_from21.csv');
writematrix(out_540km, 'Rate_vs_k_UW3_540km_from21.csv');
writematrix(out_585km, 'Rate_vs_k_UW3_585km_from21.csv');
writematrix(out_630km, 'Rate_vs_k_UW3_630km_from21.csv');
writematrix(out_675km, 'Rate_vs_k_UW3_675km_from21.csv');
writematrix(out_720km, 'Rate_vs_k_UW3_720km_from21.csv');
writematrix(out_765km, 'Rate_vs_k_UW3_765km_from21.csv');
writematrix(out_810km, 'Rate_vs_k_UW3_810km_from21.csv');
writematrix(out_855km, 'Rate_vs_k_UW3_855km_from21.csv');
writematrix(out_900km, 'Rate_vs_k_UW3_900km_from21.csv');
writematrix(out_945km, 'Rate_vs_k_UW3_945km_from21.csv');
writematrix(out_990km, 'Rate_vs_k_UW3_990km_from21.csv');
writematrix(out_1035km, 'Rate_vs_k_UW3_1035km_from21.csv');

disp("******This simulation was finished*****")
elapsedTime = toc;
fprintf('Simulation duration: %.3f seconds\n', elapsedTime);
