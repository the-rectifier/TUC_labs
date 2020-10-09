t=[-10:15];

u=(t+3>=0);

t2=-t(end:-1:1)+5;

r=(5-t).*(5-t>=0);

t3=-t(end:-1:1)+2;

d=(t==2);

x=u-1/3*r+4*d;

stem(t,x);

figure(1);
subplot(1,2,1);
stem(t, u,'r');
subplot(1,2,2);
stem(t, r, 'b');
figure(2);
subplot(1,2,1);
stem(t, d,'g');
subplot(1,2,2);
stem(t, x, 'p');