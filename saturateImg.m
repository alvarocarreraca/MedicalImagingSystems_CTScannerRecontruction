function [img] = saturateImg(img,buttonRange,topRange,keepOriginalValue)
% Alvaro Carrera Cardeli & Federico Medea - Original version (29/11/2020)
% Method to saturate an image in an input range.
    for ii = 1:size(img,1)
        for jj = 1:size(img,2)
            if(img(ii,jj) > topRange || img(ii,jj) < buttonRange)
                img(ii,jj) = 0;
            else
                if (~keepOriginalValue)
                    img(ii,jj) = 1;
                end
            end
        end
    end
end

