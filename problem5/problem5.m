pkg load image
%intensity of the blur which is the number of pixels the camera moved 
magnitude=30;
%angle is the direction of motion
angle=45;
%creates the motion blur kernel matrix
kernel=fspecial('motion',magnitude,angle);
%reading the image to be blurred
img=imread('Mr_krabs_choking.JPG');
%getting the grayscale of the input image
grayimg=rgb2gray(img);
%convolving the grayscale image with the blur kernel
output=uint8(conv2(grayimg,kernel));
%saving the output image
imwrite(output,'img.jpg');
%showing thr output image
imshow(output);
