function [error_img,error] = calculateProjectionError(mask,ctsh,img)
% Alvaro Carrera Cardeli & Federico Medea - Original version (28/11/2020)
% Method to calculate errors comparing two input images with the same size.
    expected = mask.*ctsh; % Aply mask
    recovered = mask.*img; % Aply mask
    error_img = abs(expected-recovered); % error image
    error = sum(sum(error_img)); % error result
end

