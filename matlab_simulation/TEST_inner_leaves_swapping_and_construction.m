% Abstract:
%   This file tests the inner_leaves_swapping_and_construction function.
%
% Run the test by executing:
%   results = runtests('TEST_inner_leaves_swapping_and_construction.m');

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

check_identical_entries = @(A) assert(all(A == A(1), 'all'));

% Test 0: Basic sanity check.
rng(1);
[Xerr0, Zerr0] = inner_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(Xerr0, k);
check_probability_vector(Zerr0, k);

% Since all inner leaves are assumed to be identical, the returned vectors
% should have identical entries.
check_identical_entries(Xerr0);
check_identical_entries(Zerr0);

% Test 1: Larger distance should give a larger average error probability.
L1 = 9;
L2 = 30;

rng(3);
[XerrL1, ZerrL1] = inner_leaves_swapping_and_construction( ...
    L1, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

rng(4);
[XerrL2, ZerrL2] = inner_leaves_swapping_and_construction( ...
    L2, sigGKP, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(XerrL1, k);
check_probability_vector(ZerrL1, k);
check_probability_vector(XerrL2, k);
check_probability_vector(ZerrL2, k);

check_identical_entries(XerrL1);
check_identical_entries(ZerrL1);
check_identical_entries(XerrL2);
check_identical_entries(ZerrL2);

meanErrL1 = mean([XerrL1; ZerrL1]);
meanErrL2 = mean([XerrL2; ZerrL2]);

assert(meanErrL2 > meanErrL1);

% Test 2: Larger GKP noise should give a larger average error probability.
sig1 = 0.12;
sig2 = 0.20;

rng(5);
[XerrSig1, ZerrSig1] = inner_leaves_swapping_and_construction( ...
    9, sig1, etas, etam, etad, etac, Lcavity, k, v, N);

rng(6);
[XerrSig2, ZerrSig2] = inner_leaves_swapping_and_construction( ...
    9, sig2, etas, etam, etad, etac, Lcavity, k, v, N);

check_probability_vector(XerrSig1, k);
check_probability_vector(ZerrSig1, k);
check_probability_vector(XerrSig2, k);
check_probability_vector(ZerrSig2, k);

check_identical_entries(XerrSig1);
check_identical_entries(ZerrSig1);
check_identical_entries(XerrSig2);
check_identical_entries(ZerrSig2);

meanErrSig1 = mean([XerrSig1; ZerrSig1]);
meanErrSig2 = mean([XerrSig2; ZerrSig2]);

assert(meanErrSig2 > meanErrSig1);

% Test 3: Worse mirror-reflection efficiency should increase the average
% error probability.
etam1 = 0.999995;
etam2 = 0.999990;

rng(7);
[XerrEtam1, ZerrEtam1] = inner_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam1, etad, etac, Lcavity, k, v, N);

rng(8);
[XerrEtam2, ZerrEtam2] = inner_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam2, etad, etac, Lcavity, k, v, N);

check_probability_vector(XerrEtam1, k);
check_probability_vector(ZerrEtam1, k);
check_probability_vector(XerrEtam2, k);
check_probability_vector(ZerrEtam2, k);

check_identical_entries(XerrEtam1);
check_identical_entries(ZerrEtam1);
check_identical_entries(XerrEtam2);
check_identical_entries(ZerrEtam2);

meanErrEtam1 = mean([XerrEtam1; ZerrEtam1]);
meanErrEtam2 = mean([XerrEtam2; ZerrEtam2]);

assert(meanErrEtam2 > meanErrEtam1);

% Test 4: Larger cavity length should decrease the average error probability.
Lcavity1 = 2;
Lcavity2 = 200;
etam = 0.99;

rng(9);
[XerrLcavity1, ZerrLcavity1] = inner_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac, Lcavity1, k, v, N);

rng(10);
[XerrLcavity2, ZerrLcavity2] = inner_leaves_swapping_and_construction( ...
    9, sigGKP, etas, etam, etad, etac, Lcavity2, k, v, N);

check_probability_vector(XerrLcavity1, k);
check_probability_vector(ZerrLcavity1, k);
check_probability_vector(XerrLcavity2, k);
check_probability_vector(ZerrLcavity2, k);

check_identical_entries(XerrLcavity1);
check_identical_entries(ZerrLcavity1);
check_identical_entries(XerrLcavity2);
check_identical_entries(ZerrLcavity2);

meanErrLcavity1 = mean([XerrLcavity1; ZerrLcavity1]);
meanErrLcavity2 = mean([XerrLcavity2; ZerrLcavity2]);

assert(meanErrLcavity2 < meanErrLcavity1);
