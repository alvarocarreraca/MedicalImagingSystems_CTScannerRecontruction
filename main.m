% Alvaro Carrer Cardeli & Federico Medea
% Main script
close all; clear all; clc
%% VARIABLES:
numProj = 100; % number of projections generated in the simulation
numPixels = 256; % number of pixels in the reconstructed-squared image
type = 'hann'; % filter used (ideal - shepp - hann)
isReal = 1; % boolean to process the clinincal image number 12
isBroken = 0; % boolean that allows to disable receptors 
posBroken = 128; % receptors broken
isFixed = 0; % boolean to fix the receptors broken


%% FIXED VALUES:
numberBroken = length(posBroken); % number of receptors broken
adjustImgRange = 0.05; % adjustable range to distinguis the tissues
minIntensity = 0.95; % min intensity value to plot in shepp logan
maxIntensity = 1.1; % max intensity value to plot in shepp logan
k = 0.16; % parameter of Shepp-Logan filter
gainPosRow = 224; % position of reference to calculate the gain of the filter (X)
gainPosColumn = 256; % position of reference to calculate the gain of the filter (Y)
if strcmp(type,'hann')
    gain = 0.7838; % gain of the filter (hann)
elseif strcmp(type,'shepp')
    gain = 0.7848; % gain of the filter (Shepp-Logan)
elseif strcmp(type,'ideal')
    gain = 0.7851; % gain of the filter (ideal)
else
    gain = 1;
end
% Parameters for the plots:
x_min = -1;
x_max = 1;
y_min = -1;
y_max = 1;
xLab = 'Relative x-coordinate';
yLab = 'Relative y-coordinate';
%% INPUT PARAMETERS:
ctsh = shepp_logan_image(numPixels);
if(~isReal)
    figure();
    imagesc([x_min x_max],[y_min y_max],ctsh,[minIntensity maxIntensity])
    colormap(gray)
    str = sprintf('Ideal Shepp-Logan phantom, %d x %d, Range: [0.95 1.1]',size(ctsh,1),size(ctsh,1));
    title(str)
    xlabel(xLab)
    ylabel(yLab)
    axis('image')
    colorbar
end
%% PREPARE PROJECTIONS:
CT_data = shepp_logan (numProj,numPixels);
if (isBroken)
    for ii = 1:length(posBroken)
        CT_data(posBroken(ii),:) = zeros(1,size(CT_data,2));
    end
end
if (isFixed && isBroken)
    for ii = 1:length(posBroken)
        prev = posBroken(ii)-1;
        next = posBroken(ii)+1;
        out = 0;
        while out == 0
            if ismember(prev,posBroken)
                prev = prev - 1;
            elseif ismember(next,posBroken)
                next = next + 1;
            else
                out = 1;
            end
        end
        CT_data(posBroken(ii),:) = (CT_data(next,:) + CT_data(prev,:))/2;
    end
end
offset = 0;
if (isReal)
    load('projections_012.mat')
    CT_data = ct_data;
    numProj = 200;
    CT_data(200,:) = zeros(1,size(CT_data,2));
    CT_data(200,:) = (CT_data(199,:) + CT_data(201,:))/2;
    offset = 1000;
end
figure;
imagesc([1 numProj],[y_min y_max],CT_data)
title('Projections (input to the system - Intensity)')
xlabel('Number of projection')
ylabel(yLab)
colormap(gray)
colorbar

%% RECONTRUCT IMAGE:
tic
img = reconstructImageCT(CT_data,type,gain,k);
img = img - offset;
toc
if (gain == 1)
    [img,gain] = removeGainFromFilter(ctsh,img,gainPosRow,gainPosColumn);
end
figure;
if(~isReal)
    imagesc([x_min x_max],[y_min y_max],img,[minIntensity-adjustImgRange maxIntensity]); % plot for simulations
else
    imagesc([x_min x_max],[y_min y_max],img,[-150 200]); % plot for in-vivo
end
title('Recontructed Image')
xlabel(xLab)
ylabel(yLab)
axis('image')
colormap(gray)
colorbar

%% GENERATE MASK (for Error calculation):
mask = zeros(numPixels);
for ii = 1:numPixels
    for jj = 1:numPixels
        if (ctsh(ii,jj) < 2 && ctsh(ii,jj) > 0)
            mask(ii,jj) = 1;
        end
    end
end
%% ERROR CALCULATION:
if (~isReal)
    [imgError,error] = calculateProjectionError(mask,ctsh,img);
    error/sum(sum(mask))
    figure;
    imagesc([x_min x_max],[y_min y_max],imgError,[0 0.25])
    title('Error')
    xlabel(xLab)
    ylabel(yLab)
    axis('image')
    colormap(gray)
    colorbar
end
