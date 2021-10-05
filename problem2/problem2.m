%creating an empty list for training set X_train
X_train=[];
%creating an empty list for training labels y_train
y_train=[];
%creating list of 4 vectors of size 15 to represent the centroid of each words
%the centroid is the vector which represents the value of the features of a word 
centroids=zeros(4,15);
%creating a list of 4 words we want to recognize in this example
words=["left";"right";"move";"stop"];
%loop on each word in the train folder
for i=1:4
    for j=1:10
        %reading the file audio values and sampling frequency
        [audio,fs]=audioread(strcat('train/',words(i,:),int2str(j),'.wav'));
        %since the audio is sterio so its two dimensional so we compress it in only one dimension
        audio=audio(:,1)+audio(:,2);
        %calculating the mfcc for each frame and averaging it to get the 14 coefficients which will be used as features
        %in the training algorithm 
        mel=mean(mfcc(audio,fs),1);
        %dropping the first coefficient as its always -infinity
        mel=mel(2:end);
        %extracting the maximum value in audio
        Max=max(audio);
        %calculating the total energy of the signal
        energy=sum(abs(audio.^2));
        %appending mel,Max and energy to the features vector
        features=[mel,Max,energy];
        %adding the extracted features to the training set X_train
        X_train=[X_train;features];
        %adding the label of the word to the training labels y_train
        y_train=[y_train;words(i,:)];
    end
end
%calculating the mean of each coefficient column in the training set
mu=mean(X_train,1);
%calculating the standard deviation of each coefficient column in the training set
sigma=std(X_train,1);
%feature scaling the training set to get better results in the training algorithm
X_train=(X_train-mu)./sigma;
%to calculate centroids we need to sum the values of each column of coefficients and getting its average
index=1;
for i=1:40
    centroids(index,:)=centroids(index,:)+X_train(i,:);
    if mod(i,10)==0
        index=index+1;
    end
end
%calculating the average of the sum to get the right centroid
centroids=centroids./10;
%creating an empty list for the test set X_test
X_test=[];
%creating an empty list for the test labels y_test
y_test=[];
%creating an empty list for the predicted labels y_pred
y_pred=[];
%loop on each word in the test folder
for i=1:4
    for j=1:5
        %reading the audio file values and the sampling frequency
        [audio,fs]=audioread(strcat('test/',words(i,:),int2str(j),'.wav'));
        %since the audio is sterio so its two dimensional so we compress it in only one dimension
        audio=audio(:,1)+audio(:,2);
        %calculating the mfcc for each frame and averaging it to get the 14 coefficients which will be used as features
        %to be used in testing
        mel=sum(mfcc(audio,fs),1);
        %dropping the first element as its always -infinity
        mel=mel(2:end);
        %extracting the maximum value in audio
        Max=max(audio);
        %calculating the total energy of the signal
        energy=sum(abs(audio.^2));
        %appending mel,Max and energy to the features vector
        features=[mel,Max,energy];
        %adding the extracted features to the test set X_test
        X_test=[X_test;features];
        %adding the label of the word to test labels y_test
        y_test=[y_test;words(i,:)];
    end
end
%calculating the mean of each coefficient column in the training set
mu=mean(X_test,1);
%calculating the standard deviation of each coefficient column in the training set
sigma=std(X_test,1);
%feature scaling the training set to get better results in the training algorithm
X_test=(X_test-mu)./sigma;
%using nearest neighbor algorithm to assign the current features to the nearest centroid
for i=1:20
    x=X_test(i,:);
    min=inf;
    index=0;
    for j=1:4
        dist=sum((x-centroids(j,:)).^2);
        if dist<min
            min=dist;
            index=j;
        end
    end
    y_pred=[y_pred;words(index)];
end
%displaying the test set and predicted set
disp('y_pred y_test');
fprintf('\n');
disp([y_pred,y_test]);
