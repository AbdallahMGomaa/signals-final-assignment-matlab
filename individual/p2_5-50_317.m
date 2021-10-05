%part a
%range of points n
n=0:100;
%calculating the first term in the input equation
x=(0.5.^n);
%adding the second term in the input equation
x(2:end)=x(2:end)-0.25*(0.5.^n(1:end-1));
%calculating the fourier transform X(w) of the input x[n]
X=fft(x);
%calculating the output of the system y[n]
y=(1/3).^n;
%calculating the fourier transform Y(w) of the output y[n]
Y=fft(y);
%calculating the response H(w) of the system in frequency domain
H=Y./X;
%calculating the response h[n] of the system in time domain
h=ifft(H);
%creating figure for part i
figure("Name","part a");
%plotting the response h[n] in subplot 1
subplot(3,1,1);stem(n,h);
%calculating the response from the equation i got with hand analysis
h_calc=-2*((1/3).^n)+3*((1/4).^n);
%plotting hand analysis response in subplot 2
subplot(3,1,2);stem(n,h_calc);
%calculating the response of the equation i got in part 2
h_diff=filter([1,-1/2,0],[1,-7/12,1/12],x);
%plotting the response in subplot 3
subplot(3,1,3);stem(n,h_diff);
%_________________________________________________________________________________
%part b
%range of points n
n=0:100;
%calculating the output of the system y[n]
y=0.25.^n;
%calculating the input to the system x[n]
x=(n+2).*(0.5.^n);
%calculating the fourier transform Y(w) of the output y[n]
Y=fft(y);
%calculating the fourier transform X(w) of the input x[n]
X=fft(x);
%calculating the response H(w) of the system in frequency domain
H=Y./X;
%calculating the new output of the system y_new[n]
y_new=-((-0.5).^n);
%adding the delta in the equation d(n)
y_new(1)=y_new(1)+1;
%calculating fourier transform of y_new[n]
Y_new=fft(y_new);
%calculating X_new(w) in frequency domain
X_new=Y_new./H;
%calculating x_new[n] in time domain
x_new=ifft(X_new);
%creating figure for part i
figure("Name","part b");
%plotting the required input in subplot 1
subplot(2,1,1);stem(n,x_new)
%calculating the input i got with hand analysis
x_new_calc=(-9/8)*((-0.5).^n)+(3/8)*(0.5.^n)+(1/4)*(n+1).*(0.5.^n);
%adding the delta in the input 0.5d(n)
x_new_calc(1)=x_new_calc(1)+0.5;
%plotting the hand analysis input in subplot 2
subplot(2,1,2);stem(n,x_new_calc);