function [imageReconstructed] = calculateInverseRadon(data,gain)
% Alvaro Carrera Cardeli & Federico Medea - Original version (19/11/2020)
    N = size(data,1); % Number of pixels
    angle = linspace(0,179,size(data,2)); % Number of projections
    % Generate grids of X and Y:
    if rem(N,2) == 0
        XYaxis = (-N/2 + 1):(N/2); % even
    else
        XYaxis = (-1*floor(N/2)):(floor(N/2)); % odd
    end
    mapX = repmat(XYaxis,N,1); % map of X axis
    mapY = repmat(XYaxis',1,N); % map of Y axis 
    % In case that the projection is narrower than the maximum with of the
    % recontructed image (NxN), we add padding to center the projection:
    maxWidthImg = ceil(sqrt(2)*N)+1; % length of the diagonal
    if maxWidthImg > size(data,1)
        diff = maxWidthImg - size(data,1);
        data = [zeros(ceil(diff/2),size(data,2)); data; zeros(floor(diff/2),size(data,2))]; %padding
    end
    % Claculate image:
    proj_axe = (1:length(data(:,1))) - ceil(size(data,1)/2); % projection axis
    imageReconstructed = zeros(N);
    for ii = 1 : length(angle)
        proj = data(:,ii);
        coordinates = mapX.*cos(angle(ii)*pi/180) + mapY.*sin(angle(ii)*pi/180); % CT coordinates
        interpolated_proj = interp1(proj_axe,proj,coordinates(:),'spline'); % iRadon
        imageReconstructed = imageReconstructed + reshape(interpolated_proj,N,N);
    end
    imageReconstructed = imageReconstructed*pi/(gain*length(angle)); % normalize
    imageReconstructed = flip(imageReconstructed,2);
end

