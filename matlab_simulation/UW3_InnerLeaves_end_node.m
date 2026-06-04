function logErr = UW3_InnerLeaves_end_node(L0, sigGKP, etas, etam, etad, etac, Lcavity, k, ErrProbVec, PerrorQ1, PerrorP1, PerrorQ2, PerrorP2)




tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';


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



Sampled3Sigma = binornd(1,ErrProbVec(1),100,k);
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

[qdeltas(1:4,:), pdeltas(1:4,:)] = deal(-pdeltas(1:4,:), qdeltas(1:4,:));





eta = etam^(L0*1000*10/(Lcavity*7));
sigChannel = sqrt(2*sigGKP^2 + (1-etas^2*etac^4*eta*etad)/(etas^2*etac^4*eta*etad));


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
PerrorQ3 = 1-2.^PcorrectQ;
PerrorP3 = 1-2.^PcorrectP;

PerrorQ = PerrorQ1.*(1-PerrorQ2).*(1-PerrorQ3) + (1-PerrorQ1).*PerrorQ2.*(1-PerrorQ3) + (1-PerrorQ1).*(1-PerrorQ2).*PerrorQ3 + PerrorQ1.*PerrorQ2.*PerrorQ3;
PerrorP = PerrorP1.*(1-PerrorP2).*(1-PerrorP3) + (1-PerrorP1).*PerrorP2.*(1-PerrorP3) + (1-PerrorP1).*(1-PerrorP2).*PerrorP3 + PerrorP1.*PerrorP2.*PerrorP3;

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


logErr = [Zerr,Xerr];
