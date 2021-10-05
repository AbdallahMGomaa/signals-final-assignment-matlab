load("n1.mat");
L=length(n1);
n=0:L-1;
signal=fft(n1);
for i = n,
  if abs(signal(i+1))<280,
    signal(i+1)=0;
  end
end
subplot(2,1,1);
stem((signal));
y=ifft(signal);
subplot(2,1,2);
stem(y);
