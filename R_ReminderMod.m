function out = R_ReminderMod(vec, modval)

%{

[Abstract]

This function computes the modulo of a value with respect to sqrt(pi), but unlike the standard modulo operation, the result is wrapped into the interval [-sqrt(pi)/2, sqrt(pi)/2].

[Inputs]

vec — A column vector with 7 elements. Each element represents a continuous displacement just before a homodyne measurement,  
in either the q or p quadrature. These displacement values are assumed to be obtained from the measurements.

modval — A scalar value with respect to which the modulo is computed.

[Output]

out — A column vector with 7 elements. Each element is equal to the corresponding element of vec modulo modval, mapped into the interval [−modval/2, modval/2].

[Example]

vec = [2.456; -1.426; 0.003; 0.461; -0.343; 1.333; 4.000] 
out = R_ReminderMod(vec, sqrt(pi))

%}



%First, we use the mod function to compute the value modulo sqrt(pi), and the result is mapped into the interval [0, sqrt(pi)].
%out = mod(vec, modval);



%Next, if the result lies in the interval [sqrt(pi)/2, sqrt(pi)], we subtract sqrt(pi) once more. As a result, all values are mapped into the interval [-sqrt(pi)/2, sqrt(pi)/2].
%for i = 1:length(vec)
%    if out(i) > sqrt(pi)/2
%        out(i) = out(i) - sqrt(pi);
%    end
%end


N = length(vec);

out = mod(vec + (modval/2)*ones(N,1), modval) - (modval/2)*ones(N,1);
%out = vec - modval*floor(vec/modval + 0.5 * ones(N,1));
