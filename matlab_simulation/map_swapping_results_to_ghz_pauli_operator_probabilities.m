function ghzPauliOperatorResults = map_swapping_results_to_ghz_pauli_operator_probabilities(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kC, v, N)



[xOuterA, zOuterA] = OuterSwappingAndConstruction(LA, sigGKP, etas, etam, etad, etac, Lcavity, kA, v, N);
[xOuterB, zOuterB] = OuterSwappingAndConstruction(LB, sigGKP, etas, etam, etad, etac, Lcavity, kB, v, N);
[xOuterC, zOuterC] = OuterSwappingAndConstruction(LC, sigGKP, etas, etam, etad, etac, Lcavity, kC, v, N);


numkGHZ = min([kA, kB, kC]);
xOuterA = xOuterA(1:numkGHZ);
zOuterA = zOuterA(1:numkGHZ);
xOuterB = xOuterB(1:numkGHZ);
zOuterB = zOuterB(1:numkGHZ);
xOuterC = xOuterC(1:numkGHZ);
zOuterC = zOuterC(1:numkGHZ);

maxDistance = max([LA, LB, LC]);
[xInnerA, zInnerA] = InnerSwappingAndConstruction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);
[xInnerB, zInnerB] = InnerSwappingAndConstruction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);
[xInnerC, zInnerC] = InnerSwappingAndConstruction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);


pauliTable = sourcePaulis();
numPauliOperators = size(pauliTable, 1);

if numPauliOperators ~= 24
    error('This function assumes 24 Pauli-operator error types.');
end

probs = cell(numPauliOperators, 1);

probs{1}  = xOuterA; %III
probs{2}  = zOuterA; %ZII
probs{3}  = xOuterA; %XII
probs{4}  = zOuterA; %III

probs{5}  = xOuterB; %III
probs{6}  = zOuterB; %IZI
probs{7}  = xOuterB; %IXI
probs{8}  = zOuterB; %III

probs{9}  = xOuterC; %III
probs{10} = zOuterC; %IIZ
probs{11} = xOuterC; %IIX
probs{12} = zOuterC; %III

probs{13} = xInnerA; %XII
probs{14} = zInnerA; %III
probs{15} = xInnerA; %III
probs{16} = zInnerA; %ZII

probs{17} = xInnerB; %IXI
probs{18} = zInnerB; %III
probs{19} = xInnerB; %III
probs{20} = zInnerB; %IZI

probs{21} = xInnerC; %IIX
probs{22} = zInnerC; %III
probs{23} = xInnerC; %III
probs{24} = zInnerC; %IIZ


ghzPauliOperatorResults = struct();
ghzPauliOperatorResults.PauliOperators = pauliTable;
ghzPauliOperatorResults.Probs = probs;
ghzPauliOperatorResults.numkGHZ = numkGHZ;

end
