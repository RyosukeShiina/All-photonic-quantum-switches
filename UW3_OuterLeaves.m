function logErr = UW3_OuterLeaves(L0, sigGKP, etas, etad, etac, k, ErrProbVec)

%{

[Abstract]

This function outputs the simulated errors in the Z and X bases within a single segment, during (1) Construction of Elementary Entangled Bell Pairs and (2) Outer-Leaves Swapping.


[Inputs]

L0 — The distance between a repeater and its adjacent repeater, measured in kilometers [km]. Typically, we set L0 = 9.

sigGKP — The standard deviation of the Gaussian displacement noise applied to both the q and p quadratures of both qubits in the G0 states. Typically, we set sigGKP = 0.12.

etas — The efficiency of the optical switch applied to the remaining graph states after a measurement with discard windows. Typically, we set etas=0.995.

etad — The efficiency of a single homodyne detection. Typically, we set etad = 0.9975.

etac — The efficiency of a single connector between the photon fiber and the quantum chip. Typically, we set etac = 0.99.

k — The number of multiplexing levels. For example, setting k = 15 results in the generation of 15 end-to-end entangled Bell pairs.

ErrProbVec — The output of the R_LogErrAfterPost function. It contains the bit-flip error probabilities for the 10 measurement types, which are made approximately equal by tuning the window sizes.


[Output]

logErr — A (k, 2) binary matrix. Each row corresponds to the i-th high-quality optical channel. The first column indicates the presence of a bit-flip error in the Z basis, and the second column indicates the presence of a bit-flip error in the X basis.
        Specifically:
            - [0, 0] means that neither Z nor X bit-flip errors occurred.
            - [1, 0] means that only a Z bit-flip error occurred.
            - [0, 1] means that only an X bit-flip error occurred.
            - [1, 1] means that both Z and X bit-flip errors occurred.

[Example]

ErrProbVec = 1.0e-05 *[0.1479, 0.1479, 0.1479, 0.1479, 0.1479, 0.1479, 0.1479, 0.1479, 0.1479, 0.3341]

logErr = UW3_OuterLeaves(9, 0.12, 0.995, 0.9975, 0.99, 15, ErrProbVec)

%}




%ASK
%We define 3 look-up tables for the [[7, 1, 3]]-code. Unlike R_InnerLeaves.m, we use 3 look-up tables because outer leaves tend to have more errors than inner leaves.

%This first table is for detecting a single bit-flip error.
%Here, we transpose the look-up table. This is because this makes it easier to compare our result [a, b, c] (row vector) with [x, y, z] of the look-up table within our BellMeasurementEC-function.
tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';

%This second table is for detecting two bit-flip errors.
%Basically, we add up two row vectors (the ith-row and the j-th row) of the transposed matrix above.
tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end

%This third table is for detecting three bit-flip errors.
%Basically, we add up three row vectors (the ith-row, the j-th row, and the l-th row) of the transposed matrix above.
tableTripleErr =  zeros(7,7,7,3);
for i = 1:7
   for j = 1:7
       for l = 1:7
        tableTripleErr(i,j,l,:) = mod(tableSingleErr(i,:) + tableSingleErr(j,:)+ tableSingleErr(l,:), 2);
       end
   end
end

%multip k

%The binornd(n, p, a, k)-function generates random numbers (a, k)-column matrix from the binomial distribution specified by the trial numbers n (we set n=1 because we can measure each photon only once) and the probability of success for each trial p.
%We have 10 bit-flip error probabilities after post-selection that correspond to 10 measurement types.

%We do measurement type-1 46 times during the construction of logical-logical bell pairs.
Sampled3Sigma = binornd(1,ErrProbVec(1),100,k);

%We do measurement type-2 22 times during the construction of logical-logical bell pairs.
Sampled3SigmaSwitch = binornd(1,ErrProbVec(2),100,k);
Sampled3SigmaSwitchTwice = binornd(1,ErrProbVec(3),100,k);
Sampled2SigmaSwitch = binornd(1,ErrProbVec(4),100,k);
Sampled2SigmaSwitchTwice = binornd(1,ErrProbVec(5),100,k);
SampledRefresh3SigmaSwitchTwice = binornd(1,ErrProbVec(6),100,k);
SampledRefresh3SigmaSwitchThreeTimes = binornd(1,ErrProbVec(7),100,k);
SampledRefresh2SigmaSwitchTwice = binornd(1,ErrProbVec(8),100,k);
SampledRefresh2SigmaSwitchThreeTimes = binornd(1,ErrProbVec(9),100,k);
SampledRefresh3SigmaSwitch = binornd(1,ErrProbVec(10),100,k);
SampledRefresh2SigmaSwitch = binornd(1,ErrProbVec(11),100,k);
SampledNoPost = binornd(1,ErrProbVec(12),100,k);




qdeltas = zeros(7,k);
pdeltas = zeros(7,k);


