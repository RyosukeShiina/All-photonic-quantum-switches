function out = Switch_SecretKeyRate_total(Zerr_Alice, Xerr_Alice, Zerr_Bob, Xerr_Bob)

%This function calculates the total end-to-end secret-key/entanglement rate for the scenario when
%there is no inner leaf syndrome information. This can also describe the scenario,
%where the inner leafs are perfect.

%Inputs:

%Zerr, Xerr -       probability of Z-flip and X-flip over a single
%                   elementary link.

%Outputs
%out -              secret key/entanglement per optical mode

% The maximum flip probability is 0.5, as if the flip probabilities were larger, we would
% just flip all the corresponding bits.

for i = 1:numel(Zerr_Alice)
    if Zerr_Alice(i) > 0.5
        Zerr_Alice(i) = 0.5;
    end

    if Xerr_Alice(i) > 0.5
        Xerr_Alice(i) = 0.5;
    end
end

for i = 1:numel(Zerr_Bob)
    if Zerr_Bob(i) > 0.5
        Zerr_Bob(i) = 0.5;
    end

    if Xerr_Bob(i) > 0.5
        Xerr_Bob(i) = 0.5;
    end
end


%Now calculate the end-to-end errors for all k multiplexed links.


QerrZArray = Zerr_Alice(:,1) .* (1-Zerr_Bob(:,1)) + (1-Zerr_Alice(:,1)) .* Zerr_Bob(:,1);
QerrXArray = Xerr_Alice(:,1) .* (1-Xerr_Bob(:,1)) + (1-Xerr_Alice(:,1)) .* Xerr_Bob(:,1);


%Now calculate the key/entanglement rate.
out = Switch_SecretKey6State_total(QerrZArray, QerrXArray);
