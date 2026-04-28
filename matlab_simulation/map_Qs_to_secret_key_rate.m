function secretKeyRate = map_Qs_to_secret_key_rate(Qx, Qz, Qab)

%Computes the secret key rate from the GHZ-state error quantities Qx, Qz, and Qab.
%Input:
%   Qx: X-basis error quantity.
%   Qz: Z-basis error quantity.
%   Qab: Pairwise error quantity used in the binary entropy term.
%
%Output:
%   secretKeyRate: Secret key rate. The returned value is lower-bounded by zero.
%
%Formula:
%   secretKeyRate = max(0, p1*log2(p1) + p2*log2(p2) + (1-Qz)*[1-log2(1-Qz)] - h2(Qab))
%   where
%       p1 = 1 - Qz/2 - Qx,
%       p2 = Qx - Qz/2,
%       and h2(p) is the binary entropy function.
%
%Note:
%       The convention 0*log2(0) = 0 is used.

validateattributes(Qx,  {'numeric'}, {'real', 'scalar', 'finite'});
validateattributes(Qz,  {'numeric'}, {'real', 'scalar', 'finite'});
validateattributes(Qab, {'numeric'}, {'real', 'scalar', 'finite'});

if Qx < 0 || Qx > 1
    error('Qx must be in the interval [0, 1].');
end

if Qz < 0 || Qz > 1
    error('Qz must be in the interval [0, 1].');
end

if Qab < 0 || Qab > 1
    error('Qab must be in the interval [0, 1].');
end

p1 = 1 - (Qz/2) - Qx;
p2 = Qx - (Qz/2);
p3 = 1 - Qz;

tolerance = 1e-14;

if p1 < -tolerance || p2 < -tolerance || p3 < -tolerance
    error(['Invalid input values: the probabilities entering the ', 'secret-key-rate formula must be nonnegative.']);
end

% Treat tiny negative values within the tolerance as numerical roundoff.
p1 = max(p1, 0);
p2 = max(p2, 0);
p3 = max(p3, 0);

term1 = p_log2_p(p1);
term2 = p_log2_p(p2);
term3 = p_times_one_minus_log2_p(p3);
term4 = -binary_entropy(Qab);

secretKeyRate = max(0, term1 + term2 + term3 + term4);

end
