% Abstract:
%   This file tests the outer_leaves_swapping_and_construction function.
%
% Run the test by executing:
%   results = runtests('TEST_outer_leaves_swapping_and_construction.m');

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

k = 100;
N = 100;

check_probability_vector = @(A, k) assert( ...
    isequal(size(A), [k, 1]) && ...
    all(A >= 0, 'all') && ...
    all(A <= 1, 'all') && ...
    all(~isnan(A), 'all') );

% Test 0: Basic sanity check.
rng(1);
[Xerr0, Zerr0] = outer_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(Xerr0, k);
check_probability_vector(Zerr0, k);

% Test 1: Larger distance should give a larger average error probability.
L1 = 9;
L2 = 30;

rng(3);
[XerrL1, ZerrL1] = outer_leaves_swapping_and_construction( ...
    L1, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

rng(4);
[XerrL2, ZerrL2] = outer_leaves_swapping_and_construction( ...
    L2, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(XerrL1, k);
check_probability_vector(ZerrL1, k);
check_probability_vector(XerrL2, k);
check_probability_vector(ZerrL2, k);

meanErrL1 = mean([XerrL1; ZerrL1]);
meanErrL2 = mean([XerrL2; ZerrL2]);

assert(meanErrL2 > meanErrL1);

% Test 2: Larger GKP noise should give a larger average error probability.
sig1 = 0.12;
sig2 = 0.20;

rng(5);
[XerrSig1, ZerrSig1] = outer_leaves_swapping_and_construction( ...
    9, sig1, etas, etam, etad, etac, Lcavity, k, v, N);

rng(6);
[XerrSig2, ZerrSig2] = outer_leaves_swapping_and_construction( ...
    9, sig2, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(XerrSig1, k);
check_probability_vector(ZerrSig1, k);
check_probability_vector(XerrSig2, k);
check_probability_vector(ZerrSig2, k);

meanErrSig1 = mean([XerrSig1; ZerrSig1]);
meanErrSig2 = mean([XerrSig2; ZerrSig2]);

assert(meanErrSig2 > meanErrSig1);

% Test 3: Worse chip-fiber connector efficiency should increase the average
% error probability.
etac1 = 0.99;
etac2 = 0.90;

rng(7);
[XerrEtac1, ZerrEtac1] = outer_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac1, Lcavity, k, v, N);

rng(8);
[XerrEtac2, ZerrEtac2] = outer_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac2, Lcavity, k, v, N);

check_probability_vector(XerrEtac1, k);
check_probability_vector(ZerrEtac1, k);
check_probability_vector(XerrEtac2, k);
check_probability_vector(ZerrEtac2, k);

meanErrEtac1 = mean([XerrEtac1; ZerrEtac1]);
meanErrEtac2 = mean([XerrEtac2; ZerrEtac2]);

assert(meanErrEtac2 > meanErrEtac1);
