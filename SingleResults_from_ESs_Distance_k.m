function SingleResults = SingleResults_from_ESs_Distance_k(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)

%k=3

%SingleResults = SingleResults_from_ESs(3, 2, 3, 0.12, 0.995, 0.999995, 0.9975, 0.99, 2, 3, 0.3, 1000)

%1<rB<rC

LL = max([LA, LB, LC]); %Longest L

Sk = min([kA, kB, kC]); %Shortest k

[Xes1, Zes1] = OuterSwappingAndConstruction(LA, sigGKP, etas, etam, etad, etac, Lcavity, kA, v, N);
[Xes2, Zes2] = OuterSwappingAndConstruction(LB, sigGKP, etas, etam, etad, etac, Lcavity, kB, v, N);
[Xes3, Zes3] = OuterSwappingAndConstruction(LC, sigGKP, etas, etam, etad, etac, Lcavity, kC, v, N);

Xes1_new = Xes1(1:Sk);
Zes1_new = Zes1(1:Sk);

Xes2_new = Xes2(1:Sk);
Zes2_new = Zes2(1:Sk);

Xes3_new = Xes3(1:Sk);
Zes3_new = Zes3(1:Sk);


[Xes4, Zes4] = InnerSwappingAndConstruction(LL, sigGKP, etas, etam, etad, etac, Lcavity, Sk, v, N);
[Xes5, Zes5] = InnerSwappingAndConstruction(LL, sigGKP, etas, etam, etad, etac, Lcavity, Sk, v, N);
[Xes6, Zes6] = InnerSwappingAndConstruction(LL, sigGKP, etas, etam, etad, etac, Lcavity, Sk, v, N);


PauliTable = sourcePaulis();
Ns = size(PauliTable, 1);
if Ns ~= 24
   error('This function assumes Ns = 24 (24 error types).');
end

probs = cell(Ns,1);

probs{1}  = Xes1; %
probs{2}  = Zes1;
probs{3}  = Xes1;
probs{4}  = Zes1; %

probs{5}  = Xes2; %
probs{6}  = Zes2;
probs{7}  = Xes2;
probs{8}  = Zes2; %

probs{9}  = Xes3; %
probs{10}  = Zes3;
probs{11}  = Xes3;
probs{12}  = Zes3; %

probs{13}  = Xes4;
probs{14}  = Zes4; %
probs{15}  = Xes4; %
probs{16}  = Zes4;

probs{17}  = Xes5;
probs{18}  = Zes5; %
probs{19}  = Xes5; %
probs{20}  = Zes5;

probs{21}  = Xes6;
probs{22}  = Zes6; %
probs{23}  = Xes6; %
probs{24}  = Zes6;


SingleResults = struct();
SingleResults.Probs = probs;

end
