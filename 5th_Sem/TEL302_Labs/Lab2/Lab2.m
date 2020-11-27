close all;
clear; clc;

%% 1
fs = 1;
ts = 1/fs;
nom = [0 0.2 0];
denom = [1 -0.7 -0.18];
H = tf(nom, denom, ts);
figure;
zplane(nom, denom);

ang = -pi:pi/128:pi;
figure;
freqz(nom, denom, ang);
title("With angle samples");
figure;
freqz(nom, denom);
title("Without angle samples");

nom = [0 0 0.2 0];
denom = [1 -1.7 0.52 0.18];

figure;
zplane(nom, denom);
figure;
freqz(nom, denom, ang);
title("With angle samples");

%% 2
% From the man page of residuez:
b = [4 -3.5 0];
a = [1 -2.5 1];
[ro, po, ko] = residuez(b, a);

% zplane(b,a);

% Just declare z
syms z

% Partial fractions from the decomposed TF
H_1 = ro(1)/(1-po(1)*z^-1);
H_2 = ro(2)/(1-po(2)*z^-1);

% Reconstructed the Z.T.
H = H_1 + H_2;

fprintf("Partial H(z) (1):\n\n");
pretty(H_1);
fprintf("Partial H(z) (2):\n\n");
pretty(H_2);


izt = iztrans(H_1) + iztrans(H_2);
fprintf("Inverse Z.T.:\n\n");
pretty(izt);







