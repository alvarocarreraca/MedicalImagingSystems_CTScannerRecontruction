%  Make projected data for Shepp-Logan phantom for CT reconstruction
%
%  Calling: ct_data = shepp_logan (K,N);
%
%  Input:  K - Number of projection to be calculated
%          N - Number of projection points
%
%  Output: ct_data - CT data where first index is xm and second
%                    index is the projection angle
%
%  Version 1.1, 2/7-1997, Joergen Arendt Jensen

function ct_data = shepp_logan (K,N)

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
   
%  Setup parameters

Ndiv2=N/2;                     %  Half the total number
[Nelip,dummy]=size(pht_data);  %  Find number of ellipses

%  Preallocate the data structure

ct_data=zeros(N,K);

%  Make the projection data 

for i=1:Nelip

  %  Calculate the data for the ellipse

  A=Ndiv2*pht_data(i,3);       %  Major axis
  B=Ndiv2*pht_data(i,4);       %  Minor axis
  rho=pht_data(i,6);           %  Value inside ellipse
  x1=Ndiv2*pht_data(i,1);      %  Offset in x-direction
  y1=Ndiv2*pht_data(i,2);      %  Offset in y-direction
  alpha=pht_data(i,5)/180*pi;  %  Rotation with x-axis


  %  Generate the data

  index=1;
  s=sqrt(x1^2+y1^2);
  gamma=atan2(y1,x1);
  for theta1=0:pi/K:(pi-pi/(2*K))
    theta = theta1 - alpha;
    a2theta = (A*cos(theta))^2 + (B*sin(theta))^2;

    toffset = s*cos(gamma-theta1);
    tboundary = floor(sqrt(a2theta));
    tvalues = (1:N) - Ndiv2 + toffset;
    tinside = abs(tvalues) < tboundary;

    P = 2*rho*A*B/a2theta*sqrt(a2theta-tvalues.^2);
    data = P .* tinside;

    ct_data(:,index) = ct_data(:,index) + data';
    index = index + 1;
    end
  end




