function ghzPauliOperatorResults = map_outer_errors_to_ghz_pauli_probabilities( ...
    xOuterA, zOuterA, xOuterB, zOuterB, xOuterC, zOuterC, params)

% I map already-assigned GHZ outer-leaf errors into the 24-source GHZ
% Pauli-operator probability structure.
%
% This function is for the shared-pooling switch model.
% The outer leaves are generated and sorted before this function is called.
%
% Here I only:
%   1. trim A, B, and C to the common number of GHZ modes,
%   2. generate GHZ inner-leaf errors using max(LA, LB, LC),
%   3. build the same 24-entry Pauli-source structure used by the old code.

if isempty(xOuterA) || isempty(zOuterA) || ...
        isempty(xOuterB) || isempty(zOuterB) || ...
        isempty(xOuterC) || isempty(zOuterC)

    ghzPauliOperatorResults = emptyGHZPauliOperatorResults();
    return;
end

xOuterA = xOuterA(:);
zOuterA = zOuterA(:);

xOuterB = xOuterB(:);
zOuterB = zOuterB(:);

xOuterC = xOuterC(:);
zOuterC = zOuterC(:);

numkGHZ = min([ ...
    numel(xOuterA), numel(zOuterA), ...
    numel(xOuterB), numel(zOuterB), ...
    numel(xOuterC), numel(zOuterC)]);

if numkGHZ == 0
    ghzPauliOperatorResults = emptyGHZPauliOperatorResults();
    return;
end

% I keep the already-sorted, already-assigned GHZ resources.
xOuterA = xOuterA(1:numkGHZ);
zOuterA = zOuterA(1:numkGHZ);

xOuterB = xOuterB(1:numkGHZ);
zOuterB = zOuterB(1:numkGHZ);

xOuterC = xOuterC(1:numkGHZ);
zOuterC = zOuterC(1:numkGHZ);

% I use the GHZ waiting distance.
% GHZ has to wait for the farthest user among A, B, and C.
LGHZ = max([params.LA, params.LB, params.LC]);

[xInnerA, zInnerA] = inner_leaves_swapping_and_construction( ...
    LGHZ, ...
    params.sigGKP, params.etas, params.etam, ...
    params.etad, params.etac, params.Lcavity, ...
    numkGHZ, params.v, params.N);

[xInnerB, zInnerB] = inner_leaves_swapping_and_construction( ...
    LGHZ, ...
    params.sigGKP, params.etas, params.etam, ...
    params.etad, params.etac, params.Lcavity, ...
    numkGHZ, params.v, params.N);

[xInnerC, zInnerC] = inner_leaves_swapping_and_construction( ...
    LGHZ, ...
    params.sigGKP, params.etas, params.etam, ...
    params.etad, params.etac, params.Lcavity, ...
    numkGHZ, params.v, params.N);

pauliTable = ghz_source_pauli_operators();

[numPauliOperators, numQubits] = size(pauliTable);

if numPauliOperators ~= 24 || numQubits ~= 3
    error("ghz_source_pauli_operators must return a 24-by-3 Pauli table.");
end

probs = cell(numPauliOperators, 1);

% I use the same 24-source assignment as the old GHZ code.
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