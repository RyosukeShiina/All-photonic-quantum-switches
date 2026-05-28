function [vecA, vecB, vecC] = allocation_vectors_from_lists( ...
    kA, kB, kC, Bell_list, GHZ_list, maxKA, maxKB, maxKC)

% Allocation code:
% 0 = unused/padding
% 1 = Bell
% 2 = GHZ

vecA = zeros(maxKA, 1);
vecB = zeros(maxKB, 1);
vecC = zeros(maxKC, 1);

vecA(1:kA) = 0;
vecB(1:kB) = 0;
vecC(1:kC) = 0;

if ~isempty(Bell_list)
    A_bell = Bell_list(1, :);
    B_bell = Bell_list(2, :);

    vecA(A_bell) = 1;
    vecB(B_bell) = 1;
end

if ~isempty(GHZ_list)
    A_ghz = GHZ_list(1, :);
    B_ghz = GHZ_list(2, :);
    C_ghz = GHZ_list(3, :);

    vecA(A_ghz) = 2;
    vecB(B_ghz) = 2;
    vecC(C_ghz) = 2;
end

end