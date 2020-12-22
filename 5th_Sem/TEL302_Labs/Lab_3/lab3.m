close all;
clear; clc;

% sampling rate
fs = 10e3;
% passband corner
Wp = 3e3/(fs/2);
% stopband corner
Ws = 4e3/(fs/2);
% passband rippling
Rp = 3;
% attenuation
Rs = 30;

[n,Wn] = buttord(Wp, Ws, Rp, Rs);
[lowpass_b,lowpass_a] = butter(n,Wn);

figure;
freqz(lowpass_b,lowpass_a);
title("Frequency Response");

%% 2
% sampling rate
ts = 0.2;
fs = 1/ts;
% cutoff angular freq (2*pi*fc)
Wc = 2;
% cutoff freq
Wc = Wc/(2*pi);
% passband rippling
Rp = 3;
% angle samples
Ang = 256;
ang_vector = 0:1/Ang:1-1/Ang;
% chebyshev order
n = [2 16];

% construct digital filter
[b1, a1] = cheby1(n(1), Rp, Wc/(fs/2), "high");
% freq response
f1_r = mag2db(abs(freqz(b1, a1, Ang)));

[highpass_b, highpass_a] = cheby1(n(2), Rp, Wc/(fs/2), "high");
f2_r = mag2db(abs(freqz(highpass_b, highpass_a, Ang)));

figure;
plot(ang_vector, f1_r);
hold on;
plot(ang_vector, f2_r);
hold off;
legend("2^{nd} order","16^{th} order");
title("Frequency Response");
ylabel("Amplitude (dB)");
xlabel("Normalized Frequency (x \pi rad/sample)");

%% 3
% f1 ~= 159 Hz
f1 = 1e3/(2*pi);
% f2 ~= 2.54 kHz
f2 = 16e3/(2*pi);
% f3 ~= 4.77 kHz
f3 = 30e3/(2*pi);

fs = 10e3;
ts = 1/fs;
N = 500;
n = 0:N-1;
N_FFT = 2048;
f_axis = -fs/2:fs/N_FFT:fs/2-fs/N_FFT;

% a
% create and sample signal
x_n = 1 + cos(2*pi*f1*ts*n) + cos(2*pi*f2*ts*n) + cos(2*pi*f3*ts*n);
X_n = abs(fftshift(fft(x_n, N_FFT)*ts));

% filter
x_n_filt = filter(lowpass_b, lowpass_a, x_n);
X_n_filt = abs(fftshift(fft(x_n_filt, N_FFT)*ts));

figure;

subplot(2,1,1);
stem(f_axis, X_n)
title("Frequency Spectrum of x(t) = 1+cos(1000t)+cos(16000t)+cos(30000t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");

subplot(2,1,2);
stem(f_axis, X_n_filt);
title("Frequency Spectrum of x(t) after filtering");
xlabel("Frequency (Hz)");
ylabel("Amplitude");

% b
ts = 0.2;
fs = 1/ts;
f_axis = -fs/2:fs/N_FFT:fs/2-fs/N_FFT;

% f1 ~= 0.23 Hz
f1 = 1.5/(2*pi);
% f2 ~= 0.80 Hz
f2 = 5/(2*pi);

x_n = 1 + cos(2*pi*f1*ts*n) + cos(2*pi*f2*ts*n);
X_n = abs(fftshift(fft(x_n, N_FFT)*ts));

x_n_filt = filter(highpass_b, highpass_a, x_n);
X_n_filt = abs(fftshift(fft(x_n_filt, N_FFT)*ts));

figure;
subplot(2,1,1);
stem(f_axis, X_n)
title("Frequency Spectrum of x(t) = 1+cos(1.5t)+cos(5t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");

subplot(2,1,2);
stem(f_axis, abs(X_n_filt));
title("Frequency Spectrum of x(t) after filtering");
xlabel("Frequency (Hz)");
ylabel("Amplitude");

%% 4

fs = 100;
Wc = ((0.5*pi)/(2*pi))/(fs/2);

N1 = 21;
N2 = 41;

% a
hamm1_win = fir1(N1, Wc, hamming(N1+1));
hamm2_win = fir1(N2, Wc, hamming(N2+1));
hann1_win = fir1(N1, Wc, hann(N1+1));
hann2_win = fir1(N2, Wc, hann(N2+1));

