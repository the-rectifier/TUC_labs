clear
close all;
%% ex1
n = (-12:28);
x1a = (pi/2).*exp(abs(2-(n/4))).*(sin(n-5)./(n-5));
x1b = (2+n).*(2+n>=0).*(0.5).^(n/4);
x1a(n>=5) = x1b(n>=5);
for i=1:length(n)
    if n(i)<5
        x1(i) = (pi/2).*exp(abs(2-(n(i)/4))).*(sin(n(i)-5)./(n(i)-5));
    else
        x1(i) = (2+n(i)).*(2+n(i)>=0).*(0.5).^(n(i)/4);
    end
end
figure(4);
stem(n,x1);
figure(1);
subplot(3,1,1);
stem(n,x1a);

x2 = x1a(end:-1:1);
x2n = -n(end:-1:1)-2;
subplot(3,1,2);
stem(x2n,x2);

nconv = n(1)+x2n(1):n(end)+x2n(end);
x3 = conv(x2,x1a);
subplot(3,1,3);
stem(nconv,x3);

%% ex2
n = (-10:10);
x1a = abs(n/2) .^ abs(n/4) .* cos(n/3);
x1b = (3+n) .* (3+n>=0) .* (0.8).^(n/3);
x1a(n>2) = x1b(n>2);
figure(2);
subplot(3,1,1);
stem(n,x1a);

x2n =-n(end:-1:1)+3;
x2 = x1a(end:-1:1);
subplot(3,1,2);
stem(x2n,x2);

nconv = n(1)+x2n(1):n(end)+x2n(end);
x3 = conv(x1a,x2);
subplot(3,1,3);
stem(nconv,x3);

%% ex3
DT = 0.001;
t1 = (-8:DT:8);
y1a = abs(t1/2).^abs(t1/4).*cos(t1/3);
y1b = (3+t1).*(3+t1>=0).* 0.8.^(t1/3);
y1a(t1>2)=y1b(t1>2);

figure(3);
subplot(5,1,1);

plot(t1,y1a);

Ey1 = sum(abs(y1a).^2)*DT;
Py1 = (1/length(y1a))*sum(abs(y1a).^2)*DT;

t2 = (-6:DT:7);
y2 = sin(5*pi*t2)+(sin(10*pi*t2).*exp(t2/2));
y3 = y2(end:-1:1);

subplot(5,1,2);
plot(t2,y2);
subplot(5,1,3);
plot(t2,y3);

tconv23 = 2*t2(1):DT:2*t2(end);
conv23 = conv(y2,y3)*DT;

tconv123 = t1(1)+tconv23(1):DT:t1(end)+tconv23(end);
conv123 = conv(y1a,conv23)*DT;
subplot(5,1,4);
plot(tconv123,conv123);

tconv12 = t1(1)+t2(1):DT:t1(end)+t2(end);
conv12 = conv(y1a,y2)*DT;

tconv12_3 = t2(1)+tconv12(1):DT:t2(end)+tconv12(end);
conv12_3 = conv(y3,conv12)*DT;
subplot(5,1,5);
plot(tconv12_3,conv12_3);


