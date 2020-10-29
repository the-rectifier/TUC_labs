clear; 
close all;

%A)
T = 10^-3;
over = 10;
Ts = T/over;
A = [4, 5];
a = [0, 0.5, 1];
phi = zeros(3,81);
t = zeros(3,81);

%A.1)
% Create and plot PHI functions with different a
figure;
subplot(3,1,1);

for i=1:3
    [phi(i,:),t(i,:)] = srrc_pulse(T,over,A(1),a(i));
    plot(t(i,:),phi(i,:));
    fprintf("BW = %f, for a=%f\n", (a(i)+1)/2*T, a(i));
    grid on;
    hold on;
end
fprintf("\n");
title("Different PHI functions for each roll-off value");
legend("a=0", "a=0.5", "a=1.0");
xlabel("Time");
ylabel("Amplitude");
axis([-4*10^-3, 4*10^-3, -1, 45]);
hold off;

% A.2)
% a)
% Calculate and plot FFT of all PHIs
subplot(3,1,2);
N = 2048;
PHI_f = zeros(3,N);
PHI_F = zeros(3,N);
Fs = 1/Ts;
f_axis =(-1/2 : 1/N : 1/2-1/N)*Fs;
for i=1:3
    PHI_f(i,:) = fftshift(fft(phi(i,:),N));
    PHI_F(i,:) = PHI_f(i,:).*Ts;
    plot(f_axis,(abs(PHI_F)).^2);
    hold on;
end
title("FF of all PHI functions");
xlabel("Frequency");
ylabel("Spectrum Power Density");
legend("a=0", "a=0.5", "a=1.0");
grid on;
hold off;

% b)
% Plot in semilogy as well
subplot(3,1,3);
for i =1:3
    semilogy(f_axis, (abs(PHI_F(i,:))).^2);
    hold on;
end
grid on;
%A.3)
c_1 = T/10^3;
c_2 = T/10^5;
cutoff_1 = ones(1,length(f_axis)).*c_1;
cutoff_2 = ones(1,length(f_axis)).*c_2;
semilogy(f_axis, cutoff_1);
semilogy(f_axis, cutoff_2);
title("FF of all PHI functions");
xlabel("Frequency");
ylabel("Spectrum Power Density (log10)");
legend("a=0", "a=0.5", "a=1.0", "cutoff_1", "cutoff_2");
hold off;

%B.1)
% For each a create phi and its 10 transpositions
% Use phi_kT() to pad phi and all the transpositions to the same time vector
time_k = -A(2)*T:Ts:(A(2)+10)*T;

%a = 0
[phi, ~] = srrc_pulse(T, over, A(2), a(1));
phi_k = phi_kT(phi,time_k, T, Ts, A(2));

figure(2);
subplot(3,1,1);
hold on;
for k=0:1:2*A(2)
   plot(time_k, phi_k(k+1,:)); 
end
title("PHI and its transpotisions, for a=0");
xlabel("Time");
ylabel("Amplitude");
grid on;
hold off;

figure;
subplot(2,2,1);
plot(time_k, phi_k(1,:) .* phi_k(1,:));
title("phi(t)*phi(t), a=0");
grid on;
subplot(2,2,2);
plot(time_k, phi_k(1,:) .* phi_k(2,:));
title("phi(t)*phi(t-T), a=0");
grid on;
subplot(2,2,3);
plot(time_k, phi_k(1,:) .* phi_k(3,:));
title("phi(t)*phi(t-2T), a=0");
grid on;
subplot(2,2,4);
plot(time_k, phi_k(1,:) .* phi_k(4,:));
title("phi(t)*phi(t-2T), a=0");
grid on;

