function [X_I, X_Q, T_conv, s] = modulate_PSK(symbols, Ts, over, phi, phi_t)
%
% Upsample X_I and X_Q, 
% Create a delta train of the upsampled sequences
% filter them through φ(t)
% Return the resulting signals and their lengths(same)

    x_I = symbols(:,1).';
    x_Q = symbols(:,2).';

    x_I_delta = 1/Ts * upsample(x_I,over);
    x_Q_delta = 1/Ts * upsample(x_Q, over);

    T_delta = 0:Ts:length(x_I_delta)*Ts - Ts;
    T_conv = (phi_t(1) + T_delta(1):Ts:phi_t(end) + T_delta(end));

    X_I = conv(phi,x_I_delta)*Ts;
    X_Q = conv(phi,x_Q_delta)*Ts;

    s = length(T_delta)*Ts;
end

