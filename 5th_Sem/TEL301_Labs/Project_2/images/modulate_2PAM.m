function [X_t_t, X_t, dur] = modulate_2PAM(t_phi, phi, N_bits, Ts, over)
    % generate random bit stream
    bit_stream = randi([0 1], 1 , N_bits);
    % Symbolize it using 2-PAM
    pamed_stream = bits_to_2PAM(bit_stream);
    % Upsample it
    X_delta = 1/Ts * upsample(pamed_stream,over);
    T_delta = 0:Ts:length(X_delta)*Ts - Ts;
    % plot(T_delta, X_delta);
    % Modulate it with the carrier wave
    X_t_t = T_delta(1) + t_phi(1):Ts:T_delta(end) + t_phi(end);
    X_t = conv(X_delta, phi) .* Ts;
    dur = length(T_delta)*Ts;
end

