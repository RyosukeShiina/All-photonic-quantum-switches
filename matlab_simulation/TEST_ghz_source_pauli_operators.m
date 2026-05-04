% Abstract:
%   This file tests the ghz_source_pauli_operators function.
%
% Run the test by executing:
%   results = runtests('TEST_ghz_source_pauli_operators.m');

% Test 0: Basic sanity check.
pauliTable = ghz_source_pauli_operators();

assert(isequal(size(pauliTable), [24, 3]));
assert(isstring(pauliTable));

% Test 1: All entries must be valid single-qubit Pauli labels.
validPaulis = ["I", "X", "Y", "Z"];

assert(all(ismember(pauliTable, validPaulis), 'all'));

% Test 2: The table should not contain Y source operators.
%
% The source table contains only elementary X-type and Z-type source
% operators. Y operators can appear only after combining X and Z components
% on the same qubit.
assert(~any(pauliTable == "Y", 'all'));

% Test 3: Check selected rows against the expected source Pauli operators.
assert(isequal(pauliTable(1, :),  ["I", "I", "I"]));
assert(isequal(pauliTable(2, :),  ["Z", "I", "I"]));
assert(isequal(pauliTable(3, :),  ["X", "I", "I"]));

assert(isequal(pauliTable(6, :),  ["I", "Z", "I"]));
assert(isequal(pauliTable(7, :),  ["I", "X", "I"]));

assert(isequal(pauliTable(10, :), ["I", "I", "Z"]));
assert(isequal(pauliTable(11, :), ["I", "I", "X"]));

assert(isequal(pauliTable(13, :), ["X", "I", "I"]));
assert(isequal(pauliTable(16, :), ["Z", "I", "I"]));

assert(isequal(pauliTable(17, :), ["I", "X", "I"]));
assert(isequal(pauliTable(20, :), ["I", "Z", "I"]));

assert(isequal(pauliTable(21, :), ["I", "I", "X"]));
assert(isequal(pauliTable(24, :), ["I", "I", "Z"]));

% Test 4: Count the number of each source Pauli label.
%
% The table should contain:
%   III 12 times in total,
%   each single-qubit X operator twice,
%   each single-qubit Z operator twice.
labels = strings(24, 1);

for i = 1:24
    labels(i) = join(pauliTable(i, :), "");
end

assert(sum(labels == "III") == 12);

assert(sum(labels == "XII") == 2);
assert(sum(labels == "IXI") == 2);
assert(sum(labels == "IIX") == 2);

assert(sum(labels == "ZII") == 2);
assert(sum(labels == "IZI") == 2);
assert(sum(labels == "IIZ") == 2);

% Test 5: The row ordering should match the expected table exactly.
expectedPauliTable = [
    "I" "I" "I";
    "Z" "I" "I";
    "X" "I" "I";
    "I" "I" "I";

    "I" "I" "I";
    "I" "Z" "I";
    "I" "X" "I";
    "I" "I" "I";

    "I" "I" "I";
    "I" "I" "Z";
    "I" "I" "X";
    "I" "I" "I";

    "X" "I" "I";
    "I" "I" "I";
    "I" "I" "I";
    "Z" "I" "I";

    "I" "X" "I";
    "I" "I" "I";
    "I" "I" "I";
    "I" "Z" "I";

    "I" "I" "X";
    "I" "I" "I";
    "I" "I" "I";
    "I" "I" "Z";
];

assert(isequal(pauliTable, expectedPauliTable));
