clear; clc;
close all;

% symbol size
N = 100;
T = 1e-3;
over = 10;
Ts = T/over;
fs = 1/Ts;
f0 = 2e3;
A = 4;
a = 0.5;
K = 1e3;

% create a new φ(τ)
[phi, phi_t] = srrc_pulse(T, over, A, a);

SNR_v=-2:2:16;
P_SNR = zeros(2, length(SNR_v));

for i=1:length(SNR_v)
    bit_error = 0;
    symb_error = 0;
    for k=1:K
        %---------------------DATA INPUT---------------------%
        % create 3*N matrix of equaly random bits
        bit_seq = randi([0 1],N,3);
        % PSK encoding
        symbols = bits_to_PSK(bit_seq);

        % combine them
        [X_I, X_Q, X_t, s] = modulate_PSK(symbols, Ts, over, phi, phi_t);

        %---------------------MODULATION---------------------%
        % Modulate them with carrier wave/frequency and plot them
        X_I_cos = X_I .* 2.*cos(2*pi*f0.*X_t);
        X_Q_sin = X_Q .* -2.*sin(2*pi*f0.*X_t);

        %---------------------TRANSMISSION---------------------%
        % Add them to create the final signal
        % This is the Tx signal, channel input
        X_T = X_I_cos + X_Q_sin;

        %---------------------RECEIVING END---------------------%
        % Receive Noisy signal
        snr_db = SNR_v(i);
        var_w = 1/(Ts * 10^(snr_db/10));
        wg_noise = sqrt(var_w) .* randn(1,length(X_t));

        % noised signal
        Y_T = X_T + wg_noise;

        % Decompose
        Y_I_cos = cos(2*pi*f0*X_t) .* Y_T;
        Y_Q_sin = -sin(2*pi*f0*X_t) .* Y_T;

        %---------------------FILTERING---------------------%
        % filter using φ(t)
        Y_I_filter = conv(phi, Y_I_cos)*Ts;
        Y_Q_filter = conv(phi, Y_Q_sin)*Ts;
        Y_t = linspace(phi_t(1) + X_t(1),phi_t(end) + X_t(end), length(Y_I_filter));

        %---------------------SAMPLING---------------------%
        % downsample and tail-cut the convolution near-0 points
        Y_I_downsmpl = downsample(Y_I_filter(Y_t >= 0 & Y_t < s), over);
        Y_Q_downsmpl = downsample(Y_Q_filter(Y_t >= 0 & Y_t < s), over);


        %---------------------RECREATION---------------------%
        % detect symbols and decode bianry information
        [symbols_dec, bit_seq_dec] = detect_PSK_8([Y_I_downsmpl;Y_Q_downsmpl]);


        %---------------------ERROR DETECTION---------------------%
        bit_error = bit_error + bit_errors(bit_seq_dec, bit_seq);
        symb_error = symb_error + symbol_errors(symbols_dec, symbols);
    end
    P_SNR(1,i) = bit_error/(K*3*N);
    P_SNR(2,i) = symb_error/(K*N);
end

SNR = 10.^(SNR_v/10);
s_bound = 2*Q(sqrt(2*SNR).*sin(pi/8));
b_bound = s_bound/3;

figure;
semilogy(SNR_v, P_SNR(2,:));
title("Logarithmic scale of symbol errors");
xlabel("SNR_{dB}");
ylabel("Errors (log_{10})");
hold on;
semilogy(SNR_v, s_bound);
hold off;
legend("Experimental", "Theoretical");

figure;
semilogy(SNR_v, P_SNR(1,:));
title("Logarithmic scale of bit errors");
xlabel("SNR_{dB}");
ylabel("Errors (log_{10})");
hold on;
semilogy(SNR_v, b_bound);
hold off;
legend("Experimental", "Theoretical");

