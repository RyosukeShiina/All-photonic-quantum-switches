function vVec = R_Find_v(sigVec, ErrProb, vmax)

%{

[Abstract]

This function outputs the window sizes corresponding to the standard deviations of the Gaussian displacement noise,  
as well as the bit-flip error probabilities after post-selection measurements.

[Inputs]

sigVec — A row vector whose elements represent the 9 standard deviations of the Gaussian displacement noise. Typically, we set sigVec = [0.214, 0.225, 0.236, 0.191, 0.203, 0.236, 0.246, 0.203, 0.215].

ErrProb — The target bit-flip error probability after post-selection measurements. To achieve this target, we calculate corresponding window sizes.

vmax —  An upper bound for the window size search.

[Output]
vVec —  A row vector whose elements represent the window sizes corresponding to each standard deviation in sigVec, chosen to satisfy the specified bit-flip error probability ErrProb.

[Example]

sigVec = [0.214, 0.225, 0.236, 0.191, 0.203, 0.236, 0.246, 0.203, 0.215]
vVec = R_Find_v(sigVec, 1.45e-06, 0.88)


%}



%First, we prepare a blank row vector to record the window sizes.
%The size(sigVec) returns the size of the matrix. In this case, size(sigVec) = (1, 9). Since we need the second dimension, we use size(sigVec, 2) to extract it.
vVec = zeros(1,size(sigVec,2));



%For each standard deviation, we calculate the corresponding window size.
for  i = 1:size(sigVec,2)

    sig = sigVec(i);



    %The syms v clears any previous definitions of v and defines v as a symbolic scalar variable.
    syms v



    %The vpasolve(equation, v, [0, vmax]) function returns a solution for v by solving the equation within the interval [0, vmax].



    %As a property of the Gaussian distribution with standard deviation sigma and mean zero, the probability that a value lies between –a and a is given by erf(a/ (sqrt(2)*sigma)).
    
    
    
    %Since erf(((sqrt(pi)/2) + v)/(sqrt(2)*sigma))) — which we denote as X — represents the probability that a value lies within the interval [-(sqrt(pi)/2)+v), sqrt(pi)/2)+v], the quantity (1 – X) gives the probability that a value lies outside this interval.



    %The denominator represents the total probability excluding the two window regions, while the numerator captures only the probability in the regions outside the windows — i.e., the bit-flip regions.
    v = vpasolve(ErrProb == (1-erf(((sqrt(pi)/2) + v)/(sqrt(2)*sig)))  /  (1-erf(((sqrt(pi)/2) + v)/(sqrt(2)*sig)) + erf(((sqrt(pi)/2) - v)/(sqrt(2)*sig))), v, [0,vmax]);



    %When v is not found, we handle the case with exception handling and output 0.
    if isempty(v)
        v = 0;
    end

    
    
    %When v is found, we store the value in vVec.
    vVec(1,i) = v;
end