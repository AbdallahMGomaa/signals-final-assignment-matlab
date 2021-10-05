%reading input RTTTL string
ringtone='Macarena:d=4, o=5, b=180:f, 8f, 8f, f, 8f, 8f, 8f, 8f, 8f, 8f, 8f, 8a, 8c, 8c, f, 8f, 8f, f, 8f, 8f, 8f, 8f, 8f, 8f, 8d, 8c, p, f, 8f, 8f, f, 8f, 8f, 8f, 8f, 8f, 8f, 8f, 8a, p, 2c.6, a, 8c6, 8a, 8f, p, 2p';
%keys and frequencies of the tones
keys=['a';'a#';'b';'c';'c#';'d';'d#';'e';'f';'f#';'g';'g#';'p'];
values=[400,466.16,493.88,261.63,277.18,293.66,311.13,329.63,349.23,369.99,392,415.3,0];
%splitting the string to get name, defaults and data
ringtone=strsplit(ringtone,':');
%name of the song
name=ringtone{1};
%default part of the RTTTL
default=ringtone{2};
%splitting the default part
default=strsplit(default,', ');
%casting the cell array default to characters matrix
default=char(default);
%data part of the RTTTL
data=ringtone{3};
%splitting the data
data=strsplit(data,', ');
%casting the cell array to char matrix
data=char(data);
%loop on the default part to get the default values
for i=1:size(default,1),
  %getting the default duration of the tone and casting it to double
  if default(i,1)=='d',
    default_duration=str2double(default(i,3:end));
  %getting the default octave of the tone and casting it to double
  elseif default(i,1)=='o',
    default_octave=str2double(default(i,3:end));
  %getting the default tempo (beats per minute) and casting it to double
  elseif default(i,1)=='b',
    default_beatspermin=str2double(default(i,3:end));
  end;
end;
%initializing notes matrix with zeros the first column represents the duration
%of each note and the second column represents the pitch (frequency) of the note
notes=zeros(size(data,1),2);
%loop on all the notes in the data part
for i=1:size(data,1),
  %j is a counter that loops on the characters of each note
  j=0;
  %using temp to represent a note and remove the blank spaces in it
  temp=deblank(data(i,:));
  %looping on the first part of the note to get the duration
  while j<=length(temp)&&isdigit(temp(j+1)),
    j=j+1;
  endwhile;
  %if there exists some digits in the beginning of that note then it represents
  %the duration of that note else use the default duration for that note
  if j>0,
    curr_duration=str2double(temp(1:j));
  else,
    curr_duration=default_duration;
  endif;
  %transform the duration into time
  curr_duration=(1/curr_duration)*(60/default_beatspermin)*4;
  %k is a counter that loops on the rest of the characters
  k=j;
  %loop on the rest of the characters of the note represented by temp to get the
  %key of that note
  while k<length(temp)&&(isalpha(temp(k+1))),
    k=k+1;
  endwhile;
  %if there exists a key(must exist)
  if k!=j,
    %if that key is followed by a hash then add it to the key else just use that
    %character as a key and transform it to lower case
    if k<length(temp)&&temp(k+1)=='#',
      curr_note=tolower(temp(j+1:k+1));
      k=k+1;
    else
      curr_note=tolower(temp(j+1:k));
    endif;
  endif;
  %set the current octave to the default octave
  curr_octave=default_octave;
  %looping on the rest of the note if there exist a digit then assign it as the
  %current octave
  while k<=length(temp),
    if isdigit(temp(k)),
      curr_octave=str2double(data(i,k));
    endif;
    k=k+1;
  endwhile;
  %search for a . in the tone if yes add a half tone to it(multiplying by 2/3 
  %because we calculated time of that tone)
  for k=1:length(temp),
    if temp(k)=='.',
      curr_duration=(2/3);
      break;
    endif;
  endfor;
  %search for the key in the table of keys and get its values
  %i tried using map data structure but its not working
  for j=1:size(keys,1),
    if strmatch(curr_note,keys(j,:)),
      note=values(j);
      break;
    endif;
  endfor;
  %calculate the frequency of the note from octave and key value
  f=note*power(2,curr_octave-4);
  %assigning the duration and frequency in the table of notes
  notes(i,1)=curr_duration;
  notes(i,2)=f;
endfor;
%transforming the notes from frequency domain to time domain from the calculated
%duration and frequency

%setting the amplitude of the wave
amplitude=0.5;
%sampling frequency of the wave = tempo * 60
Fs=default_beatspermin*60;
%list of the output wave
a=[];
%loop on the elements of notes table
for i=1:size(notes,1),
  %getting the duration and freqency of the current tone from the tones table
  dur=notes(i,1);
  freq=notes(i,2);
  %sampling the duration of the current tone
  t=0:1/Fs:dur;
  %transforming the current duration and frequency to time domain using sin wave 
  %and adding it to the list a which represent the whole wave 
  a=[a,amplitude*sin(2*pi*freq*t)];
endfor;
%saving the audio file
sound(a,Fs);
audiowrite(strcat(name,'.wav'),a,Fs)