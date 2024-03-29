% Alvaro Carrera Cardeli & Federico Medea
% Script to run all the errors generated by changin the num of projections and pixels.
close all;clear all; clc
% Variables:
isCausal = 1; % boolean to make the filter causal
%numProj = 100; % number of projections generated in the simulation
numPixels = 256; % number of pixels in the reconstructed-squared image (512-256)
type = 'hann'; % filter used (ideal - shepp - hann)
gain = 0.7838; % gain of the filter
% GENERATE MESH (for SNR):
ctsh = shepp_logan_image(numPixels);
mesh = zeros(numPixels);
for kk = 1:numPixels
    for jj = 1:numPixels
        if (ctsh(kk,jj) < 2 && ctsh(kk,jj) > 0)
            mesh(kk,jj) = 1;
        end
    end
end
normVal = sum(sum(mesh));
error = zeros(1,180);
for ii = 1:180
    % Generate data:
    CT_data = shepp_logan (ii,numPixels);
    % Calculate image:
    img = reconstructImageCT(CT_data,numPixels,isCausal,type,gain);
    % Calculate error:
    [~,err] = calculateProjectionError(mesh,ctsh,img);
    error(ii) = err/normVal;
end
figure;
plot(3:180,error(3:end),'o')
%xlim([3 180])
