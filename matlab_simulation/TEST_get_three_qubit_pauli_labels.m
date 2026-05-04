% Abstract:
%   This file tests the get_three_qubit_pauli_labels function.
%
% Run the test by executing:
%   results = runtests('TEST_get_three_qubit_pauli_labels.m');

% Test 0: Extract labels from a 64-by-3 string array.

patternLabels = repmat(["I", "I", "I"], 64, 1);
patternLabels(10, :) = ["X", "Y", "Z"];

[pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, 10);

assert(pauli1 == "X");
assert(pauli2 == "Y");
assert(pauli3 == "Z");


% Test 1: Extract labels from a 64-by-1 concatenated string array.
patternLabels = strings(64, 1);
patternLabels(:) = "III";
patternLabels(20) = "XYZ";

[pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, 20);

assert(pauli1 == "X");
assert(pauli2 == "Y");
assert(pauli3 == "Z");

% Test 2: Another valid concatenated Pauli label.
patternLabels = strings(64, 1);
patternLabels(:) = "III";
patternLabels(30) = "YZI";

[pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, 30);

assert(pauli1 == "Y");
assert(pauli2 == "Z");
assert(pauli3 == "I");


% Test 3: A concatenated label with incorrect length should be rejected.
patternLabels = strings(64, 1);
patternLabels(:) = "III";
patternLabels(5) = "XI";

try
    get_three_qubit_pauli_labels(patternLabels, 5);
    error('Expected get_three_qubit_pauli_labels to reject a label with incorrect length.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected get_three_qubit_pauli_labels to reject a label with incorrect length.'));
end


% Test 4: An invalid Pauli label in concatenated format should be rejected.
patternLabels = strings(64, 1);
patternLabels(:) = "III";
patternLabels(5) = "XAI";

try
    get_three_qubit_pauli_labels(patternLabels, 5);
    error('Expected get_three_qubit_pauli_labels to reject an invalid Pauli label.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected get_three_qubit_pauli_labels to reject an invalid Pauli label.'));
end


% Test 5: An invalid Pauli label in 64-by-3 format should be rejected.
patternLabels = repmat(["I", "I", "I"], 64, 1);
patternLabels(5, :) = ["X", "A", "I"];

try
    get_three_qubit_pauli_labels(patternLabels, 5);
    error('Expected get_three_qubit_pauli_labels to reject an invalid Pauli label in 64-by-3 format.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected get_three_qubit_pauli_labels to reject an invalid Pauli label in 64-by-3 format.'));
end


% Test 6: All four Pauli labels should be accepted.
patternLabels = strings(64, 1);
patternLabels(:) = "III";

testLabels = ["III", "XII", "YII", "ZII"];

for i = 1:numel(testLabels)
    patternLabels(i) = testLabels(i);

    [pauli1, pauli2, pauli3] = get_three_qubit_pauli_labels(patternLabels, i);

    label = pauli1 + pauli2 + pauli3;
    assert(label == testLabels(i));
end