figure;
[h_hamm1, w_hamm1] = freqz(hamm1_win, N1);
[h_hamm2, w_hamm2] = freqz(hamm2_win, N2);
[h_hann1, w_hann1] = freqz(hann1_win, N1);
[h_hann2, w_hann2] = freqz(hann2_win, N2);

figure;
subplot(1,2,1);
plot(w_hamm1, abs(h_hamm1));
title("Hamming Window with N=21");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(1,2,2);
plot(w_hamm2, abs(h_hamm2));
title("Hamming Window with N=41");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
figure;
subplot(1,2,1);
plot(w_hann1, abs(h_hann1));
title("Hanning Widnow with N=21");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(1,2,2);
plot(w_hann2, abs(h_hann2));
title("Hanning Window with N=41");
xlabel("Frequency (Hz)");
ylabel("Amplitude");



% b
f1 = 15/(2*pi);
f2 = 200/(2*pi);
ts = 1/fs;
N = 500;
n = 0:N -1;
N_FFT = 2048;
f_axis = -fs/2:fs/N_FFT:fs/2-fs/N_FFT;

x_n = sin(2*pi*f1*ts*n) + 0.25*sin(2*pi*f2*ts*n);
X_n = abs(fftshift(fft(x_n, N_FFT)*ts));

X_n_win_hamm_1 = abs(fftshift(fft(filter(hamm1_win,1,x_n), N_FFT)*ts));
X_n_win_hamm_2 = abs(fftshift(fft(filter(hamm2_win,1,x_n), N_FFT)*ts));
X_n_win_hann_1 = abs(fftshift(fft(filter(hann1_win,1,x_n), N_FFT)*ts));
X_n_win_hann_2 = abs(fftshift(fft(filter(hann2_win,1,x_n), N_FFT)*ts));

figure;
subplot(3,1,1);
plot(f_axis, X_n);
title("Frequency Spectrum of x(t) = sin(15t) + 0.25sin(200t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,2);
plot(f_axis, X_n_win_hamm_1);
title("Applied Hamming window (N=21) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,3);
plot(f_axis, X_n_win_hamm_2);
title("Applied Hamming window (N=41) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
figure;
subplot(3,1,1);
plot(f_axis, X_n);
title("Frequency Spectrum of x(t) = sin(15t) + 0.25sin(200t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,2);
plot(f_axis, X_n_win_hann_1);
title("Applied Hanning window (N=21) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,3);
plot(f_axis, X_n_win_hann_2);
title("Applied Hanning window (N=41) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");



fs = 50;
Wc = ((0.5*pi)/(2*pi))/(fs/2);
N1 = 21;
N2 = 41;
ts = 1/fs;
f_axis = -fs/2:fs/N_FFT:fs/2-fs/N_FFT;

x_n = sin(2*pi*f1*ts*n) + 0.25*sin(2*pi*f2*ts*n);
X_n = abs(fftshift(fft(x_n, N_FFT)*ts));

X_n_win_hamm_1 = abs(fftshift(fft(filter(fir1(N1, Wc, hamming(N1+1)),1,x_n), N_FFT)*ts));
X_n_win_hamm_2 = abs(fftshift(fft(filter(fir1(N2, Wc, hamming(N2+1)),1,x_n), N_FFT)*ts));
X_n_win_hann_1 = abs(fftshift(fft(filter(fir1(N1, Wc, hann(N1+1)),1,x_n), N_FFT)*ts));
X_n_win_hann_2 = abs(fftshift(fft(filter(fir1(N2, Wc, hann(N2+1)),1,x_n), N_FFT)*ts));

figure;
subplot(3,1,1);
plot(f_axis, X_n);
title("Frequency Spectrum of x(t) = sin(15t) + 0.25sin(200t), f_s = 50 Hz");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,2);
plot(f_axis, X_n_win_hamm_1);
title("Applied Hamming window (N=21) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,3);
plot(f_axis, X_n_win_hamm_2);
title("Applied Hamming window (N=41) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
figure;
subplot(3,1,1);
plot(f_axis, X_n);
title("Frequency Spectrum of x(t) = sin(15t) + 0.25sin(200t), f_s = 50 Hz");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,2);
plot(f_axis, X_n_win_hann_1);
title("Applied Hanning window (N=21) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
subplot(3,1,3);
plot(f_axis, X_n_win_hann_2);
title("Applied Hanning window (N=41) to x(t)");
xlabel("Frequency (Hz)");
ylabel("Amplitude");





