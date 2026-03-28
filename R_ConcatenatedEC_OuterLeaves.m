function [MultiqubitErrors, Pcorrect] = R_ConcatenatedEC_OuterLeaves(deltas, sigma, tableSingleErr, tableDoubleErr, tableTripleErr)

%{

[Abstract]

This function simulates Outer-Leaves Swapping. It includes both GKP error correction and [[7, 1, 3]] Steane error correction.

[Inputs]

deltas — A column vector with 7 elements. Each element represents a continuous displacement just before a homodyne measurement, in either the q or p quadrature. These displacement values are assumed to be obtained from the measurements.

sigma — A scalar representing the standard deviation of the Gaussian displacement noise applied before the homodyne measurements.

tableSingleErr — The lookup table used to detect weight-1 bit-flip errors in the [[7, 1, 3]] code.

tableDoubleErr — The lookup table used to detect weight-2 bit-flip errors in the [[7, 1, 3]] code.

tableTripleErr — The lookup table used to detect weight-3 bit-flip errors in the [[7, 1, 3]] code.

[Output]

MultiqubitErrors — A row vector with 7 binary elements, resulting from GKP error correction and [[7, 1, 3]] Steane error correction. If no error occurs, the vector contains all zeros.

Pcorrect — The small r(q) or r(p) value, defined as the maximum ξ divided by the total ξ.

[Example]

deltas = [2.456; -1.426; 0.003; 0.461; -0.343; 1.333; 4.000] 

sigma = 0.527

tableSingleErr = [ 0, 0, 0, 1, 1, 1, 1; 0, 1, 1, 0, 0, 1, 1; 1, 0, 1, 0, 1, 0, 1]';

tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end

tableTripleErr =  zeros(7,7,7,3);
for i = 1:7
   for j = 1:7
       for l = 1:7
        tableTripleErr(i,j,l,:) = mod(tableSingleErr(i,:) + tableSingleErr(j,:)+ tableSingleErr(l,:), 2);
       end
   end
end

[MultiqubitErrors, Pcorrect] = R_ConcatenatedEC_OuterLeaves(deltas, sigma, tableSingleErr, tableDoubleErr, tableTripleErr)

%}



%Using R_ReminderMod function, we convert each value in deltas into the interval [–sqrt(pi)/2, sqrt(pi)/2], i.e., approximately [–0.886, 0.886].
ZmatrixPerfect = R_ReminderMod(deltas, sqrt(pi));



%We apply GKP error correction, where each value is assumed to come from its nearest peak, and the corresponding displacement is subtracted.
%Here, since we have converted deltas into the interval [–sqrt(pi)/2, sqrt(pi)/2], we assume that each value comes from the peak at zero, and subtract the displacement accordingly to bring it back to zero.
%When a displacement does not originate from the nearest peak, we correct it by shifting it to a different peak modulo sqrt(pi), excluding zero.
deltas = deltas - ZmatrixPerfect;



%Next, we divide each element of deltas by sqrt(pi) and round the result to the nearest integer. 
%Even numbers indicate correctly decoded qubits, while odd numbers indicate qubits with bit-flip errors.
ns = round(deltas/sqrt(pi)); 



%Then, we convert each element of deltas into a binary value by taking modulo 2.  
%A value of 0 indicates a correctly decoded qubit, while a value of 1 indicates a qubit with a bit-flip error.
%We first initialize a blank column vector, MultiqubitErrors.
MultiqubitErrors = zeros(7,1);
for i = 1:7
    if mod(ns(i),2) == 1
        MultiqubitErrors(i) = 1;
    end
end



%We apply [[7, 1, 3]] Steane error correction.  First, we compute the syndrome.
%We perform a stabilizer measurement corresponding to the generator IIIXXXX or IIIZZZZ.  
%The output is a binary value (0 or 1), representing the parity of X errors or Z errors on qubits 4–7, respectively.
parityIIIPPPP = mod(sum(MultiqubitErrors(4:7)), 2);



%We perform a stabilizer measurement corresponding to the generator IXXIIXX or IZZIIZZ.
parityIPPIIPP = mod(sum(MultiqubitErrors([2:3,6:7])), 2);



%We perform a stabilizer measurement corresponding to the generator XIXIXIX or ZIZIZIZ. 
parityPIPIPIP = mod(sum(MultiqubitErrors([1,3,5,7])), 2);



%We then combine the results of the above three stabilizer measurements to construct the syndrome.
parityVectorXerr = [parityIIIPPPP, parityIPPIIPP, parityPIPIPIP];



%Using the R_SyndromeToErrorsOuter function, we list all error patterns that produce the obtained syndrome.
error_matrix = R_SyndromeToErrors(parityVectorXerr, tableSingleErr, tableDoubleErr, tableTripleErr);



%We count the number of error patterns, which is stored in num_errs.
matrix_size = size(error_matrix);
num_errs = matrix_size(1);



%We prepare a row vector to store the corresponding ξ values for each error pattern.
ErrProb = zeros(1, num_errs);



%Using the R_JointErrorLikelihood function, we calculate the corresponding ξ values for each error pattern. The variable ZmatrixPerfect is calculated above by converting the deltas into the interval [–sqrt(pi)/2, sqrt(pi)/2].
for k = 1:num_errs
    ErrProb(1,k) = R_JointErrorLikelihood(error_matrix(k,:), ZmatrixPerfect, sigma);
end


if isequal(error_matrix(1,:), zeros(1,7))
    ErrProbGrouped = [ErrProb(1,1), log2(sum(2.^ErrProb(1,2:end)))];
else
    ErrProbGrouped = [log2(2.^ErrProb(1,1) + sum(2.^ErrProb(1,5:8))), log2(sum(2.^ErrProb(1,2:4)))];
end

[maxErrProb,indmax] = max(ErrProbGrouped);


MultiqubitErrors = mod(MultiqubitErrors + transpose(error_matrix(indmax,:)), 2);




%The following 7 weight-4 bit-flip error patterns are not considered errors. This is because the logical zero state is |0>_L = 1/8 ( |0001111> + |0110011> + |1010101> + |0111100> + |1011010> + |1100110> + |1101001> ). 
%Therefore, if MultiqubitErrors contains any of these weight-4 patterns, we replace them with the all-zero column vector.
if isequal(MultiqubitErrors, [0; 0; 0; 1; 1; 1; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 0; 0; 1; 1])...
  || isequal(MultiqubitErrors, [1; 0; 1; 0; 1; 0; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 1; 1; 0; 0])...
  || isequal(MultiqubitErrors, [1; 0; 1; 1; 0; 1; 0]) || isequal(MultiqubitErrors, [1; 1; 0; 0; 1; 1; 0])...
  || isequal(MultiqubitErrors, [1; 1; 0; 1; 0; 0; 1])

    MultiqubitErrors = zeros(7,1);
end



%On the other hand, we calculate small r(q) or r(p) value, defined as the maximum ξ divided by the total ξ.
%In the R_JointErrorLikelihood function, we use base-2 logarithms. Accordingly, we compute log_2 r(q) = log_2 (maximum ξ) - log_2 (total ξ) in the same way.
%However, since each component of ErrProb is already in logarithmic form, we use "2.^" to convert it back and obtain the total ξ.
Pcorrect = maxErrProb - log2(sum(2.^ErrProb)); 