fprintf("For a=0\n");
fprintf("phi(t)*phi(t) = %2.2f\n", sum(phi_k(1,:) .* phi_k(1,:))*Ts);
fprintf("phi(t)*phi(t-T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(2,:))*Ts);
fprintf("phi(t)*phi(t-2T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(3,:))*Ts);
fprintf("phi(t)*phi(t-3T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(4,:))*Ts);
fprintf("\n");
%a = 0.5
[phi, ~] = srrc_pulse(T, over, A(2), a(2));
phi_k = phi_kT(phi,time_k, T, Ts, A(2));
figure(2);
subplot(3,1,2);
hold on;
for k=0:1:2*A(2)
   plot(time_k, phi_k(k+1,:)); 
end
title("PHI and its transpotisions, for a=0.5");
xlabel("Time");
ylabel("Amplitude");
grid on;
hold off;

figure;
subplot(2,2,1);
plot(time_k, phi_k(1,:) .* phi_k(1,:));
title("phi(t)*phi(t), a=0.5");
grid on;
subplot(2,2,2);
plot(time_k, phi_k(1,:) .* phi_k(2,:));
title("phi(t)*phi(t-T), a=0.5");
grid on;
subplot(2,2,3);
plot(time_k, phi_k(1,:) .* phi_k(3,:));
title("phi(t)*phi(t-2T), a=0.5");
grid on;
subplot(2,2,4);
plot(time_k, phi_k(1,:) .* phi_k(4,:));
title("phi(t)*phi(t-3T), a=0.5");
grid on;

fprintf("For a=1\n");
fprintf("phi(t)*phi(t) = %2.2f\n", sum(phi_k(1,:) .* phi_k(1,:))*Ts);
fprintf("phi(t)*phi(t-T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(2,:))*Ts);
fprintf("phi(t)*phi(t-2T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(3,:))*Ts);
fprintf("phi(t)*phi(t-3T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(4,:))*Ts);
fprintf("\n");
%a = 1.0
[phi, ~] = srrc_pulse(T, over, A(2), a(3));
phi_k = phi_kT(phi,time_k, T, Ts, A(2));
figure(2);
subplot(3,1,3);
hold on;
for k=0:1:2*A(2)
   plot(time_k, phi_k(k+1,:)); 
end
title("PHI and its transpotisions, for a=1.0");
xlabel("Time");
ylabel("Amplitude");
grid on;
hold off;

figure;
subplot(2,2,1);
plot(time_k, phi_k(1,:) .* phi_k(1,:));
title("phi(t)*phi(t), a=1.0");
grid on;
subplot(2,2,2);
plot(time_k, phi_k(1,:) .* phi_k(2,:));
title("phi(t)*phi(t-T), a=1.0");
grid on;
subplot(2,2,3);
plot(time_k, phi_k(1,:) .* phi_k(3,:));
title("phi(t)*phi(t-2T), a=1.0");
grid on;
subplot(2,2,4);
plot(time_k, phi_k(1,:) .* phi_k(4,:));
title("phi(t)*phi(t-3T), a=1.0");
grid on;

fprintf("For a=1\n");
fprintf("phi(t)*phi(t) = %2.2f\n", sum(phi_k(1,:) .* phi_k(1,:))*Ts);
fprintf("phi(t)*phi(t-T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(2,:))*Ts);
fprintf("phi(t)*phi(t-2T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(3,:))*Ts);
fprintf("phi(t)*phi(t-3T) = %2.2f\n", sum(phi_k(1,:) .* phi_k(4,:))*Ts);
fprintf("\n");

%C
T = 0.1;
Ts = T/over;
[phi,t] = srrc_pulse(T,over,A(2),a(3));

% C.1
% N bits of data to be transfered 
% Create random stream of bits
bits = 50;
b_50 = (sign(randn(bits,1)) +1)/2;

%C.2
%a)
% 0 -> +1
% 1 -> -1
% PAM them
X_50 = bits_to_2PAM(b_50);

%b)
% Upsample the signal 
figure;
X_delta = 1/Ts*upsample(X_50,over);
T_delta = 0:Ts:bits/over-Ts;
plot(T_delta,X_delta);
title('Upsampled Delta train');
xlabel("Time");
ylabel("Amplitude");
grid on;

%c)
% sample the PHI signal and
% create the signal based on the carrier wave
figure;
t_phi_conv = (t(1) + T_delta(1):Ts:t(end) + T_delta(end));
X_t = conv(X_delta,phi)*Ts;
plot(t_phi_conv, X_t);
title('Modulated PAM into carrier signal');
xlabel("Time");
ylabel("Amplitude");
grid on;

%d)
% "Recieve" the signal and recreate the modulated PAM
% Sample the the signal and recreate the sent Sequence
% Compare the sequence against the sent sequnce
figure;
hold on;
t_phi_minus = -fliplr(t);
phi_minus = fliplr(phi);

tconv = (t_phi_minus(1) + t_phi_conv(1):Ts:t_phi_minus(end) + t_phi_conv(end));
X_z = conv(phi_minus, X_t)*Ts;
plot(tconv, X_z);

stem((0:49)*T,X_50);

for t=1:length(tconv)
   if mod(tconv(t), T) == 0 && tconv(t) >= 0 && tconv(t) <= A(2)-Ts
      stem(tconv(t), X_z(t)); 
   end
end

title('Recieved Signal and sampled points');
grid on;
hold off;
