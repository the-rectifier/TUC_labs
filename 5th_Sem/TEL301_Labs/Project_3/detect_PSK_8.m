function [symbols, bit_seq_est] = detect_PSK_8(Y)
% for each symbol (I,Q),
% find its angle in [0,2π)
% convert to degrees to check in its neighbour zones
% for each angle estimate the symbol
% decode them
Y = Y.';
N_symbols = length(Y(:,1));
symbols = zeros(N_symbols, 2);

for i=1:N_symbols
    angle = rad2deg(wrapTo2Pi(atan2(Y(i,2),Y(i,1))));
    if((angle >= 0 && angle < 22.5) || (angle <= 360 && angle >= 337.5))
        symbols(i,1) = 1;
        symbols(i,2) = 0;
    elseif(angle >= 22.5 && angle < 67.5)
        symbols(i,1) = sqrt(2)/2;
        symbols(i,2) = sqrt(2)/2;
    elseif(angle >= 67.5 && angle < 112.5)
        symbols(i,1) = 0;
        symbols(i,2) = 1;
    elseif(angle >= 112.5 && angle < 157.5)
        symbols(i,1) = -sqrt(2)/2;
        symbols(i,2) = sqrt(2)/2;
    elseif(angle >= 157.5 && angle < 202.5)
        symbols(i,1) = -1;
        symbols(i,2) = 0;
    elseif(angle >= 202.5 && angle < 247.5)
        symbols(i,1) = -sqrt(2)/2;
        symbols(i,2) = -sqrt(2)/2;
    elseif(angle >= 247.5 && angle < 292.5)
        symbols(i,1) = 0;
        symbols(i,2) = -1;
    elseif(angle >= 292.5 && angle < 337.5)
        symbols(i,1) = sqrt(2)/2;
        symbols(i,2) = -sqrt(2)/2;
    end
end 
bit_seq_est = decode(symbols);
end