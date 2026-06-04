function logErr = UW3_end_node_swapping_simplified(L0, sigGKP, etas, etam, etad, etac, Lcavity, k, ErrProbVec)




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



Sampled3Sigma = binornd(1,ErrProbVec(1),100,1);
Sampled3SigmaSwitch = binornd(1,ErrProbVec(2),100,1);
Sampled3SigmaSwitchTwice = binornd(1,ErrProbVec(3),100,1);
Sampled2SigmaSwitch = binornd(1,ErrProbVec(4),100,1);
Sampled2SigmaSwitchTwice = binornd(1,ErrProbVec(5),100,1);
SampledRefresh3SigmaSwitchTwice = binornd(1,ErrProbVec(6),100,1);
SampledRefresh3SigmaSwitchThreeTimes = binornd(1,ErrProbVec(7),100,1);
SampledRefresh2SigmaSwitchTwice = binornd(1,ErrProbVec(8),100,1);
SampledRefresh2SigmaSwitchThreeTimes = binornd(1,ErrProbVec(9),100,1);
SampledRefresh3SigmaSwitch = binornd(1,ErrProbVec(10),100,1);
SampledRefresh2SigmaSwitch = binornd(1,ErrProbVec(11),100,1);
SampledNoPost = binornd(1,ErrProbVec(12),40,1);

qdeltas = zeros(7,1);
pdeltas = zeros(7,1);

Sampled1 = {Sampled3Sigma(1:end/2,1),Sampled3SigmaSwitch(1:end/2,1), Sampled3SigmaSwitchTwice(1:end/2,1), Sampled2SigmaSwitch(1:end/2,1), Sampled2SigmaSwitchTwice(1:end/2,1), SampledRefresh3SigmaSwitchTwice(1:end/2,1), SampledRefresh3SigmaSwitchThreeTimes(1:end/2,1), SampledRefresh2SigmaSwitchTwice(1:end/2,1), SampledRefresh2SigmaSwitchThreeTimes(1:end/2,1), SampledRefresh3SigmaSwitch(1:end/2,1), SampledRefresh2SigmaSwitch(1:end/2,1), SampledNoPost(1:end/2,1)};

Sampled2 = {Sampled3Sigma(end/2 + 1:end,1),Sampled3SigmaSwitch(end/2 + 1:end,1), Sampled3SigmaSwitchTwice(end/2 + 1:end,1), Sampled2SigmaSwitch(end/2 + 1:end,1), Sampled2SigmaSwitchTwice(end/2 + 1:end,1), SampledRefresh3SigmaSwitchTwice(end/2 + 1:end,1), SampledRefresh3SigmaSwitchThreeTimes(end/2 + 1:end,1), SampledRefresh2SigmaSwitchTwice(end/2 + 1:end,1),SampledRefresh2SigmaSwitchThreeTimes(end/2 + 1:end,1), SampledRefresh3SigmaSwitch(end/2 + 1:end,1), SampledRefresh2SigmaSwitch(end/2 + 1:end,1), SampledNoPost(end/2 + 1:end,1)};


[qdeltas, pdeltas] = UW3_AddInitialLogErrors(qdeltas, pdeltas, Sampled1);
[qdeltas, pdeltas] = UW3_AddInitialLogErrors(qdeltas, pdeltas, Sampled2);

[qdeltas(1:4), pdeltas(1:4)] = deal(-pdeltas(1:4), qdeltas(1:4));

eta = etam^(L0*1000*10/(Lcavity*7));
sigChannel = sqrt(2*sigGKP^2 + (1-etas^2*etac^4*eta*etad)/(etas^2*etac^4*eta*etad));


qdeltas = qdeltas + normrnd(0, sigChannel, 7, 1);
Xerrors = R_ConcatenatedEC_InnerLeaves(qdeltas, sigChannel, tableSingleErr, tableDoubleErr, tableTripleErr);


pdeltas = pdeltas + normrnd(0, sigChannel, 7, 1);
Zerrors = R_ConcatenatedEC_InnerLeaves(pdeltas, sigChannel, tableSingleErr, tableDoubleErr, tableTripleErr);



if any(Zerrors)
    Zerr = 1;
else
    Zerr = 0;
end


if any(Xerrors)
    Xerr = 1;
else
    Xerr = 0;
end


logErr = [Zerr,Xerr];
