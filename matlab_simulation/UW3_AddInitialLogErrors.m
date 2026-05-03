function [qdeltas, pdeltas] = UW3_AddInitialLogErrors(qdeltas, pdeltas, Sampled)

Sampled3Sigma = Sampled{1};

Sampled3SigmaSwitch = Sampled{2};
Sampled3SigmaSwitchTwice = Sampled{3};

Sampled2SigmaSwitch = Sampled{4};
Sampled2SigmaSwitchTwice = Sampled{5};

SampledRefresh3SigmaSwitchTwice = Sampled{6};
SampledRefresh3SigmaSwitchThreeTimes = Sampled{7};
SampledRefresh2SigmaSwitchTwice = Sampled{8};
SampledRefresh2SigmaSwitchThreeTimes = Sampled{9};

SampledRefresh3SigmaSwitch = Sampled{10};
SampledRefresh2SigmaSwitch = Sampled{11};

SampledNoPost = Sampled{12};

%Firstly the correlated errors:

if Sampled3Sigma(1) == 1 %3(A)
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if Sampled3Sigma(2) == 1 %3(B)
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end

if Sampled3Sigma(3) == 1 %3(C)
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end

if Sampled3Sigma(4) == 1 %3(D)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
end

if Sampled3Sigma(5) == 1 %3(E)
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end

if Sampled3Sigma(6) == 1 %3(F)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
end

if Sampled3Sigma(7) == 1 %3(G)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if Sampled3Sigma(8) == 1 %3(H)
    pdeltas(5) = pdeltas(5) + sqrt(pi);
    pdeltas(6) = pdeltas(6) + sqrt(pi);
end

if Sampled2SigmaSwitch(1) == 1 %2+S1(I)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if Sampled3Sigma(9) == 1 %3(AA)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if Sampled2SigmaSwitch(2) == 1 %2+S1(AB)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if SampledNoPost(1) == 1 %2+S1(v=0)(AC)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if Sampled2SigmaSwitchTwice(1) == 1 %2+S2(AD)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if SampledRefresh3SigmaSwitchThreeTimes(1) == 1 %3+S3(refresh)(AE)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

if SampledRefresh2SigmaSwitchThreeTimes(1) == 1 %2+S3(refresh)(AF)
    pdeltas(1) = pdeltas(1) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(3) = pdeltas(3) + sqrt(pi);
end

%Now the uncorrelated errors
%Without switch
pdeltas = pdeltas + Sampled3Sigma(10:16) * sqrt(pi); %3

%With single switch and 3 sigma
pdeltas(1) = pdeltas(1) + Sampled3SigmaSwitch(1) * sqrt(pi); %3+S1
pdeltas(2) = pdeltas(2) + Sampled3SigmaSwitch(2) * sqrt(pi); %3+S1
pdeltas(3) = pdeltas(3) + Sampled3SigmaSwitch(3) * sqrt(pi); %3+S1
pdeltas(5) = pdeltas(5) + Sampled3SigmaSwitch(4) * sqrt(pi); %3+S1
pdeltas(6) = pdeltas(6) + Sampled3SigmaSwitch(5) * sqrt(pi); %3+S1
pdeltas(7) = pdeltas(7) + Sampled3SigmaSwitch(6) * sqrt(pi); %3+S1

%With Switch Twice and 3 Sigma
pdeltas(1) = pdeltas(1) + Sampled3SigmaSwitchTwice(1) * sqrt(pi); %3+S2
pdeltas(5) = pdeltas(5) + Sampled3SigmaSwitchTwice(2) * sqrt(pi); %3+S2

%With single switch and 2 sigma
pdeltas(4) = pdeltas(4) + Sampled2SigmaSwitch(3) * sqrt(pi); %2+S1
pdeltas = pdeltas + SampledNoPost(2:8) * sqrt(pi); %2+S1(v=0)

