function ghzPauliOperatorResults = map_swapping_results_to_pauli_operator_probabilities_from_lists( ...
    LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, ...
    Aidx, Bidx, Cidx, v, N)

if isempty(Aidx) || isempty(Bidx) || isempty(Cidx)
    ghzPauliOperatorResults = emptyGHZPauliOperatorResults();
    return;
end

Aidx = Aidx(:).';
Bidx = Bidx(:).';
Cidx = Cidx(:).';

Aidx = Aidx(Aidx > 0);
Bidx = Bidx(Bidx > 0);
Cidx = Cidx(Cidx > 0);

if isempty(Aidx) || isempty(Bidx) || isempty(Cidx)
    ghzPauliOperatorResults = emptyGHZPauliOperatorResults();
    return;
end

if any(mod(Aidx, 1) ~= 0) || any(mod(Bidx, 1) ~= 0) || any(mod(Cidx, 1) ~= 0)
    error("Aidx, Bidx, and Cidx must contain positive integer indices.");
end

kAmax = max(Aidx);
kBmax = max(Bidx);
kCmax = max(Cidx);

[xOuterAAll, zOuterAAll] = outer_leaves_swapping_and_construction( ...
    LA, sigGKP, etas, etam, etad, etac, Lcavity, kAmax, v, N);

[xOuterBAll, zOuterBAll] = outer_leaves_swapping_and_construction( ...
    LB, sigGKP, etas, etam, etad, etac, Lcavity, kBmax, v, N);

[xOuterCAll, zOuterCAll] = outer_leaves_swapping_and_construction( ...
    LC, sigGKP, etas, etam, etad, etac, Lcavity, kCmax, v, N);

xOuterA = xOuterAAll(Aidx);
zOuterA = zOuterAAll(Aidx);

xOuterB = xOuterBAll(Bidx);
zOuterB = zOuterBAll(Bidx);

xOuterC = xOuterCAll(Cidx);
zOuterC = zOuterCAll(Cidx);

[xOuterA, zOuterA] = sort_xz_by_total_error(xOuterA, zOuterA);
[xOuterB, zOuterB] = sort_xz_by_total_error(xOuterB, zOuterB);
[xOuterC, zOuterC] = sort_xz_by_total_error(xOuterC, zOuterC);

numkGHZ = min([numel(xOuterA), numel(xOuterB), numel(xOuterC)]);

xOuterA = xOuterA(1:numkGHZ);
zOuterA = zOuterA(1:numkGHZ);

xOuterB = xOuterB(1:numkGHZ);
zOuterB = zOuterB(1:numkGHZ);

xOuterC = xOuterC(1:numkGHZ);
zOuterC = zOuterC(1:numkGHZ);

maxDistance = max([LA, LB, LC]);

[xInnerA, zInnerA] = inner_leaves_swapping_and_construction( ...
    maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);

[xInnerB, zInnerB] = inner_leaves_swapping_and_construction( ...
    maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);

[xInnerC, zInnerC] = inner_leaves_swapping_and_construction( ...
    maxDistance, sigGKP, etas, etam, etad, etac, Lcavity, numkGHZ, v, N);

pauliTable = ghz_source_pauli_operators();

[numPauliOperators, numQubits] = size(pauliTable);

if numPauliOperators ~= 24 || numQubits ~= 3
    error("ghz_source_pauli_operators must return a 24-by-3 Pauli table.");
end

probs = cell(numPauliOperators, 1);

probs{1}  = xOuterA; % III
probs{2}  = zOuterA; % ZII
probs{3}  = xOuterA; % XII
probs{4}  = zOuterA; % III

probs{5}  = xOuterB; % III
probs{6}  = zOuterB; % IZI
probs{7}  = xOuterB; % IXI
probs{8}  = zOuterB; % III

probs{9}  = xOuterC; % III
probs{10} = zOuterC; % IIZ
probs{11} = xOuterC; % IIX
probs{12} = zOuterC; % III

probs{13} = xInnerA; % XII
probs{14} = zInnerA; % III
probs{15} = xInnerA; % III
probs{16} = zInnerA; % ZII

probs{17} = xInnerB; % IXI
probs{18} = zInnerB; % III
probs{19} = xInnerB; % III
probs{20} = zInnerB; % IZI

probs{21} = xInnerC; % IIX
probs{22} = zInnerC; % III
probs{23} = xInnerC; % III
probs{24} = zInnerC; % IIZ

ghzPauliOperatorResults = struct();
ghzPauliOperatorResults.PauliOperators = pauliTable;
ghzPauliOperatorResults.Probs = probs;
ghzPauliOperatorResults.numkGHZ = numkGHZ;

end