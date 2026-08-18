function rateGHZ = GHZRate_end_node(LA, LB, LC, sigGKP, etas, etam, etad, etac, Lcavity, kA, kB, kB2, kC, v, N)


if kA == 0 || kB == 0 || kB2 == 0 || kC == 0
    rateGHZ = 0;
    return;
end

sigmasPostselect = zeros(1, 11);
sigmasPostselect(1) = sqrt(3*sigGKP^2 + (1-etad)/etad);
sigmasPostselect(2) = sqrt(3*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(3) = sqrt(3*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(4) = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
sigmasPostselect(5) = sqrt(2*sigGKP^2 + (1-etas^2*etad)/(etas^2*etad));
sigmasPostselect(6) = sqrt(3*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(7) = sqrt(3*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(8) = sqrt(2*sigGKP^2 + 1 - etas^2 + (1-etad)/etad);
sigmasPostselect(9) = sqrt(2*sigGKP^2 + 1 - etas^3 + (1-etad)/etad);
sigmasPostselect(10) = sqrt(3*sigGKP^2 + 1 - etas + (1-etad)/etad);
sigmasPostselect(11) = sqrt(2*sigGKP^2 + 1 - etas + (1-etad)/etad);

sigmasNoPost = sqrt(2*sigGKP^2 + (1-etas*etad)/(etas*etad));
vVec = R_Find_v(sigmasPostselect, R_LogErrAfterPost(sigmasPostselect(7),v), v+0.1);

ErrProbVec = zeros(1,12);
pVec = zeros(1,12);
for i = 1:11
    [ErrProbVec(i), pVec(i)] = R_LogErrAfterPost(sigmasPostselect(i), vVec(i));
end
[ErrProbVec(12), pVec(12)] = R_LogErrAfterPost(sigmasNoPost, 0);



% If the A-, B-, B2-, and C-side outer leaves have identical parameters,
% they are statistically identical. Since we only use averaged logical
% error probabilities, we estimate them once and reuse the same probability
% estimates for all four sides. This does not copy individual Monte Carlo
% error realizations.
tol = 1e-12;

sameDistance = abs(LA - LB) < tol && abs(LB - LC) < tol;
sameK = (kA == kB) && (kB == kB2) && (kB2 == kC);

if sameDistance && sameK
    ZerrOuterA = zeros(kA, 1);
    XerrOuterA = zeros(kA, 1);
    PerrorQA = zeros(1, kA);
    PerrorPA = zeros(1, kA);

    parfor i = 1:N
        [logErrOuter, PerrorQ, PerrorP] = ...
            UW3_OuterLeaves_end_node( ...
                LA, sigGKP, etas, etad, etac, kA, ErrProbVec);

        ZerrOuterA = ZerrOuterA + logErrOuter(:, 1);
        XerrOuterA = XerrOuterA + logErrOuter(:, 2);
        PerrorQA = PerrorQA + PerrorQ;
        PerrorPA = PerrorPA + PerrorP;
    end

    ZerrOuterA = ZerrOuterA / N;
    XerrOuterA = XerrOuterA / N;
    PerrorQA = PerrorQA / N;
    PerrorPA = PerrorPA / N;

    % Reuse the same outer-leaf error probabilities for the B side.
    ZerrOuterB = ZerrOuterA;
    XerrOuterB = XerrOuterA;
    PerrorQB = PerrorQA;
    PerrorPB = PerrorPA;

    % Reuse the same outer-leaf error probabilities for the B2 side.
    ZerrOuterB2 = ZerrOuterA;
    XerrOuterB2 = XerrOuterA;
    PerrorQB2 = PerrorQA;
    PerrorPB2 = PerrorPA;

    % Reuse the same outer-leaf error probabilities for the C side.
    ZerrOuterC = ZerrOuterA;
    XerrOuterC = XerrOuterA;
    PerrorQC = PerrorQA;
    PerrorPC = PerrorPA;

else
    ZerrOuterA = zeros(kA, 1);
    XerrOuterA = zeros(kA, 1);
    PerrorQA = zeros(1, kA);
    PerrorPA = zeros(1, kA);

    ZerrOuterB = zeros(kB, 1);
    XerrOuterB = zeros(kB, 1);
    PerrorQB = zeros(1, kB);
    PerrorPB = zeros(1, kB);

    ZerrOuterB2 = zeros(kB2, 1);
    XerrOuterB2 = zeros(kB2, 1);
    PerrorQB2 = zeros(1, kB2);
    PerrorPB2 = zeros(1, kB2);

    ZerrOuterC = zeros(kC, 1);
    XerrOuterC = zeros(kC, 1);
    PerrorQC = zeros(1, kC);
    PerrorPC = zeros(1, kC);

    parfor i = 1:N
        [logErrOuter, PerrorQ, PerrorP] = ...
            UW3_OuterLeaves_end_node( ...
                LA, sigGKP, etas, etad, etac, kA, ErrProbVec);

        ZerrOuterA = ZerrOuterA + logErrOuter(:, 1);
        XerrOuterA = XerrOuterA + logErrOuter(:, 2);
        PerrorQA = PerrorQA + PerrorQ;
        PerrorPA = PerrorPA + PerrorP;
    end

    ZerrOuterA = ZerrOuterA / N;
    XerrOuterA = XerrOuterA / N;
    PerrorQA = PerrorQA / N;
    PerrorPA = PerrorPA / N;


    parfor i = 1:N
        [logErrOuter, PerrorQ, PerrorP] = ...
            UW3_OuterLeaves_end_node( ...
                LB, sigGKP, etas, etad, etac, kB, ErrProbVec);

        ZerrOuterB = ZerrOuterB + logErrOuter(:, 1);
        XerrOuterB = XerrOuterB + logErrOuter(:, 2);
        PerrorQB = PerrorQB + PerrorQ;
        PerrorPB = PerrorPB + PerrorP;
    end

    ZerrOuterB = ZerrOuterB / N;
    XerrOuterB = XerrOuterB / N;
    PerrorQB = PerrorQB / N;
    PerrorPB = PerrorPB / N;


    parfor i = 1:N
        [logErrOuter, PerrorQ, PerrorP] = ...
            UW3_OuterLeaves_end_node( ...
                LB, sigGKP, etas, etad, etac, kB2, ErrProbVec);

        ZerrOuterB2 = ZerrOuterB2 + logErrOuter(:, 1);
        XerrOuterB2 = XerrOuterB2 + logErrOuter(:, 2);
        PerrorQB2 = PerrorQB2 + PerrorQ;
        PerrorPB2 = PerrorPB2 + PerrorP;
    end

    ZerrOuterB2 = ZerrOuterB2 / N;
    XerrOuterB2 = XerrOuterB2 / N;
    PerrorQB2 = PerrorQB2 / N;
    PerrorPB2 = PerrorPB2 / N;


    parfor i = 1:N
        [logErrOuter, PerrorQ, PerrorP] = ...
            UW3_OuterLeaves_end_node( ...
                LC, sigGKP, etas, etad, etac, kC, ErrProbVec);

        ZerrOuterC = ZerrOuterC + logErrOuter(:, 1);
        XerrOuterC = XerrOuterC + logErrOuter(:, 2);
        PerrorQC = PerrorQC + PerrorQ;
        PerrorPC = PerrorPC + PerrorP;
    end

    ZerrOuterC = ZerrOuterC / N;
    XerrOuterC = XerrOuterC / N;
    PerrorQC = PerrorQC / N;
    PerrorPC = PerrorPC / N;

end


% ZerrOuterA, XerrOuterB, ZerrOuterB2, and XerrOuterC are already sorted in descending order of quality by UW3_OuterLeaves. Therefore, we keep the first min(kA, kB) and min(kB2, kC) entries.

numMatchedOuterLeaves = min(numel(ZerrOuterA), numel(ZerrOuterB));
numMatchedOuterLeaves2 = min(numel(ZerrOuterB2), numel(ZerrOuterC));

ZerrOuterA = ZerrOuterA(1:numMatchedOuterLeaves);
XerrOuterA = XerrOuterA(1:numMatchedOuterLeaves);
ZerrOuterB = ZerrOuterB(1:numMatchedOuterLeaves);
XerrOuterB = XerrOuterB(1:numMatchedOuterLeaves);
PerrorQA = PerrorQA(1:numMatchedOuterLeaves);
PerrorPA = PerrorPA(1:numMatchedOuterLeaves);
PerrorQB = PerrorQB(1:numMatchedOuterLeaves);
PerrorPB = PerrorPB(1:numMatchedOuterLeaves);

ZerrOuterB2 = ZerrOuterB2(1:numMatchedOuterLeaves2);
XerrOuterB2 = XerrOuterB2(1:numMatchedOuterLeaves2);
ZerrOuterC = ZerrOuterC(1:numMatchedOuterLeaves2);
XerrOuterC = XerrOuterC(1:numMatchedOuterLeaves2);
PerrorQB2 = PerrorQB2(1:numMatchedOuterLeaves2);
PerrorPB2 = PerrorPB2(1:numMatchedOuterLeaves2);
PerrorQC = PerrorQC(1:numMatchedOuterLeaves2);
PerrorPC = PerrorPC(1:numMatchedOuterLeaves2);







%Inner-leaves swapping at a quantum switch station
LAB = max(LA, LB);
LBC = max(LB, LC);

ZerrInnerAB = zeros(numMatchedOuterLeaves, 1);
XerrInnerAB = zeros(numMatchedOuterLeaves, 1);
ZerrInnerBC = zeros(numMatchedOuterLeaves2, 1);
XerrInnerBC = zeros(numMatchedOuterLeaves2, 1);






ZerrOuterA0 = ZerrOuterA;
XerrOuterA0 = XerrOuterA;
ZerrOuterB0 = ZerrOuterB;
XerrOuterB0 = XerrOuterB;

ZerrOuterA = zeros(numMatchedOuterLeaves, 1);
XerrOuterA = zeros(numMatchedOuterLeaves, 1);
ZerrOuterB = zeros(numMatchedOuterLeaves, 1);
XerrOuterB = zeros(numMatchedOuterLeaves, 1);

parfor i = 1:N
    [logErrInner, IndDesc] = UW3_InnerLeaves_end_node(LAB, sigGKP, etas, etam, etad, etac, Lcavity, numMatchedOuterLeaves, ErrProbVec, PerrorQA, PerrorPA, PerrorQB, PerrorPB);
    ZerrInnerAB = ZerrInnerAB + logErrInner(:, 1);
    XerrInnerAB = XerrInnerAB + logErrInner(:, 2);

    ZerrOuterA = ZerrOuterA + ZerrOuterA0(IndDesc);
    XerrOuterA = XerrOuterA + XerrOuterA0(IndDesc);

    ZerrOuterB = ZerrOuterB + ZerrOuterB0(IndDesc);
    XerrOuterB = XerrOuterB + XerrOuterB0(IndDesc);
end

ZerrInnerAB = ZerrInnerAB / N;
XerrInnerAB = XerrInnerAB / N;

ZerrOuterA = ZerrOuterA / N;
XerrOuterA = XerrOuterA / N;
ZerrOuterB = ZerrOuterB / N;
XerrOuterB = XerrOuterB / N;







ZerrOuterB20 = ZerrOuterB2;
XerrOuterB20 = XerrOuterB2;
ZerrOuterC0 = ZerrOuterC;
XerrOuterC0 = XerrOuterC;

ZerrOuterB2 = zeros(numMatchedOuterLeaves2, 1);
XerrOuterB2 = zeros(numMatchedOuterLeaves2, 1);
ZerrOuterC = zeros(numMatchedOuterLeaves2, 1);
XerrOuterC = zeros(numMatchedOuterLeaves2, 1);

parfor i = 1:N
    [logErrInner, IndDesc] = UW3_InnerLeaves_end_node(LBC, sigGKP, etas, etam, etad, etac, Lcavity, numMatchedOuterLeaves2, ErrProbVec, PerrorQB2, PerrorPB2, PerrorQC, PerrorPC);
    ZerrInnerBC = ZerrInnerBC + logErrInner(:, 1);
    XerrInnerBC = XerrInnerBC + logErrInner(:, 2);

    ZerrOuterB2 = ZerrOuterB2 + ZerrOuterB20(IndDesc);
    XerrOuterB2 = XerrOuterB2 + XerrOuterB20(IndDesc);

    ZerrOuterC = ZerrOuterC + ZerrOuterC0(IndDesc);
    XerrOuterC = XerrOuterC + XerrOuterC0(IndDesc);
end

ZerrInnerBC = ZerrInnerBC / N;
XerrInnerBC = XerrInnerBC / N;

ZerrOuterB2 = ZerrOuterB2 / N;
XerrOuterB2 = XerrOuterB2 / N;
ZerrOuterC = ZerrOuterC / N;
XerrOuterC = XerrOuterC / N;







%End-node
L = min([LA, LB, LC]);
k = min(numMatchedOuterLeaves, numMatchedOuterLeaves2);

ZerrEndNode = 0;
XerrEndNode = 0;

parfor i = 1:N
    logErrEndNode = UW3_end_node_swapping(L, sigGKP, etas, etam, etad, etac, Lcavity, k, ErrProbVec);
    ZerrEndNode = ZerrEndNode + logErrEndNode(:, 1);
    XerrEndNode = XerrEndNode + logErrEndNode(:, 2);
end

ZerrEndNode = ZerrEndNode/N;
XerrEndNode = XerrEndNode/N;
ZerrEndNode = ZerrEndNode*ones(k,1);
XerrEndNode = XerrEndNode*ones(k,1);







ZerrOuterA  = ZerrOuterA(1:k);
XerrOuterA  = XerrOuterA(1:k);
ZerrOuterB  = ZerrOuterB(1:k);
XerrOuterB  = XerrOuterB(1:k);
ZerrOuterB2 = ZerrOuterB2(1:k);
XerrOuterB2 = XerrOuterB2(1:k);
ZerrOuterC  = ZerrOuterC(1:k);
XerrOuterC  = XerrOuterC(1:k);
ZerrInnerAB = ZerrInnerAB(1:k);
XerrInnerAB = XerrInnerAB(1:k);
ZerrInnerBC = ZerrInnerBC(1:k);
XerrInnerBC = XerrInnerBC(1:k);


ghzPauliOperatorProbabilities = ...
    map_swapping_results_to_pauli_operator_probabilities_end_node( ...
        XerrOuterA, ZerrOuterA, ...
        XerrOuterB, ZerrOuterB, ...
        XerrOuterB2, ZerrOuterB2, ...
        XerrOuterC, ZerrOuterC, ...
        XerrInnerAB, ZerrInnerAB, ...
        XerrInnerBC, ZerrInnerBC, ...
        XerrEndNode, ZerrEndNode);

pauliTable = ghzPauliOperatorProbabilities.PauliOperators;
numPaulis = size(pauliTable, 1);
numkGHZ = ghzPauliOperatorProbabilities.numkGHZ;

rateList = zeros(numkGHZ, 1);

for ell = 1:numkGHZ

    singleResultsEll = struct();
    singleResultsEll.PauliOperators = pauliTable;
    singleResultsEll.Probs = cell(numPaulis, 1);

    for sourceIndex = 1:numPaulis
        probVector = ...
            ghzPauliOperatorProbabilities.Probs{sourceIndex};

        singleResultsEll.Probs{sourceIndex} = ...
            probVector(ell);
    end

    combinedPauliOperatorResults = ...
        map_pauli_operator_probs_to_combined_operator_probs_end_node( ...
            singleResultsEll);

    [ghz_basis_lambdas, ~, ~, Qab] = ...
        map_combined_pauli_operator_probs_to_ghz_basis_lambdas_and_Qs( ...
            combinedPauliOperatorResults);

    rateList(ell) = ...
        map_ghz_basis_lambdas_to_secret_key_rate( ...
            ghz_basis_lambdas, Qab);
end

rateGHZ = sum(rateList);

end





function pOdd = odd_parity_error_probability(P)
% Input:
%   P : k-by-m matrix.
%       Each row corresponds to one matched GHZ attempt.
%       Each column corresponds to one independent error source.
%
% Output:
%   pOdd : k-by-1 vector.
%       Odd-parity error probability for each row.

    pOdd = 0.5 * (1 - prod(1 - 2*P, 2));
end
