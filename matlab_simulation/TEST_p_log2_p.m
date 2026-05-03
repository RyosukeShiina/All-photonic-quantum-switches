% Abstract:
%   This file tests the p_log2_p function.
%
% Run the test by executing:
%   results = runtests('TEST_p_log2_p.m');

tol = 1e-12;

% Test 0: The convention 0*log2(0) = 0 should be used.
value0 = p_log2_p(0);
assert(abs(value0 - 0) < tol);

% Test 1: Basic known values.
value1 = p_log2_p(1);
assert(abs(value1 - 0) < tol);

valueHalf = p_log2_p(0.5);
assert(abs(valueHalf - (-0.5)) < tol);

valueQuarter = p_log2_p(0.25);
assert(abs(valueQuarter - (-0.5)) < tol);

% Test 2: For probabilities in (0,1), p*log2(p) should be negative.
pVec = [0.1, 0.2, 0.5, 0.8, 0.9];

for i = 1:numel(pVec)
    value = p_log2_p(pVec(i));
    assert(value < 0);
end

% Test 3: For p > 1, p*log2(p) should be positive.
pVec = [2, 4, 10];

for i = 1:numel(pVec)
    value = p_log2_p(pVec(i));
    assert(value > 0);
end

% Test 4: Compare against direct MATLAB evaluation for positive inputs.
pVec = [0.01, 0.1, 0.3, 0.7, 1, 2, 5];

for i = 1:numel(pVec)
    p = pVec(i);
    expectedValue = p * log2(p);
    actualValue = p_log2_p(p);

    assert(abs(actualValue - expectedValue) < tol);
end
