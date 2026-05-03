% Abstract:
%   This file tests the binary_entropy function.
%
% Run the test by executing:
%   results = runtests('TEST_binary_entropy.m');

tol = 1e-12;

% Test 0: Endpoint values should be zero.
h0 = binary_entropy(0);
assert(abs(h0 - 0) < tol);

h1 = binary_entropy(1);
assert(abs(h1 - 0) < tol);

% Test 1: Basic known values.
hHalf = binary_entropy(0.5);
assert(abs(hHalf - 1) < tol);

hQuarter = binary_entropy(0.25);
expectedQuarter = -0.25 * log2(0.25) - 0.75 * log2(0.75);
assert(abs(hQuarter - expectedQuarter) < tol);

% Test 2: Symmetry h2(p) = h2(1-p).
pVec = [0.01, 0.1, 0.25, 0.3, 0.7, 0.9, 0.99];

for i = 1:numel(pVec)
    p = pVec(i);

    hLeft = binary_entropy(p);
    hRight = binary_entropy(1 - p);

    assert(abs(hLeft - hRight) < tol);
end

% Test 3: Binary entropy should be in [0,1] for p in [0,1].
pVec = linspace(0, 1, 101);

for i = 1:numel(pVec)
    h = binary_entropy(pVec(i));

    assert(h >= -tol);
    assert(h <= 1 + tol);
end

% Test 4: The maximum should occur at p = 1/2.
pVec = [0.01, 0.1, 0.25, 0.4, 0.6, 0.75, 0.9, 0.99];

hMax = binary_entropy(0.5);

for i = 1:numel(pVec)
    h = binary_entropy(pVec(i));

    assert(h <= hMax + tol);
end

% Test 5: Compare against direct MATLAB evaluation away from endpoints.
pVec = [0.01, 0.1, 0.3, 0.7, 0.9, 0.99];

for i = 1:numel(pVec)
    p = pVec(i);

    expectedValue = -p * log2(p) - (1 - p) * log2(1 - p);
    actualValue = binary_entropy(p);

    assert(abs(actualValue - expectedValue) < tol);
end

% Test 6: Inputs outside [0,1] should be rejected.
try
    binary_entropy(-0.1);
    error('Expected binary_entropy to reject negative input.');
catch ME
    assert(~strcmp(ME.message, 'Expected binary_entropy to reject negative input.'));
end

try
    binary_entropy(1.1);
    error('Expected binary_entropy to reject input larger than 1.');
catch ME
    assert(~strcmp(ME.message, 'Expected binary_entropy to reject input larger than 1.'));
end
