pkg load signal;
%reading the main signal
[main,f1]=audioread("salam alaikom.wav");
%reading the hidden signal
[hidden,f2]=audioread('w alaikom elsalam.wav');
main=main(:,1)+main(:,2);
hidden=hidden(:,1)+hidden(:,2);
%expanding the hiddem signal to have the same number of samples as the main signal
hidden=[hidden;zeros(size(main,1)-size(hidden,1),1)];
%creating the low pass filter with cutoff frequency pi/8
fc=f2/8;
[b,a]=butter(1,fc/f2);
%filtering the hidden signal to have maximum frequency pi/8
hidden=filter(b,a,hidden);
%multiply the hidden signal by cos(2*pi*n/2) to modulate it
for i=1:size(hidden,1),
  hidden(i)*=0.01*cos(2*pi*i/4);
endfor;
%creating the low pass filter with cutoff frequency pi/4
fc=f1/4;
[b,a]=butter(1,fc/f1);
%filtering the hidden signal to have maximum frequency pi/4
main=filter(b,a,main);
%adding main signal to modulated hidden signal
main+=hidden;
%listen to the main + modulated hidden signal
sound(main,f1);
%multiplying the main signal by cos(2*pi*n/4) to demodulate it
for i=1:size(main,1),
  main(i)*=cos(2*pi*i/4);
endfor;
%creating a low pass filter with cutoff frequency pi/8
fc=f2/8;
[b,a]=butter(1,fc/f2);
%filtering the demodulated signal
main=filter(b,a,main);
%listening to the demodulated signal
sound(100*main,f2); 