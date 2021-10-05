n=1:100;
h=[-1 -1 1 1 1];
H=fft(h,100);
x_=[1 0 0 0];
x=[];
for i=1:25
  x=[x,x_];
end
ak=fft(x);
bk1=H.*ak;
omega=pi/2;
bk2=0.25-(i/2)*sin(omega*n);
subplot(2,1,1);
stem(n,bk1);
subplot(2,1,2);
stem(n,bk2);
