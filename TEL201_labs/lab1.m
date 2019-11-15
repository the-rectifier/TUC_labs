clear
grid on;
figure(1);
nx = (-15:15);
x = 4*(nx-4>=0) + (-nx+8>=0) .* (-nx +8);
subplot(3,1,1);
stem(nx,x);

nh = (-15:10);
h = (1/2) .^abs(nh);
subplot(3,1,2);
stem(nh,h);

ny = nx(1) + nh(1):nx(end)+nh(end);

y2 = conv(x,h);
subplot(3,1,3);
stem(ny, y2);

figure(2);
n = (-10:15);
timec = 2*n(1):2*n(end);

xn = 0.75 * sin(n) .* (n>0&n<=8);
subplot(7,1,1);
stem(n,xn);

yn = 0.5 * exp(-0.5*n) .* (n>-5&n<10);
subplot(7,1,2);
stem(n,yn);


z1 = conv(xn,yn);
subplot(7,1,3);
stem(timec, z1);

z2 = conv(yn,xn);
subplot(7,1,4);
stem(timec, z2);

flipped_xn = 0.75*sin(-n) .* (-n>0&-n<=8);
flipped_xn1 = 0.75*sin(-n+1) .* (-n+1>0&-n+1<=8);
subplot(7,1,5);
z3 = conv(flipped_xn, flipped_xn1);
stem(timec, z3);

yn2 = 0.5 * exp(-0.5*n-2) .* (n-2>-5&n-2<10);
z4 = conv(yn,yn2);
subplot(7,1,6);
stem(timec,z4);

z5 = conv((xn + yn),yn2);
subplot(7,1,7);
stem(timec,z5);