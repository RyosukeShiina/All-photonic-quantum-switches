function [ErrProb, Ppost] = R_LogErrAfterPost(sig, v)

%{

[Abstract]

This function calculates both the bit-flip error probability and the survival probability.

Typically, we use this function to calculate the bit-flip error probability for Measurement Type 7,  which has the largest standard deviation among all measurement types.

[Inputs]

sig — A scalar representing the standard deviation of the Gaussian displacement noise. Typically, we set sig = 0.246 for Measurement Type 7.

v — The size parameter of the discard windows. The discard windows are defined as the intervals [-sqrt(pi)/2)-v, -sqrt(pi)/2)+v] and [sqrt(pi)/2)-v, sqrt(pi)/2)+v]. Typically, we set v = 0.3 for Measurement Type 7.

[Output]
ErrProb — The bit-flip error probability, defined as the ratio of:
– a numerator representing the probability in the regions outside the discard windows (i.e., the bit-flip regions), and  
– a denominator representing the total probability excluding the two window regions.

Ppost — The survival probability, defined as the total probability excluding the two discard window regions.

[Example]

[ErrProb, Ppost] = R_LogErrAfterPost(0.246, 0.3)

%}



%When sig = 0 (i.e., the Dirac delta function case), we handle it with exception handling and set ErrProb = 0 and Ppost = 1.
if sig == 0
    ErrProb = 0;
    Ppost = 1;
else
    


    %This defines an anonymous function fun that evaluates the probability density function (PDF) of a Gaussian distribution with mean 0 and standard deviation sig at the input value x.
    fun = @(x) normpdf(x,0,sig);



    %We integrate the function above over the interval between the closest and the second closest discard windows,i.e., [sqrt(pi)/2 + v, 3*sqrt(pi)/2 – v], which corresponds to one of the bit-flip regions.  
    %The factor of 2 accounts for the symmetric bit-flip region on the negative side.
    %We consider only the interval [-3*sqrt(pi)/2+v and 3*sqrt(pi)/2-v], as the standard deviation of the Gaussian displacement noise is sufficiently small in this simulation, rendering the contribution from regions outside this interval negligible.
    E1 = 2*integral(fun, sqrt(pi)/2+v, 3*sqrt(pi)/2-v); 



    %We integrate the function above over the interval between the two closest discard windows, i.e., [–sqrt(pi)/2 + v, sqrt(pi)/2 – v]. In this region, shift errors are correctly corrected.
    E0 = integral(fun, -sqrt(pi)/2+v, sqrt(pi)/2-v);

    

    %Ppost is the survival probability, defined as the total probability excluding the two discard window regions.
    Ppost = E0 + E1;


    
    %ErrProb is the bit-flip error probability.
    ErrProb = E1/Ppost;
end