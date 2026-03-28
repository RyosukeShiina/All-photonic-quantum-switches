function out = R_SecretKeyRate_per(L, Ltot, Zerr, Xerr)

%This function calculates the total end-to-end secret-key/entanglement rate for the scenario when
%there is no inner leaf syndrome information. This can also describe the scenario,
%where the inner leafs are perfect.

%Inputs:

%L -                repeater spacing
%Ltot -             distance over which we want to calculate the key
%Zerr, Xerr -       probability of Z-flip and X-flip over a single
%                   elementary link.

%Outputs

%out -              secret key/entanglement per optical mode

% The maximum flip probability is 0.5, as if the flip probabilities were larger, we would
% just flip all the corresponding bits.
for i = 1:numel(Zerr)
    if Zerr(i) > 0.5
        Zerr(i) = 0.5;
    end

    if Xerr(i) > 0.5
        Xerr(i) = 0.5;
    end
end

%Now calculate the end-to-end errors for all k multiplexed links.

NoLinks = Ltot/L;

QerrZArray = (1 - (1 - 2 * Zerr(:,1)).^NoLinks)/2;
QerrXArray = (1 - (1 - 2 * Xerr(:,1)).^NoLinks)/2;

%Now calculate the key/entanglement rate.
out = R_SecretKey6State_per(QerrZArray, QerrXArray);
