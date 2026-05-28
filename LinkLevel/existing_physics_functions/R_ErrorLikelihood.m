function out = R_ErrorLikelihood(x, sig)

%{

[Abstract]

This function computes the value z, which is then used in the calculation of ξ.

[Inputs]

x — A column vector with 7 elements. Each element represents a continuous displacement just before a homodyne measurement, in either the q or p quadrature. These displacement values are assumed to be obtained from the measurements.

sig — A scalar representing the standard deviation of the Gaussian displacement noise applied before the homodyne measurement.

[Output]

out — A scalar value z that represents the error likelihood of a measurement.

[Example]

x = [2.456; -1.426; 0.003; 0.461; -0.343; 1.333; 4.000] 
out = R_ErrorLikelihood(x, 0.527)

%}



%First, we prepare a blank column vector of the same size as x to store the corresponding ξ values.
out = zeros(size(x));

if sig == 0
    % noiseless: perfect decoding -> zero bit-flip likelihood
    return;
end



%The ideal formula for z involves infinite series in both the numerator and the denominator. Therefore, we specify the range of n for each infinite series to be symmetric around zero.
%n1 takes the integer values -1 and 1, and n2 takes integer values from -2 to 2.
n1 = -1:1:0;
n2 = -2:1:2;





%Then, we compute the ξ value for each component of x.
for idx = 1:numel(x)

    %sum1 is the numerator part of Eq.(11) of the paper: "Fault-tolerant bosonic quantum error correction with the surface-GKP code".

    %Since n1 is -1 or 0, we have -(z+sqrt(pi))^2 and -(z-sqrt(pi))^2 parts.
    sum1 = sum(exp( -( x(idx) - (2*n1+1)*sqrt(pi) ).^2 / (2*((sig)^2)) ));

    %sum2 is the denominator part of Eq.(11) of the paper: "Fault-tolerant bosonic quantum error correction with the surface-GKP code".
        
    %Since n2 is -2 or -1 or 0 or 1 or 2, we have -(z+2*sqrt(pi))^2 and -(z+sqrt(pi))^2 and -(z)^2 and -(z-sqrt(pi))^2 and -(z-2*sqrt(pi))^2 parts.
    sum2 = sum(exp( -( x(idx) - n2*sqrt(pi) ).^2 / (2*((sig)^2)) ));

    %Avoid 0/0 or division by 0 due to underflow
    sum2 = max(sum2, realmin);

    out(idx) = max(sum1/sum2, 1e-15);

end

end