for i = 1:k
    Sampled1ithlevel = {Sampled3Sigma(1:end/2,i),Sampled3SigmaSwitch(1:end/2,i), Sampled3SigmaSwitchTwice(1:end/2,i), Sampled2SigmaSwitch(1:end/2,i), Sampled2SigmaSwitchTwice(1:end/2,i), SampledRefresh3SigmaSwitchTwice(1:end/2,i), SampledRefresh3SigmaSwitchThreeTimes(1:end/2,i), SampledRefresh2SigmaSwitchTwice(1:end/2,i), SampledRefresh2SigmaSwitchThreeTimes(1:end/2,i),SampledRefresh3SigmaSwitch(1:end/2,i), SampledRefresh2SigmaSwitch(1:end/2,i), SampledNoPost(1:end/2,i)};
    [qdeltas(:,i),pdeltas(:,i)] = UW3_AddInitialLogErrors(qdeltas(:,i), pdeltas(:,i), Sampled1ithlevel);
    Sampled2ithlevel = {Sampled3Sigma(end/2 + 1:end,i), Sampled3SigmaSwitch(end/2 + 1:end,i), Sampled3SigmaSwitchTwice(end/2 + 1:end,i), Sampled2SigmaSwitch(end/2 + 1:end,i), Sampled2SigmaSwitchTwice(end/2 + 1:end,i), SampledRefresh3SigmaSwitchTwice(end/2 + 1:end,i), SampledRefresh3SigmaSwitchThreeTimes(end/2 + 1:end,i), SampledRefresh2SigmaSwitchTwice(end/2 + 1:end,i),SampledRefresh2SigmaSwitchThreeTimes(end/2 + 1:end,i),SampledRefresh3SigmaSwitch(end/2 + 1:end,i),SampledRefresh2SigmaSwitch(end/2 + 1:end,i), SampledNoPost(end/2 + 1:end,i)};
    [qdeltas(:,i),pdeltas(:,i)] = UW3_AddInitialLogErrors(qdeltas(:,i), pdeltas(:,i), Sampled2ithlevel);
end

%Now the Hadamards on the qubits 1-4 to get to the code space of the Bell pair between
%[[7,1,3]] qubit and a single physical qubit.
%They swap noise between quadratures for those qubits (with an extra minus sign one-way).

[qdeltas(5:7,:), pdeltas(5:7,:)] = deal(-pdeltas(5:7,:), qdeltas(5:7,:));

%Now we do fiber coupling followed by immediate TEC
% ErrProbCoupling = LogErrAfterPost(sqrt(2*sigGKP^2 + 1-etac + (1-etad)/etad),0);
% SampledCoupling = binornd(1,ErrProbCoupling,28,k);
%
% qdeltas = qdeltas + SampledCoupling(1:7,k)*sqrt(pi);
% pdeltas = pdeltas + SampledCoupling(8:14,k)*sqrt(pi);
% qdeltas = qdeltas + SampledCoupling(15:21,k)*sqrt(pi);
% pdeltas = pdeltas + SampledCoupling(22:28,k)*sqrt(pi);



Latt = 22;
eta = exp(-L0/(2*Latt));
sigChannel = sqrt(2*sigGKP^2 + (1-etas*etac*eta*etad)/(etas*etac*eta*etad));

Xerr = zeros(k,1);
Zerr = zeros(k,1);

Xerrors = zeros(7,k);
Zerrors = zeros(7,k);

PcorrectQ = zeros(1,k);
PcorrectP = zeros(1,k);

%First q -quadrature

qdeltas = qdeltas + normrnd(0, sigChannel, 7, k);

for i = 1:k
    [Xerrors(:,i),PcorrectQ(i)] = R_ConcatenatedEC_OuterLeaves(qdeltas(:,i), sigChannel, tableSingleErr, tableDoubleErr, tableTripleErr);
end


%Now p-quadrature
pdeltas = pdeltas + normrnd(0, sigChannel, 7, k);
for i = 1:k
    [Zerrors(:,i),PcorrectP(i)] = R_ConcatenatedEC_OuterLeaves(pdeltas(:,i), sigChannel, tableSingleErr, tableDoubleErr, tableTripleErr);
end



%Calculate likelihoods of no error:
PerrorQ = 1-2.^PcorrectQ;
PerrorP = 1-2.^PcorrectP;

SecKeyRanking = zeros(size(PerrorP, 2), 1);

for i = 1:size(PerrorP, 2)
    SecKeyRanking(i) = R_SecretKey6State_per(PerrorP(i), PerrorQ(i));
end

%Find indesces of PNoError in descending order
[~, IndDesc] = sort(SecKeyRanking, 'descend');

%Now check whether there were X errors on the corresponding qubits
%in descening order according to PNoError:
for i = 1:k
    if any(Xerrors(:, IndDesc(i)))
        Xerr(i) = 1;
    end
end

%Now check whether there were Z errors on the corresponding qubits
%in descening order according to PNoError:
for i = 1:k
    if any(Zerrors(:, IndDesc(i)))
        Zerr(i) = 1;
    end
end


logErr = [Zerr, Xerr];
