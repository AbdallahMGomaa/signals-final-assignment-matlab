%range of points n
n=0:100;
%impulse response of the system h[n]
h=(1/2).^n.*cos(n*pi/2);
%input to the system x[n]
x=cos(n*pi/2);
%calculating fourier transform H(w) of the impulse response h[n]
H=fft(h);
%calculating fourier transform X(w) of the input signal x[n]
X=fft(x);
%calculating the output to the signal in frequency domain Y(w)
Y=H.*X;
%getting the inverse fourier transform of the output in time domain y[n]
y=ifft(Y);
%plotting the output signal in subplot 1
subplot(2,1,1);stem(n,y);
%calculating the output signal i got with hand analysis
y_calc=(1/3)*cos(n*pi/2).*(4-(0.5.^n));
%plotting the hand analysis output in subplot 2
subplot(2,1,2);stem(n,y_calc);