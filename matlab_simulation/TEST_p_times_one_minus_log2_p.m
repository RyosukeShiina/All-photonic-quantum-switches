% Abstract:
%   This file tests the p_times_one_minus_log2_p function.
%
% Run the test by executing:
%   results = runtests('TEST_p_times_one_minus_log2_p.m');

tol = 1e-12;

% Test 0: The limiting value at p = 0 should be used.
value0 = p_times_one_minus_log2_p(0);
assert(abs(value0 - 0) < tol);

% Test 1: Basic known values.
value1 = p_times_one_minus_log2_p(1);
assert(abs(value1 - 1) < tol);

valueHalf = p_times_one_minus_log2_p(0.5);
assert(abs(valueHalf - 1.0) < tol);

valueQuarter = p_times_one_minus_log2_p(0.25);
assert(abs(valueQuarter - 0.75) < tol);

% Test 2: For probabilities in (0,1], p*(1 - log2(p)) should be positive.
pVec = [0.1, 0.2, 0.5, 0.8, 1.0];

for i = 1:numel(pVec)
    value = p_times_one_minus_log2_p(pVec(i));
    assert(value > 0);
end

% Test 3: Compare against direct MATLAB evaluation for positive inputs.
pVec = [0.01, 0.1, 0.3, 0.7, 1, 2, 5];

for i = 1:numel(pVec)
    p = pVec(i);
    expectedValue = p * (1 - log2(p));
    actualValue = p_times_one_minus_log2_p(p);

    assert(abs(actualValue - expectedValue) < tol);
end

% Test 4: Values larger than 2 can become negative.
value4 = p_times_one_minus_log2_p(4);
assert(abs(value4 - (-4)) < tol);
