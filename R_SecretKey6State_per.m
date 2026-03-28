function out = R_SecretKey6State_per(QerrZ, QerrX)

%This function calculates secret-key/entanglement rate per optical mode for the
%multiplexed architecture for which all k links are used. The QKD protocol considered is
%the maximum of the six-state protocol supplemented with Advantage Distillation of
%IEEE Trans. Inform. Theory 49, 457 (2003) and one-way six-state protocol. The corresponding entanglement
%distillation protocol is the maximum of DEJMPS followed by one-way hashing
%and just one-way hashing. The basis used for key generation is the Y-basis which
%corresponds to distillation protocol where the pre-rotations in DEJMPS lead to the measurement of the Y \otimes Y stabiliser.
%This is the optimal configuration for our scanario with CSS codes.

%Inputs:

%QerrZ, QerrX -     probability of Pauli Z and X flip over the whole repeater
%                   chain for k multiplexed levels (arrays of dimension k
%                   by 1)

%Outputs

%out -              secret key per optical mode

%Extract independent probabilities X, Y, Z
qZ = QerrZ .* (1 - QerrX);
qX = QerrX .* (1 - QerrZ);
qY = QerrZ .* QerrX;


%QBER
% Flip in each basis generates errors in the other 2 bases.
% The maximum flip probability is 0.5, as if the flip probabilities were larger, we would
% just flip all the corresponding bits.

eX = min(qZ + qY, 0.5) ;
eZ = min(qX + qY, 0.5) ;
eY = min(qZ + qX, 0.5) ;

% Bell diagonal coeffs and AD with key in Y basis
% Note that here we define the lambdas for Bell diagonal states defined in
% Y-basis (i.e. the QBERs are permuted) but we leave the expression for the
% secret-key fraction the same as in Z-basis. In the paper on the other hand 
% we use standard definition of lambdas for Bell diagonal states defined in
% Z-basis, but we modify the formula for the secret-key fraction.

lambda00 = 1-(eX + eY + eZ)/2;
lambda01 = (eX + eZ - eY)/2;
lambda10 = (-eX + eY + eZ)/2;
lambda11 = (eX - eZ + eY)/2;

Lambdas = [lambda00, lambda01, lambda10, lambda11];

PX0 = (lambda00 +lambda01).^2 + (lambda10 + lambda11).^2;
PX1 = 2 * (lambda00 +lambda01) .* (lambda10 + lambda11);

lambda00prime = (lambda00.^2 + lambda01.^2)./PX0;
lambda01prime = (2*lambda00 .* lambda01)./PX0;
lambda10prime = (lambda10.^2 + lambda11.^2)./PX0;
lambda11prime = (2 * lambda10 .* lambda11)./PX0;

Lambdasprime = [lambda00prime, lambda01prime, lambda10prime, lambda11prime];

for i = 1:size(Lambdas,1) 
    %One-way six-state
    out1(i,1) = 1 - R_ShannonEnt(Lambdas(i,:));
    %AD
    out2(i,1) = (PX0(i)/2) * (1 - R_ShannonEnt(Lambdasprime(i,:)));
end
%The total secret key/entanglement per mode is the sum of the rate from all
%the k modes normalised by k. The rate in each mode is the maximum of the
%one-way six state, six-state with AD and 0.
out = max([out1,out2,zeros(size(Lambdas,1),1)],[],2);


out = sum(out)/size(Lambdas,1);
