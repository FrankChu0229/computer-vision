function [ ] = cornerDetect( filename, methodname )
%  cornerDetect solves the problem of detect corner
%    filename     --  the name of the file you want to detect
%    methodname   --  the name of corner detection algrithom you used
%                     here we use 'harris'
%                     If you achieve other algrithm for detection, you will get a score bonus.

% filename = 'E:\cv\testImages\board2.bmp'
if methodname == 'harris'
im_ori = imread(filename);
im = rgb2gray(im_ori);
k=0.04;

%The most common way to approximate the image gradient is to convolve an
%image with a kernel, here we use  Prewitt operator.
fx = [-1 0 1; -1 0 1;-1 0 1]; % Prewitt operator x-direction


Ix = conv2(im, fx);
fy=[-1 -1 -1; 0 0 0;1 1 1];  % Prewitt operator y-direction


Iy = conv2(im, fy);

Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

clear Ix;   
clear Iy; 
h = fspecial('gaussian',[9 9],3);

Ix2 = filter2(h,Ix2); %高斯降噪
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy); 

[m,n] = size(im);
V = zeros(m,n);
result = zeros(m,n);
thre = 0;

for i=1:m
    for j =1:n
        G = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
        V(i,j) = det(G) - k*(trace(G))^2;
        if V(i,j) > thre 
            thre = V(i,j);
        end
    end
end


for i = 2:m-1   
    for j = 2:n-1   
        % 如果V(i,j)和其他点相比是最大值且高于阈值，则将其输出。  
        if V(i,j) > 0.0005*thre && V(i,j) > V(i-1,j-1) && V(i,j) > V(i-1,j) && V(i,j) > V(i-1,j+1) && V(i,j) > V(i,j-1) && V(i,j) > V(i,j+1) && V(i,j) > V(i+1,j-1) && V(i,j) > V(i+1,j) && V(i,j) > V(i+1,j+1)   
            result(i,j) = 1;   
            
        end  
    end  
end 


[x, y] = find(result);     
 imshow(im_ori);   
 hold on
 plot(y,x,'r+');  

end


end

