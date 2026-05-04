% Abstract:
%   This file tests the map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs function.
%
% Run the test by executing:
%   results = runtests('TEST_map_combined_pauli_probs_to_ghz_basis_lambdas_and_Qs.m');

tol = 1e-12;

% Test 0: Basic sanity check with all probability on III.
combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "III")) = 1;

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(1) = 1;  % lambda_0^+

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);
assert(abs(Qx - 0) < tol);
assert(abs(Qz - 0) < tol);
assert(abs(Qab - 0) < tol);


% Test 1: ZII maps GHZ_0^+ to GHZ_0^-.
combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "ZII")) = 1;

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(2) = 1;  % lambda_0^-

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);
assert(abs(Qx - 1) < tol);
assert(abs(Qz - 0) < tol);
assert(abs(Qab - 0) < tol);


% Test 2: XII maps to lambda_1^+.
combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "XII")) = 1;

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(3) = 1;  % lambda_1^+

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);
assert(abs(Qx - 0.5) < tol);
assert(abs(Qz - 1) < tol);
assert(abs(Qab - 1) < tol);


% Test 3: YII maps to lambda_1^-.
combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "YII")) = 1;

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(4) = 1;  % lambda_1^-

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);
assert(abs(Qx - 0.5) < tol);
assert(abs(Qz - 1) < tol);
assert(abs(Qab - 1) < tol);


% Test 4: A mixed Pauli distribution should map to the expected GHZ-basis
% weights.
combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "III")) = 0.40;  % lambda_0^+
combinedResults.Probs(find_pauli_index(combinedResults, "ZII")) = 0.10;  % lambda_0^-
combinedResults.Probs(find_pauli_index(combinedResults, "XII")) = 0.20;  % lambda_1^+
combinedResults.Probs(find_pauli_index(combinedResults, "YII")) = 0.05;  % lambda_1^-
combinedResults.Probs(find_pauli_index(combinedResults, "IXI")) = 0.15;  % lambda_2^+
combinedResults.Probs(find_pauli_index(combinedResults, "IIY")) = 0.10;  % lambda_3^-

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(1) = 0.40;
expectedLambdas(2) = 0.10;
expectedLambdas(3) = 0.20;
expectedLambdas(4) = 0.05;
expectedLambdas(5) = 0.15;
expectedLambdas(8) = 0.10;

expectedQx = 0.5 - 0.5 * (expectedLambdas(1) - expectedLambdas(2));
expectedQz = 1 - expectedLambdas(1) - expectedLambdas(2);
expectedQab = max([
    expectedLambdas(3) + expectedLambdas(4), ...
    expectedLambdas(5) + expectedLambdas(6), ...
    expectedLambdas(7) + expectedLambdas(8)]);

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);
assert(abs(Qx - expectedQx) < tol);
assert(abs(Qz - expectedQz) < tol);
assert(abs(Qab - expectedQab) < tol);


% Test 5: Complementary bit-flip patterns should map to the same GHZ index.

% XXX has bit-flip pattern 111, which belongs to GHZ index 0. Since there is
% no phase-flip component, it maps to lambda_0^+.

combinedResults = make_combined_pauli_results();

combinedResults.Probs(:) = 0;
combinedResults.Probs(find_pauli_index(combinedResults, "XXX")) = 1;

[ghz_basis_lambdas, Qx, Qz, Qab] = ...
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(combinedResults);

check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab);

expectedLambdas = zeros(8, 1);
expectedLambdas(1) = 1;  % lambda_0^+

assert(norm(ghz_basis_lambdas - expectedLambdas, 1) < tol);


% Test 6: Invalid probability-vector length should be rejected.
badResults = make_combined_pauli_results();
badResults.Probs = badResults.Probs(1:63);

try
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(badResults);
    error('Expected the mapping function to reject a probability vector with incorrect length.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected the mapping function to reject a probability vector with incorrect length.'));
end


% Test 7: Negative probabilities should be rejected.

badResults = make_combined_pauli_results();
badResults.Probs(:) = 0;
badResults.Probs(find_pauli_index(badResults, "III")) = 1.1;
badResults.Probs(find_pauli_index(badResults, "XII")) = -0.1;

try
    map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs(badResults);
    error('Expected the mapping function to reject negative probabilities.');
catch ME
    assert(~strcmp(ME.message, ...
        'Expected the mapping function to reject negative probabilities.'));
end



function combinedResults = make_combined_pauli_results()

% Creates a 64-component three-qubit Pauli-operator probability structure
% with all probability initially set to zero.

pauliLabels = strings(64, 1);

for operatorIndex = 0:63
    label = "";

    for qubitIndex = 1:3
        hasX = bitget(operatorIndex, qubitIndex);
        hasZ = bitget(operatorIndex, qubitIndex + 3);

        if hasX == 0 && hasZ == 0
            pauliChar = "I";
        elseif hasX == 1 && hasZ == 0
            pauliChar = "X";
        elseif hasX == 0 && hasZ == 1
            pauliChar = "Z";
        else
            pauliChar = "Y";
        end

        label = label + pauliChar;
    end

    pauliLabels(operatorIndex + 1) = label;
end

combinedResults = struct();
combinedResults.PauliOperators = pauliLabels;
combinedResults.Probs = zeros(64, 1);

end


function idx = find_pauli_index(combinedResults, pauliLabel)

% Finds the unique index of a Pauli label in combinedResults.PauliOperators.
idx = find(combinedResults.PauliOperators == string(pauliLabel));
assert(numel(idx) == 1);

end


function check_ghz_outputs(ghz_basis_lambdas, Qx, Qz, Qab)

% Checks the basic shape and range of the GHZ-basis lambdas and Q values.

tol = 1e-12;

assert(isequal(size(ghz_basis_lambdas), [8, 1]));
assert(all(ghz_basis_lambdas >= -tol, 'all'));
assert(all(ghz_basis_lambdas <= 1 + tol, 'all'));
assert(abs(sum(ghz_basis_lambdas) - 1) < tol);

assert(isscalar(Qx));
assert(isscalar(Qz));
assert(isscalar(Qab));

assert(Qx >= -tol && Qx <= 1 + tol);
assert(Qz >= -tol && Qz <= 1 + tol);
assert(Qab >= -tol && Qab <= 1 + tol);

end
