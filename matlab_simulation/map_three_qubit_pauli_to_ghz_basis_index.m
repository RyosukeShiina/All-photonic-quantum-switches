function ghzBasisIndex = map_three_qubit_pauli_to_ghz_basis_index(pauli1, pauli2, pauli3)

%Maps a three-qubit Pauli operator to one of the eight GHZ-basis indices.
%
%Convention:
%   ghzBasisIndex = 1  -> lambda_0^+
%   ghzBasisIndex = 2  -> lambda_0^-
%   ghzBasisIndex = 3  -> lambda_1^+
%   ghzBasisIndex = 4  -> lambda_1^-
%   ghzBasisIndex = 5  -> lambda_2^+
%   ghzBasisIndex = 6  -> lambda_2^-
%   ghzBasisIndex = 7  -> lambda_3^+
%   ghzBasisIndex = 8  -> lambda_3^-
%
%Rule:
%   X and Y contribute bit flips.
%   Z and Y contribute phase flips.
%
%The bit-flip pattern determines the GHZ index:
%   000 or 111 -> GHZ index 0
%   100 or 011 -> GHZ index 1
%   010 or 101 -> GHZ index 2
%   001 or 110 -> GHZ index 3
%
%The parity of phase flips determines the sign:
%   even phase-flip parity -> +
%   odd phase-flip parity  -> -

paulis = [pauli1, pauli2, pauli3];

%X-type component: X and Y flip computational-basis bits.
bitFlipPattern = ismember(paulis, ["X", "Y"]);

%Z-type component: Z and Y contribute phase flips.
phaseFlipPattern = ismember(paulis, ["Z", "Y"]);

isMinus = mod(sum(phaseFlipPattern), 2);

if isequal(bitFlipPattern, [false false false]) || isequal(bitFlipPattern, [true  true  true])
    ghzIndex = 0;

elseif isequal(bitFlipPattern, [true  false false]) || isequal(bitFlipPattern, [false true  true])
    ghzIndex = 1;

elseif isequal(bitFlipPattern, [false true  false]) || isequal(bitFlipPattern, [true  false true])
    ghzIndex = 2;

elseif isequal(bitFlipPattern, [false false true]) || isequal(bitFlipPattern, [true  true  false])
    ghzIndex = 3;

else
    error('Unexpected bit-flip pattern.');
end

ghzBasisIndex = 2*ghzIndex + 1 + isMinus;

end
