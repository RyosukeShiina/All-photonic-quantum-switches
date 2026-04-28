function value = p_log2_p(p)

%Computes p*log2(p), using the convention 0*log2(0) = 0.

if p == 0
    value = 0;
else
    value = p * log2(p);
end

end
