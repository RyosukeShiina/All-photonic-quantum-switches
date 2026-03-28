function [qdeltas, pdeltas] = UW2_AddInitialLogErrors(qdeltas, pdeltas, Sampled)

%This function adds some errors that may have occurred during a construction of logical-logical bell pair.
%This function is used in our InnerLeaves.m. and our OuterLeaves.m. 

%Inputs: 
%qdeltas is a (7, 1) column vector having bit-flip errors information in q-coordinate. Typically, we set [0; 0; 0; 0; 0; 0; 0].
%pdeltas is a (7, 1) column vector having bit-flip errors information in p-coordinate. Typically, we set [0; 0; 0; 0; 0; 0; 0].
%Sampled is a list of 10 different column vectors having binary results of
%a sampling. 

%Outputs: 
%qdeltas is a (7, 1) column vector having bit-flip errors information that may have occurred during a construction in q-coordinate.
%pdeltas is a (7, 1) column vector having bit-flip errors information that may have occurred during a construction in p-coordinate.

Sampled3Sigma = Sampled{1};
Sampled3SigmaSwitch = Sampled{2};
Sampled3SigmaSwitchTwice = Sampled{3};
Sampled2SigmaSwitch = Sampled{4};
Sampled2SigmaSwitchTwice = Sampled{5};
SampledRefresh3SigmaSwitchTwice = Sampled{6};
SampledRefresh3SigmaSwitchThreeTimes = Sampled{7};
SampledRefresh2SigmaSwitchTwice = Sampled{8};
SampledRefresh2SigmaSwitchThreeTimes = Sampled{9};
SampledNoPost = Sampled{10};




%Firstly the correlated errors without switch loss:

%a1
if Sampled3Sigma(1) == 1 
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end


%a2
if Sampled3Sigma(2) == 1
    pdeltas(4) = pdeltas(4) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end


%a3
if Sampled3Sigma(3) == 1
    pdeltas(4) = pdeltas(4) + sqrt(pi);
    pdeltas(1) = pdeltas(1) + sqrt(pi);
end


%a4
if Sampled3Sigma(4) == 1
    pdeltas(4) = pdeltas(4) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
end



%a5 and c5
if Sampled3Sigma(5) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end
if Sampled3Sigma(6) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end


%a6 and c6
if Sampled3Sigma(7) == 1
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end
if Sampled3Sigma(8) == 1
   pdeltas(5) = pdeltas(5) + sqrt(pi);
   pdeltas(7) = pdeltas(7) + sqrt(pi);
end


%a7 and c7
if Sampled3Sigma(9) == 1
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end
if Sampled3Sigma(10) == 1
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end


%a8
if Sampled3Sigma(11) == 1
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end


%a9
if Sampled3Sigma(12) == 1
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
end


%a10
if Sampled3Sigma(13) == 1
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

%Now correlated errors with switch loss:

%b5
if Sampled3SigmaSwitch(1) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end


%b6
if Sampled3SigmaSwitch(2) == 1
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end


%b7
if Sampled3SigmaSwitch(3) == 1
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end


%Now the uncorrelated errors as approximations of the correlated errors
%across LL Bell pair
pdeltas(1:3) = pdeltas(1:3) + Sampled3SigmaSwitch(4:6) * sqrt(pi);






%Now the uncorrelated errors

%Without switch
pdeltas = pdeltas + Sampled3Sigma(14:20) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + Sampled3Sigma(21:23) * sqrt(pi);

%With single switch and 3 sigma
pdeltas([1:4,6]) = pdeltas([1:4,6]) + Sampled3SigmaSwitch(7:11) * sqrt(pi);

%With single switch and 2 sigma
pdeltas([1,3:7]) = pdeltas([1,3:7]) + Sampled2SigmaSwitch(1:6) * sqrt(pi);
pdeltas([4,7]) = pdeltas([4,7]) + Sampled2SigmaSwitch(7:8) * sqrt(pi);

pdeltas([2,5]) = pdeltas([2,5]) + SampledNoPost(1:2) * sqrt(pi);

%With Switch Twice and 3 Sigma
pdeltas([2:3,5:7]) = pdeltas([2:3,5:7]) + Sampled3SigmaSwitchTwice(1:5) * sqrt(pi);

%With Switch Twice and 2 Sigma
pdeltas(1:3) = pdeltas(1:3) + Sampled2SigmaSwitchTwice(1:3) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + Sampled2SigmaSwitchTwice(4:6) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + Sampled2SigmaSwitchTwice(7:9) * sqrt(pi);
pdeltas(1) = pdeltas(1) + Sampled2SigmaSwitchTwice(10) * sqrt(pi);


%Refresh Switch Twice and 3 sigma
pdeltas([5,7]) = pdeltas([5,7]) + SampledRefresh3SigmaSwitchTwice(1:2) * sqrt(pi);

%Refresh Switch Twice and 2 sigma
pdeltas([1,2,4,5,7]) = pdeltas([1,2,4,5,7]) + SampledRefresh2SigmaSwitchTwice(1:5) * sqrt(pi);
pdeltas([4,5,7]) = pdeltas([4,5,7]) + SampledRefresh2SigmaSwitchTwice(6:8) * sqrt(pi);

qdeltas([5,7]) = qdeltas([5,7]) + SampledRefresh2SigmaSwitchTwice(9:10) * sqrt(pi);%THIS IS X


%Refresh Switch Three Times and 3 sigma
pdeltas([1:4,6]) = pdeltas([1:4,6]) + SampledRefresh3SigmaSwitchThreeTimes(1:5) * sqrt(pi);

%Refresh Switch Three Times and 2 sigma

pdeltas = pdeltas + SampledRefresh2SigmaSwitchThreeTimes(1:7) * sqrt(pi);
pdeltas = pdeltas + SampledRefresh2SigmaSwitchThreeTimes(8:14) * sqrt(pi);
pdeltas = pdeltas + SampledRefresh2SigmaSwitchThreeTimes(15:21) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + SampledRefresh2SigmaSwitchThreeTimes(22:24) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + SampledRefresh2SigmaSwitchThreeTimes(25:27) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + SampledRefresh2SigmaSwitchThreeTimes(28:30) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + SampledRefresh2SigmaSwitchThreeTimes(31:33) * sqrt(pi);
pdeltas(1:3) = pdeltas(1:3) + SampledRefresh2SigmaSwitchThreeTimes(34:36) * sqrt(pi);
pdeltas(3) = pdeltas(3) + SampledRefresh2SigmaSwitchThreeTimes(37) * sqrt(pi);



qdeltas = qdeltas + SampledRefresh2SigmaSwitchThreeTimes(38:44) * sqrt(pi); %THIS IS X
qdeltas([1:4,6]) = qdeltas([1:4,6]) + SampledRefresh2SigmaSwitchThreeTimes(45:49) * sqrt(pi); %THIS IS X


