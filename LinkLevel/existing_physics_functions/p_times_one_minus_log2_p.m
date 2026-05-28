function value = p_times_one_minus_log2_p(p)

%Computes p * (1 - log2(p)), using the limiting value 0 at p = 0.

if p == 0
    value = 0;
else
    value = p * (1 - log2(p));
end

end
