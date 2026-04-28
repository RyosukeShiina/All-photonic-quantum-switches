function h = binary_entropy(p)

%Computes the binary entropy function:
%   h2(p) = -p*log2(p) - (1-p)*log2(1-p).
%
%The endpoint values h2(0) = h2(1) = 0 are used.

if p < 0 || p > 1
    error('Input to binary_entropy must be in the interval [0, 1].');
end

if p == 0 || p == 1
    h = 0;
else
    h = -p * log2(p) - (1 - p) * log2(1 - p);
end
