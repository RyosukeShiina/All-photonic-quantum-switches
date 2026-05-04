% Abstract:
%   This file tests the map_ghz_pauli_operator_probabilities_to_combined_pauli_operator_probabilities function.
%
% Run the test by executing:
%   results = runtests('TEST_map_pauli_operator_probs_to_combined_pauli_operator_probs.m');

tol = 1e-12;

pauliTable = ghz_source_pauli_operators();
numSourceOperators = size(pauliTable, 1);

if numSourceOperators ~= 24
    error('This test assumes that ghz_source_pauli_operators returns 24 source Pauli operators.');
end

check_output_struct = @(S) assert( ...
    isstruct(S) && ...
    isfield(S, 'PauliOperators') && ...
    isfield(S, 'Probs') && ...
    isequal(size(S.PauliOperators), [64, 1]) && ...
    isequal(size(S.Probs), [64, 1]) );

check_probability_distribution = @(P) assert( ...
    all(P >= -tol, 'all') && ...
    all(P <= 1 + tol, 'all') && ...
    all(~isnan(P), 'all') && ...
    abs(sum(P) - 1) < tol );

% Test 0: Basic sanity check with small source probabilities.
ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0.01);

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs( ...
    ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);


% Test 1: If all source probabilities are zero, the combined distribution
% should be concentrated on III.
ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxIII = find(combinedResults.PauliOperators == "III");

assert(numel(idxIII) == 1);
assert(abs(combinedResults.Probs(idxIII) - 1) < tol);


% Test 2: If exactly one source Pauli operator occurs with probability one,
% the combined distribution should be concentrated on that Pauli operator.
sourceIndex = 3;  % XII in ghz_source_pauli_operators

sourceLabel = join(pauliTable(sourceIndex, :), "");
sourceLabel = string(sourceLabel);

ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
ghzPauliOperatorResults.Probs{sourceIndex} = 1;

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxSource = find(combinedResults.PauliOperators == sourceLabel);

assert(numel(idxSource) == 1);
assert(abs(combinedResults.Probs(idxSource) - 1) < tol);


% Test 3: A single source probability p should produce a two-point
% distribution: III with probability 1-p and the source Pauli with probability p.
sourceIndex = 3;  % XII
p = 0.25;

sourceLabel = join(pauliTable(sourceIndex, :), "");
sourceLabel = string(sourceLabel);

ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
ghzPauliOperatorResults.Probs{sourceIndex} = p;

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxIII = find(combinedResults.PauliOperators == "III");
idxSource = find(combinedResults.PauliOperators == sourceLabel);

assert(numel(idxIII) == 1);
assert(numel(idxSource) == 1);

assert(abs(combinedResults.Probs(idxIII) - (1 - p)) < tol);
assert(abs(combinedResults.Probs(idxSource) - p) < tol);

nonzeroIndices = find(combinedResults.Probs > tol);
expectedNonzeroIndices = sort([idxIII; idxSource]);
assert(isequal(sort(nonzeroIndices), expectedNonzeroIndices));


% Test 4: Two identical source Pauli operators with probability one should
% cancel by XOR and return to III.
idxXII = find_source_label_indices(pauliTable, "XII");

if numel(idxXII) < 2
    error('This test assumes that the source Pauli table contains at least two XII entries.');
end

ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
ghzPauliOperatorResults.Probs{idxXII(1)} = 1;
ghzPauliOperatorResults.Probs{idxXII(2)} = 1;

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxIII = find(combinedResults.PauliOperators == "III");

assert(numel(idxIII) == 1);
assert(abs(combinedResults.Probs(idxIII) - 1) < tol);


% Test 5: X and Z on the same qubit should combine into Y.
idxXII = find_source_label_indices(pauliTable, "XII");
idxZII = find_source_label_indices(pauliTable, "ZII");

if isempty(idxXII) || isempty(idxZII)
    error('This test assumes that the source Pauli table contains XII and ZII.');
