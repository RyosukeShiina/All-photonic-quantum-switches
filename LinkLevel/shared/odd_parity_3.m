function out = odd_parity_3(a, b, c)

a = a(:);
b = b(:);
c = c(:);

out = a .* (1 - b) .* (1 - c) ...
    + (1 - a) .* b .* (1 - c) ...
    + (1 - a) .* (1 - b) .* c ...
    + a .* b .* c;

end