%With Switch Twice and 2 Sigma
pdeltas(2) = pdeltas(2) + Sampled2SigmaSwitchTwice(2) * sqrt(pi); %2+S2
pdeltas(3) = pdeltas(3) + Sampled2SigmaSwitchTwice(3) * sqrt(pi); %2+S2
pdeltas(4) = pdeltas(4) + Sampled2SigmaSwitchTwice(4) * sqrt(pi); %2+S2
pdeltas(6) = pdeltas(6) + Sampled2SigmaSwitchTwice(5) * sqrt(pi); %2+S2
pdeltas(7) = pdeltas(7) + Sampled2SigmaSwitchTwice(6) * sqrt(pi); %2+S2

%Refresh Switch Twice and 3 sigma
%None

%Refresh Switch Three Times and 3 sigma
pdeltas = pdeltas + SampledRefresh3SigmaSwitchThreeTimes(2:8) * sqrt(pi); %3+S3(refresh)

%Refresh Switch Twice and 2 sigma
pdeltas = pdeltas + SampledRefresh2SigmaSwitchTwice(1:7) * sqrt(pi); %2+S2(refresh)
qdeltas = qdeltas + SampledRefresh2SigmaSwitchTwice(8:14) * sqrt(pi); %2+S2(refresh) %(X)

%Refresh Switch Three Times and 2 sigma
pdeltas = pdeltas + SampledRefresh2SigmaSwitchThreeTimes(2:8) * sqrt(pi); %2+S3(refresh)

pdeltas(1) = pdeltas(1) + SampledRefresh2SigmaSwitchThreeTimes(9) * sqrt(pi); %2+S3(refresh)
pdeltas(1) = pdeltas(1) + SampledRefresh2SigmaSwitchThreeTimes(10) * sqrt(pi); %2+S3(refresh)
qdeltas(1) = qdeltas(1) + SampledRefresh2SigmaSwitchThreeTimes(11) * sqrt(pi); %2+S3(refresh) %(X)
qdeltas(1) = qdeltas(1) + SampledRefresh2SigmaSwitchThreeTimes(12) * sqrt(pi); %2+S3(refresh) %(X)

pdeltas(2) = pdeltas(2) + SampledRefresh2SigmaSwitchThreeTimes(13) * sqrt(pi); %2+S3(refresh)
qdeltas(2) = qdeltas(2) + SampledRefresh2SigmaSwitchThreeTimes(14) * sqrt(pi); %2+S3(refresh) %(X)

pdeltas(3) = pdeltas(3) + SampledRefresh2SigmaSwitchThreeTimes(15) * sqrt(pi); %2+S3(refresh)
qdeltas(3) = qdeltas(3) + SampledRefresh2SigmaSwitchThreeTimes(16) * sqrt(pi); %2+S3(refresh) %(X)

pdeltas(5) = pdeltas(5) + SampledRefresh2SigmaSwitchThreeTimes(17) * sqrt(pi); %2+S3(refresh)
pdeltas(5) = pdeltas(5) + SampledRefresh2SigmaSwitchThreeTimes(18) * sqrt(pi); %2+S3(refresh)
qdeltas(5) = qdeltas(5) + SampledRefresh2SigmaSwitchThreeTimes(19) * sqrt(pi); %2+S3(refresh)
qdeltas(5) = qdeltas(5) + SampledRefresh2SigmaSwitchThreeTimes(20) * sqrt(pi); %2+S3(refresh)

pdeltas(6) = pdeltas(6) + SampledRefresh2SigmaSwitchThreeTimes(21) * sqrt(pi); %2+S3(refresh)
qdeltas(6) = qdeltas(6) + SampledRefresh2SigmaSwitchThreeTimes(22) * sqrt(pi); %2+S3(refresh) %(X)

pdeltas(7) = pdeltas(7) + SampledRefresh2SigmaSwitchThreeTimes(23) * sqrt(pi); %2+S3(refresh)
qdeltas(7) = qdeltas(7) + SampledRefresh2SigmaSwitchThreeTimes(24) * sqrt(pi); %2+S3(refresh) %(X)