end

ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
ghzPauliOperatorResults.Probs{idxXII(1)} = 1;
ghzPauliOperatorResults.Probs{idxZII(1)} = 1;

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxYII = find(combinedResults.PauliOperators == "YII");

assert(numel(idxYII) == 1);
assert(abs(combinedResults.Probs(idxYII) - 1) < tol);


% Test 6: Independent source probabilities should combine correctly.
%
% Example:
%   XII occurs with probability p.
%   ZII occurs with probability q.
%
% Then:
%   III occurs with probability (1-p)(1-q),
%   XII occurs with probability p(1-q),
%   ZII occurs with probability (1-p)q,
%   YII occurs with probability pq.
p = 0.2;
q = 0.3;

idxXII = find_source_label_indices(pauliTable, "XII");
idxZII = find_source_label_indices(pauliTable, "ZII");

ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
ghzPauliOperatorResults.Probs{idxXII(1)} = p;
ghzPauliOperatorResults.Probs{idxZII(1)} = q;

combinedResults = map_pauli_operator_probs_to_combined_pauli_operator_probs(ghzPauliOperatorResults);

check_output_struct(combinedResults);
check_probability_distribution(combinedResults.Probs);

idxIII = find(combinedResults.PauliOperators == "III");
idxXIICombined = find(combinedResults.PauliOperators == "XII");
idxZIICombined = find(combinedResults.PauliOperators == "ZII");
idxYII = find(combinedResults.PauliOperators == "YII");

assert(abs(combinedResults.Probs(idxIII) - (1 - p) * (1 - q)) < tol);
assert(abs(combinedResults.Probs(idxXIICombined) - p * (1 - q)) < tol);
assert(abs(combinedResults.Probs(idxZIICombined) - (1 - p) * q) < tol);
assert(abs(combinedResults.Probs(idxYII) - p * q) < tol);

nonzeroIndices = find(combinedResults.Probs > tol);
expectedNonzeroIndices = sort([idxIII; idxXIICombined; idxZIICombined; idxYII]);

assert(isequal(sort(nonzeroIndices), expectedNonzeroIndices));


% Test 7: Incorrect number of source probabilities should be rejected.
badResults = struct();
badResults.Probs = cell(numSourceOperators - 1, 1);

for i = 1:(numSourceOperators - 1)
    badResults.Probs{i} = 0;
end

try
    map_pauli_operator_probs_to_combined_pauli_operator_probs(badResults);
    error('Expected the mapping function to reject an incorrect number of source probabilities.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected the mapping function to reject an incorrect number of source probabilities.'));
end


% Test 8: Source probabilities outside [0,1] should be rejected.
badResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
badResults.Probs{1} = -0.1;

try
    map_pauli_operator_probs_to_combined_pauli_operator_probs(badResults);
    error('Expected the mapping function to reject a negative source probability.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected the mapping function to reject a negative source probability.'));
end

badResults = make_test_ghz_pauli_operator_results(numSourceOperators, 0);
badResults.Probs{1} = 1.1;

try
    map_pauli_operator_probs_to_combined_pauli_operator_probs(badResults);
    error('Expected the mapping function to reject a source probability larger than one.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected the mapping function to reject a source probability larger than one.'));
end



function ghzPauliOperatorResults = make_test_ghz_pauli_operator_results(numSourceOperators, p)

% Creates a test input structure with identical scalar source probabilities.

ghzPauliOperatorResults = struct();
ghzPauliOperatorResults.Probs = cell(numSourceOperators, 1);

for i = 1:numSourceOperators
    ghzPauliOperatorResults.Probs{i} = p;
end

end


function indices = find_source_label_indices(pauliTable, targetLabel)

% Finds rows of pauliTable whose concatenated three-qubit Pauli label matches targetLabel.

numSourceOperators = size(pauliTable, 1);
labels = strings(numSourceOperators, 1);

for i = 1:numSourceOperators
    labels(i) = join(pauliTable(i, :), "");
end

indices = find(labels == string(targetLabel));

end
