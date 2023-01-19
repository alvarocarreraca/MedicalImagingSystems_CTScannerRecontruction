%  Make the reference image for the Shepp-Logan 
%  phantom for CT reconstruction
%
%  Calling: ct_image = shepp_logan_image (Npixels);
%
%  Input:  Npixels - Number of pixels in image
%
%  Output: ct_image - Image of the Shepp-Logan phantom
%
%  Version 1.0, 21/11-2005, Joergen Arendt Jensen

function ct_image = shepp_logan_image (Npixels)

%  Data for ellipses in phantom.
%  Data from A. C. Kak and M. Slaney: principles 
%  of Computerized Tomographic Imaging, IEEE Press, 1988.
%
%    Center      Major   Minor Rotation Value
%   coordinate    axis    axis  angle      

pht_data=[
    0     0       0.92    0.69    90    2.0
    0    -0.0184  0.874   0.6624  90   -0.98
    0.22  0       0.31    0.11    72   -0.02
   -0.22  0       0.41    0.16   108   -0.02
    0     0.35    0.25    0.21    90    0.01
    0     0.1     0.046   0.046    0    0.01
    0    -0.1     0.046   0.046    0    0.01
   -0.08 -0.605   0.046   0.023    0    0.01
    0    -0.605   0.023   0.023    0    0.01
    0.06 -0.605   0.046   0.023   90    0.01];
   
%  Find the values for x and y

x= -2*(ones(Npixels,1)*((0:Npixels-1)/Npixels - 0.5))';
y= -x';   % Usually Matlab have a reversed y image axis

%  Preallocate the data structure

ct_image=zeros(Npixels,Npixels);

%  Make the projection data 

for i=1:size(pht_data,1)

  %  Calculate the data for the ellipse

  x1=pht_data(i,1);            %  Offset in x-direction
  y1=pht_data(i,2);            %  Offset in y-direction
  A=pht_data(i,3);             %  Major axis
  B=pht_data(i,4);             %  Minor axis
  alpha=pht_data(i,5)/180*pi;  %  Rotation with x-axis
  rho=pht_data(i,6);           %  Value inside ellipse

  %  Rotate the x and y coordinates for the ellipsoid
  
  xm= (x+x1)*cos(alpha) + (y+y1)*sin(alpha);
  ym=-(x+x1)*sin(alpha) + (y+y1)*cos(alpha);
  
  %  Make the image
  
  inside = ((((xm)/A).^2 + ((ym)/B).^2) <= 1);
  ct_image=ct_image + rho*inside;
  end
ct_image=ct_image';   %  Rotate since Matlab has the y coordinate as the first index
