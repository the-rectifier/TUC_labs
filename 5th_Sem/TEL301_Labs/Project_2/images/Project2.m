clear; clc;
close all;

% Constants
T = 1e-2;
over = 10;
Ts = T/over;
Fs = 1/Ts;
A = 4;
a = 0.5;
N_FFT = 4096;
N_bits = 100;
K = 500;

f_axis = -Fs/2:Fs/N_FFT:Fs/2-Fs/N_FFT;
Pxf_table = zeros(K, N_FFT);

% A.1 - Create pulse
[phi, phi_t] = srrc_pulse(T, over, A, a);
phi_F = abs(fftshift(fft(phi,N_FFT).*Ts)).^2;
figure;
semilogy(f_axis, phi_F);
title("PSD of φ(t)");
xlabel("Frequency");
ylabel("PSD");

% A.2 - Modulation
[X_t_t,X_t,dur] = modulate_2PAM(phi_t, phi, N_bits, Ts, over);
figure;
plot(X_t_t, X_t);
title("Transmission wave 2-PAM");
xlabel("Time (s)");
ylabel("Amplitude");

psd_phi = (1/T).*phi_F;

% A.3 - 2 PAM PSD
Pxf = abs(fftshift(fft(X_t, N_FFT).*Ts)).^2/dur;
figure;
plot(f_axis, Pxf);
title("2-PAM Periodogram");
xlabel("Frequency (Hz)");
ylabel("Amplitude");
figure;
semilogy(f_axis, Pxf);
title("2-PAM Periodogram - Log scale");
xlabel("Frequency (Hz)");
ylabel("Amplitude (log_{10})");

for i=1:K
    [~,X_t,dur] = modulate_2PAM(phi_t, phi, N_bits, Ts, over);
    Pxf_table(i,:) = abs(fftshift(fft(X_t,N_FFT).*Ts)).^2/dur;
end

figure;
semilogy(f_axis, mean(Pxf_table));
hold on;
semilogy(f_axis, psd_phi);
legend("Estimated", "Theoretical");
title("PSD Estimation and Theoretical 2-PAM");
xlabel("Frequency (Hz)");
ylabel("PSD");
hold off;

% A.4
[X_t_t,X_t,~] = modulate_4PAM(phi_t, phi, N_bits, Ts, over);
figure;
plot(X_t_t, X_t);
title("Transmission wave 4-PAM");
xlabel("Time (s)");
ylabel("Amplitude");

for i=1:K
    [~,X_t,dur] = modulate_4PAM(phi_t, phi, N_bits, Ts, over);
    Pxf_table(i,:) = abs(fftshift(fft(X_t,N_FFT).*Ts)).^2/dur;
end

psd_phi = 5/T.*phi_F;

figure;
semilogy(f_axis, mean(Pxf_table));
hold on;
semilogy(f_axis, psd_phi);
legend("Estimated", "Theoretical");
title("PSD Estimation and Theoretical 4-PAM");
xlabel("Frequency (Hz)");
ylabel("PSD");
hold off;

% A.5
T = 2*T;
over = 2*over;

[phi, phi_t] = srrc_pulse(T, over, A, a);

[X_t_t,X_t,dur] = modulate_2PAM(phi_t, phi, N_bits, Ts, over);

phi_F = abs(fftshift(fft(phi,N_FFT)*Ts)).^2;

psd_phi = (1/T).*phi_F;

Pxf = abs(fftshift(fft(X_t, N_FFT).*Ts)).^2/dur;
figure;
plot(f_axis, Pxf);
title("2-PAM PSD - T'= 2T");
xlabel("Frequency (Hz)");
ylabel("PSD");

figure;
semilogy(f_axis, Pxf);
title("2-PAM PSD - Log scale - T'= 2T");
xlabel("Frequency (Hz)");
ylabel("PSD (log_{10})");

for i=1:K
    [~,X_t,dur] = modulate_2PAM(phi_t, phi, N_bits, Ts, over);
    Pxf_table(i,:) = abs(fftshift(fft(X_t,N_FFT).*Ts)).^2/dur;
end

figure;
semilogy(f_axis, mean(Pxf_table));
hold on;
semilogy(f_axis, psd_phi);
hold off;
legend("Estimated", "Theoretical");
title("PSD Estimation and Theoretical 2-PAM T' = 2T");
xlabel("Frequency (Hz)");
ylabel("PSD");

% B.4
T = T/2;
fo = 3/(2*T);
over = over/2;

[phi, phi_t] = srrc_pulse(T, over, A, a);

for i=1:500
    theta = 2*pi*rand();
    [X_t_t,X_t,dur] = modulate_2PAM(phi_t, phi, N_bits, Ts, over);
    y_t = X_t.*cos(2*pi*fo*X_t_t + theta);
    Pxf_table(i,:) = abs(fftshift(fft(y_t,N_FFT)*Ts)).^2/dur;
end

figure;
semilogy(f_axis,mean(Pxf_table));
title("Estimaded PSD of X(t)");
xlabel("Frequency (Hz)");
ylabel("PSD");














