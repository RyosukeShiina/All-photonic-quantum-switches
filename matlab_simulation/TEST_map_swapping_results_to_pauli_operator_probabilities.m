% Abstract:
%   This file tests the map_swapping_results_to_ghz_pauli_operator_probabilities function.
%
% Run the test by executing:
%   results = runtests('TEST_map_swapping_results_to_pauli_operator_probabilities.m');

sigGKP = 0.12;
etas = 0.995;
etam = 0.999995;
etad = 0.9975;
etac = 0.99;
Lcavity = 2;
v = 0.3;

% Use moderate values to reduce Monte Carlo fluctuations while keeping the test reasonably fast.
N = 1000;
kA = 8;
kB = 10;
kC = 12;

check_probability_vector = @(A, k) assert( ...
    isequal(size(A), [k, 1]) && ...
    all(A >= 0, 'all') && ...
    all(A <= 1, 'all') && ...
    all(~isnan(A), 'all') );

check_output_struct = @(S, numkGHZ) assert( ...
    isstruct(S) && ...
    isfield(S, 'PauliOperators') && ...
    isfield(S, 'Probs') && ...
    isfield(S, 'numkGHZ') && ...
    S.numkGHZ == numkGHZ && ...
    size(S.PauliOperators, 1) == 24 && ...
    isequal(size(S.Probs), [24, 1]) );

% Test 0: Basic sanity check.
LA = 9;
LB = 9;
LC = 9;

rng(1);
results0 = map_swapping_results_to_pauli_operator_probabilities( ...
    LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

numkGHZ = min([kA, kB, kC]);

check_output_struct(results0, numkGHZ);

for i = 1:numel(results0.Probs)
    check_probability_vector(results0.Probs{i}, numkGHZ);
end

% Test 1: numkGHZ should be the minimum of kA, kB, and kC.
kA1 = 6;
kB1 = 9;
kC1 = 12;

rng(2);
resultsK = map_swapping_results_to_pauli_operator_probabilities( ...
    LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA1, kB1, kC1, v, N);

expectedNumkGHZ = min([kA1, kB1, kC1]);

assert(resultsK.numkGHZ == expectedNumkGHZ);
check_output_struct(resultsK, expectedNumkGHZ);

for i = 1:numel(resultsK.Probs)
    check_probability_vector(resultsK.Probs{i}, expectedNumkGHZ);
end

% Test 2: Larger distances should give larger average Pauli-operator error probabilities.
LA1 = 9;
LB1 = 9;
LC1 = 9;

LA2 = 30;
LB2 = 30;
LC2 = 30;

rng(3);
resultsL1 = map_swapping_results_to_pauli_operator_probabilities( ...
    LA1, LB1, LC1, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

rng(4);
resultsL2 = map_swapping_results_to_pauli_operator_probabilities( ...
    LA2, LB2, LC2, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

check_output_struct(resultsL1, numkGHZ);
check_output_struct(resultsL2, numkGHZ);

meanProbL1 = mean_cell_probabilities(resultsL1.Probs);
meanProbL2 = mean_cell_probabilities(resultsL2.Probs);

assert(meanProbL2 > meanProbL1);

% Test 3: Larger GKP noise should give larger average Pauli-operator error
% probabilities.
sig1 = 0.12;
sig2 = 0.20;

rng(5);
resultsSig1 = map_swapping_results_to_pauli_operator_probabilities( ...
    LA, LB, LC, sig1, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

rng(6);
resultsSig2 = map_swapping_results_to_pauli_operator_probabilities( ...
    LA, LB, LC, sig2, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N);

check_output_struct(resultsSig1, numkGHZ);
check_output_struct(resultsSig2, numkGHZ);

meanProbSig1 = mean_cell_probabilities(resultsSig1.Probs);
meanProbSig2 = mean_cell_probabilities(resultsSig2.Probs);

assert(meanProbSig2 > meanProbSig1);

% Test 4: Heterogeneous distances and multiplexing levels should still
% produce valid probability vectors of length min(kA, kB, kC).
LAhet = 9;
LBhet = 15;
LChet = 30;

kAhet = 5;
kBhet = 7;
kChet = 9;

rng(7);
resultsHet = map_swapping_results_to_pauli_operator_probabilities( ...
    LAhet, LBhet, LChet, sigGKP, etas, etam, etad, etac, Lcavity, ...
    kAhet, kBhet, kChet, v, N);

numkGHZhet = min([kAhet, kBhet, kChet]);

check_output_struct(resultsHet, numkGHZhet);

for i = 1:numel(resultsHet.Probs)
    check_probability_vector(resultsHet.Probs{i}, numkGHZhet);
end


function meanProb = mean_cell_probabilities(probs)
% Computes the mean value over all probability vectors stored in a cell array.

total = 0;
count = 0;

for i = 1:numel(probs)
    total = total + sum(probs{i}, 'all');
    count = count + numel(probs{i});
end

meanProb = total / count;

end
