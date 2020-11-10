close all;
clear;
clc;

t_step = 0.2;
t = 0:t_step:10-t_step;

% create the 2 signals
u_1 = zeros(size(t));
u_2 = zeros(size(t));
u_1(t>=1 & t<2) = 1;
u_2((t>=3 & t<5) | (t>=7 & t<9)) = 1;

% flip x_2 for convolving later
u_2_tflip = -fliplr(t);
u_2_flip = fliplr(u_2);

% create time vector for convolution
y_t = 2*t(1):t_step:2*t(end);
y = zeros(1,length(y_t));
ly = length(y);

% create freq axis for FFT later
N = ly;
f_axis = -0.5:1/N:0.5-1/N;
f_axis = f_axis .* 1/t_step;

% pad x_1 to be able to multiply
padL_1 = zeros(1,length(u_2)-1);
padR_1 = zeros(1,length(u_2)-1);
u_1_ext = [padL_1 u_1 padR_1];

% do the convolution and save for later
z = conv(u_1,u_2);

% do the convolution from stratch
for i=1:ly
   padL = zeros(1,i-1);
   padR = zeros(1,ly-i);
   
   x = [padL u_2_flip padR];
   y(i) = sum(x.*u_1_ext);
end

% plot them up
figure;
subplot(4,1,1);
stem(t, u_1, 'red');
title("x_1 = u[n-1] - u[n-2]");
xlabel("n");
ylabel("Amplitude");
axis([0 10, 0, 1.4]);
grid on;
subplot(4,1,2);
stem(t,u_2, 'blue');
title("x_2 = u[n-3] - u[n-5] + u[n-7] - u[n-9]");
xlabel("n");
ylabel("Amplitude");
axis([0 10, 0, 1.4]);
grid on;
subplot(4,1,3);
stem(y_t, y);
title("x_1 * x_2");
xlabel("n");
ylabel("Amplitude");
axis([0 20, 0, 7]);
grid on;
subplot(4,1,4);
stem(y_t, z, 'green');
title("conv(x_1, x_2)");
xlabel("n");
ylabel("Amplitude");
axis([0 20, 0, 7]);
grid on;

% do the FFTs for each signal
X_1 = fftshift(fft(u_1,N));
X_2 = fftshift(fft(u_2,N));
% multiply
X_zfft = X_1.*X_2.*t_step;
% FFT the convoluted signal from earlier
Z_fft = fftshift(fft(z,N).*t_step);

% prove that FFT(conv(z_n)) = FFT(x_1) * FFT(x_2)
figure;
subplot(2,2,1);
stem(f_axis, abs(Z_fft), 'red');
title("FFT(x_1) \cdot FFT(x_2)");
xlabel("F");
ylabel("|X(F)|");
grid on;
subplot(2,2,2);
stem(f_axis,abs(X_zfft), 'blue');
title("FFT(conv(x_1, x_2))");
xlabel("F");
ylabel("|X(F)|");
grid on;

%%
clc;
clear;

fs = 500;
f1 = 12;
f2 = 0.75;
Ts = 1/f1;
t = 0:1/fs:0.500-1/fs;

Tsa = 1/48;
Tsb = 1/24;
Tsc = 1/12;
TsA = 1/90;
ta = 0:Tsa:0.5-Tsa;
tb = 0:Tsb:0.5-Tsb;
tc = 0:Tsc:0.5-Tsc;
tA = 0:TsA:0.5-TsA;

x_t = 5*cos(2*pi*f1*t) - 2*cos(2*pi*f2*t);
x_ta = 5*cos(2*pi*f1*ta) - 2*cos(2*pi*f2*ta);
x_tb = 5*cos(2*pi*f1*tb) - 2*cos(2*pi*f2*tb);
x_tc = 5*cos(2*pi*f1*tc) - 2*cos(2*pi*f2*tc);
x_tA = 5*cos(2*pi*f1*tA) - 2*cos(2*pi*f2*tA);

figure;
subplot(4,1,1);
hold on;
plot(t, x_t);
stem(ta, x_ta);
title("x(t) sampled using 48Hz");
ylabel("Amplitude");
xlabel("t(s)")
grid on;
hold off;
subplot(4,1,2);
hold on;
plot(t, x_t);
stem(tb, x_tb);
title("x(t) sampled using 24Hz");
ylabel("Amplitude");
xlabel("t(s)")
grid on;
hold off;
subplot(4,1,3);
hold on;
plot(t, x_t);
stem(tc, x_tc);
title("x(t) sampled using 12Hz");
ylabel("Amplitude");
xlabel("t(s)")
grid on;
hold off;
subplot(4,1,4);
hold on;
plot(t, x_t);
stem(tA, x_tA);
title("x(t) sampled using 90Hz");
ylabel("Amplitude");
xlabel("t(s)")
grid on;
hold off;


%% 3

% A
clc;
clear;
% close all;

% samples
N = 128;
N_FFT = 2048;
% freqs of signals
f1 = 20;
f2 = 40;

% sampling period > 2fmax to avoid aliasing
ts = 1/500;
fs = 1/ts;
n = 0:N-1;

% sample the signal
x_n = 10*cos(2*pi*f1*ts.*n) - 4*sin(2*pi*ts*f2.*n + 5);


% plot and stem it
figure;
subplot(2,1,1);
hold on;
stem(n,x_n);
plot(n,x_n);
axis([0 128 -10 15]);
xlabel("n");
ylabel("Amplitude");
title("x[n] = sampled x(t) = 10cos(2\pi20t) - 4sin(2\pi40t)");
grid on;
hold off;

% plot the fft
subplot(2,1,2);
f_axis=-fs/2:fs/N_FFT:fs/2-1/N_FFT;
X_N = fftshift(fft(x_n,N_FFT)*ts);
plot(f_axis,abs(X_N));
axis([-100 100 0 1.5]);
grid on;
title("FT of x[n]");
ylabel("|X(F)|");
xlabel("F(Hz)");

% B
fs = 8e3;
ts = 1/fs;
N = 500;
n = 0:N-1;

f0 = 100:125:475;
f_axis = -fs/2:fs/N_FFT:fs/2-1/N_FFT;
figure;
for i=1:length(f0)
    subplot(2,2,i);
    x_n = sin(2*pi*f0(i)*ts.*n + 69666420133790);
    x_F = abs(fftshift(fft(x_n,N_FFT))*(ts));
    plot(f_axis,x_F);
    axis([-1000 1000 0 0.05]);
    grid on;
    xlabel("F(Hz)");
    ylabel("|X(F)|");
    title(sprintf("Freq Spectrum of x[n] using %d Hz as f_0", f0(i)));
end

f0=7525:125:7900;
figure;
for i=1:length(f0)
    subplot(2,2,i);
    x_n = sin(2*pi*f0(i)*ts.*n + 90);
    x_F = abs(fftshift(fft(x_n,N_FFT))*ts);
    plot(f_axis,x_F);
    axis([-1000 1000 0 0.05]);
    grid on;
    xlabel("F(Hz)");
    ylabel("|X(F)|");
    title(sprintf("Freq Spectrum of x[n] using %d Hz as f_0", f0(i)));
end















