clear; clc;
close all;

% symbol size
N = 100;
% FFT samples
N_FFT = 2048;
T = 1e-3;
over = 10;
Ts = T/over;
fs = 1/Ts;
f0 = 2e3;
A = 4;
a = 0.5;
f_axis = -fs/2:fs/N_FFT:fs/2-fs/N_FFT;

%---------------------DATA INPUT---------------------%
% create 3*N matrix of equally probable bits
bit_seq = randi([0 1],N,3);
% PSK encoding
symbols = bits_to_PSK(bit_seq);
% scatter the weak, no not the Syndra ability
scatterplot(symbols(:,1)+1i*symbols(:,2));

% create a new φ(τ)
[phi, phi_t] = srrc_pulse(T, over, A, a);

% combine them
[X_I, X_Q, X_t, s] = modulate_PSK(symbols, Ts, over, phi, phi_t);


% plot resulting signals
figure;
subplot(2,1,1);
plot(X_t, X_I);
title("X_I(t) filtered w/ φ(t)");
ylabel("Amplitude");
xlabel("Time(s)");
subplot(2,1,2);
plot(X_t, X_Q);
title("X_Q(t) filtered w/ φ(t)");
ylabel("Amplitude");
xlabel("Time(s)");

% And their periodograms as well

P_X_I = abs(fftshift(fft(X_I, N_FFT)*Ts)).^2/s;
P_X_Q = abs(fftshift(fft(X_Q, N_FFT)*Ts)).^2/s;

figure;
subplot(2,1,1);
semilogy(f_axis, P_X_I);
title("Periodogram X_I(t) filtered w/ φ(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");
subplot(2,1,2);
semilogy(f_axis, P_X_Q);
title("Periodogram X_Q(t) filtered w/ φ(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");

%---------------------MODULATION---------------------%
% Modulate them with carrier wave/frequency and plot them
X_I_cos = X_I .* 2.*cos(2*pi*f0.*X_t);
X_Q_sin = X_Q .* -2.*sin(2*pi*f0.*X_t);
figure;
subplot(2,1,1);
plot(X_t, X_I_cos);
title("Modulated X_I(t)");
ylabel("Amplitude");
xlabel("Time(s)");
subplot(2,1,2);
plot(X_t, X_Q_sin);
title("Modulated X_Q(t)");
ylabel("Amplitude");
xlabel("Time(s)");

P_X_I_cos = abs(fftshift(fft(X_I_cos, N_FFT)*Ts)).^2/s;
P_X_Q_sin = abs(fftshift(fft(X_Q_sin, N_FFT)*Ts)).^2/s;

figure;
subplot(2,1,1);
semilogy(f_axis, P_X_I_cos);
title("Periodogram carrier X_I(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");
subplot(2,1,2);
semilogy(f_axis, P_X_Q_sin);
title("Periodogram carrier X_Q(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");

%---------------------TRANSMISSION---------------------%
% Add them to create the final signal
% This is the Tx signal, channel input

X_T = X_I_cos + X_Q_sin;
P_X_T = abs(fftshift(fft(X_T, N_FFT)*Ts)).^2/s;
figure;
subplot(2,1,1);
plot(X_t, X_T);
title("Tx Signal X(t)");
ylabel("Amplitude");
xlabel("Time(s)");
subplot(2,1,2);
semilogy(f_axis, P_X_T);
title("Periodogram of Tx Signal X(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");

%---------------------RECEIVING END---------------------%
% Receive Noisy signal
snr_db = 20;
var_w = 1/(Ts * 10^(snr_db/10));

wg_noise = sqrt(var_w) .* randn(1,length(X_t));

% noised signal
Y_T = X_T + wg_noise;

figure;
plot(X_t, Y_T);
title("Rx Signal to the Receiver");
xlabel("Time(s)");
ylabel("Amplitude");

% Decompose
Y_I_cos = cos(2*pi*f0*X_t) .* Y_T;
Y_Q_sin = -sin(2*pi*f0*X_t) .* Y_T;

P_Y_I_r = abs(fftshift(fft(Y_I_cos, N_FFT)*Ts)).^2/s;
P_Y_Q_r = abs(fftshift(fft(Y_Q_sin, N_FFT)*Ts)).^2/s;

figure;
subplot(2,1,1);
plot(X_t, Y_I_cos);
title("Demodulated Y_I(t)");
ylabel("Amplitude");
xlabel("Time(s)");
subplot(2,1,2);
plot(X_t, Y_Q_sin);
title("Demodulated X_Q(t)");
ylabel("Amplitude");
xlabel("Time(s)");

figure;
subplot(2,1,1);
semilogy(f_axis, P_Y_I_r);
title("Periodogram Demodulated Y_I(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");
subplot(2,1,2);
semilogy(f_axis, P_Y_Q_r);
title("Periodogram Demodulated Y_Q(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");

%---------------------FILTERING---------------------%
% filter using φ(t)
Y_I_filter = conv(phi, Y_I_cos)*Ts;
Y_Q_filter = conv(phi, Y_Q_sin)*Ts;
Y_t = linspace(phi_t(1) + X_t(1),phi_t(end) + X_t(end), length(Y_I_filter));

P_Y_I_r = abs(fftshift(fft(Y_I_filter, N_FFT)*Ts)).^2/s;
P_Y_Q_r = abs(fftshift(fft(Y_Q_filter, N_FFT)*Ts)).^2/s;

figure;
subplot(2,1,1);
plot(Y_t, Y_I_filter);
title("Y_I(t) filtered");
xlabel("Time(s)");
ylabel("Amplitude");
subplot(2,1,2);
plot(Y_t, Y_Q_filter);
title("Y_Q(t) filtered");
xlabel("Time(s)");
ylabel("Amplitude");

figure;
subplot(2,1,1);
semilogy(f_axis, P_Y_I_r);
title("Periodogram Filtered Y_I(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");
subplot(2,1,2);
semilogy(f_axis, P_Y_Q_r);
title("Periodogram Filtered Y_Q(t)");
ylabel("Amplitude (log_{10})");
xlabel("Frequency (Hz)");

%---------------------SAMPLING---------------------%
% downsample and tail-cut the convolution near-0 points
Y_I_downsmpl = downsample(Y_I_filter(Y_t >= 0 & Y_t < s), over);
Y_Q_downsmpl = downsample(Y_Q_filter(Y_t >= 0 & Y_t < s), over);


scatterplot(Y_I_downsmpl + 1i*Y_Q_downsmpl);


%---------------------RECREATION---------------------%
% detect symbols and decode bianry information
[symbols_dec, bit_seq_dec] = detect_PSK_8([Y_I_downsmpl;Y_Q_downsmpl]);



%---------------------ERROR DETECTION---------------------%
bit_err = bit_errors(bit_seq_dec, bit_seq);
symbol_err = symbol_errors(symbols_dec, symbols);
% 
% 
fprintf("Detected Bit-Error: %d\n", bit_err);
fprintf("Detected Symbol-Error: %d\n", symbol_err);