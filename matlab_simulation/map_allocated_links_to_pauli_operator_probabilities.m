function ghzPauliOperatorResults = map_allocated_links_to_pauli_operator_probabilities(entangledLinkAllocation, LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, v, N)


xOuterA = entangledLinkAllocation.GHZ.A.x;
zOuterA = entangledLinkAllocation.GHZ.A.z;
xOuterB = entangledLinkAllocation.GHZ.B.x;
zOuterB = entangledLinkAllocation.GHZ.B.z;
xOuterC = entangledLinkAllocation.GHZ.C.x;
zOuterC = entangledLinkAllocation.GHZ.C.z;

numkGHZ = min([numel(xOuterA), numel(zOuterA), numel(xOuterB), numel(zOuterB), numel(xOuterC), numel(zOuterC)]);

xOuterA = xOuterA(1:numkGHZ);
zOuterA = zOuterA(1:numkGHZ);
xOuterB = xOuterB(1:numkGHZ);
zOuterB = zOuterB(1:numkGHZ);
xOuterC = xOuterC(1:numkGHZ);
zOuterC = zOuterC(1:numkGHZ);

maxDistance = max([LA, LB, LC]);
[xInnerA, zInnerA] = inner_leaves_swapping_and_construction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);
[xInnerB, zInnerB] = inner_leaves_swapping_and_construction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);
[xInnerC, zInnerC] = inner_leaves_swapping_and_construction(maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);


pauliTable = ghz_source_pauli_operators();
[numPauliOperators, numQubits] = size(pauliTable);

if numPauliOperators ~= 24 || numQubits ~= 3
    error('ghz_source_pauli_operators must return a 24-by-3 Pauli table.');
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
