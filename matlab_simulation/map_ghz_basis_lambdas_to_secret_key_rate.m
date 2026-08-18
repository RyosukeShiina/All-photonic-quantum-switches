function secretKeyRate = map_ghz_basis_lambdas_to_secret_key_rate(ghz_basis_lambdas, Qab)

% Computes the secret key rate directly from the GHZ-basis weights
% without imposing the extended-depolarization condition
% lambda_j^+ = lambda_j^- for j > 0.
%
% Input:
%   ghz_basis_lambdas
%       An 8-by-1 vector of GHZ-basis weights:
%           ghz_basis_lambdas(1) = lambda_0^+
%           ghz_basis_lambdas(2) = lambda_0^-
%           ghz_basis_lambdas(3) = lambda_1^+
%           ghz_basis_lambdas(4) = lambda_1^-
%           ghz_basis_lambdas(5) = lambda_2^+
%           ghz_basis_lambdas(6) = lambda_2^-
%           ghz_basis_lambdas(7) = lambda_3^+
%           ghz_basis_lambdas(8) = lambda_3^-
%
%   Qab
%       Worst pairwise Z-basis error rate between Alice and the other
%       parties.
%
% Output:
%   secretKeyRate
%       Secret key rate. The returned value is lower-bounded by zero.
%
% Formula:
%   p_j = lambda_j^+ + lambda_j^-
%
%   S(E|K) = -sum_j p_j log2(p_j)
%
%   S(E) = -sum_{j,sigma} lambda_j^sigma log2(lambda_j^sigma)
%
%   secretKeyRate = max(0, 1 + S(E|K) - S(E) - h2(Qab))
%
% Note:
%   The convention 0*log2(0) = 0 is used.

validateattributes(ghz_basis_lambdas, {'numeric'}, ...
    {'real', 'vector', 'numel', 8, 'finite'});

validateattributes(Qab, {'numeric'}, ...
    {'real', 'scalar', 'finite'});

ghz_basis_lambdas = ghz_basis_lambdas(:);

tolerance = 1e-14;

if any(ghz_basis_lambdas < -tolerance) || ...
        any(ghz_basis_lambdas > 1 + tolerance)
    error('All GHZ-basis weights must be in the interval [0, 1].');
end

if Qab < 0 || Qab > 1
    error('Qab must be in the interval [0, 1].');
end

% Treat tiny values outside [0,1] as numerical roundoff.
ghz_basis_lambdas = max(ghz_basis_lambdas, 0);
ghz_basis_lambdas = min(ghz_basis_lambdas, 1);

probabilitySum = sum(ghz_basis_lambdas);

if abs(probabilitySum - 1) > 1e-10
    error('GHZ-basis weights must sum to 1. Sum = %.16g', probabilitySum);
end

% p_j = lambda_j^+ + lambda_j^-
p = zeros(4, 1);

p(1) = ghz_basis_lambdas(1) + ghz_basis_lambdas(2);
p(2) = ghz_basis_lambdas(3) + ghz_basis_lambdas(4);
p(3) = ghz_basis_lambdas(5) + ghz_basis_lambdas(6);
p(4) = ghz_basis_lambdas(7) + ghz_basis_lambdas(8);

% S(E|K) = -sum_j p_j log2(p_j)
SEgivenK = 0;

for j = 1:4
    SEgivenK = SEgivenK - p_log2_p(p(j));
end

% S(E) = -sum_{j,sigma} lambda_j^sigma log2(lambda_j^sigma)
SE = 0;

for index = 1:8
    SE = SE - p_log2_p(ghz_basis_lambdas(index));
end

secretKeyRate = max(0, ...
    1 + SEgivenK - SE - binary_entropy(Qab));

end
