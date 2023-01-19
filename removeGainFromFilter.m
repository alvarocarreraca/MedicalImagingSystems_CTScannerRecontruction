function [imgNorm,gain] = removeGainFromFilter(ctsh,img,gainPosRow,gainPosColumn)
% Alvaro Carrera Cardeli & Federico Medea - Original version (28/11/2020)
% Funtion to remove gain from filter.
    gainPosRow = gainPosRow*(size(ctsh,1)/512);
    gainPosColumn = gainPosColumn*(size(ctsh,1)/512);
    refVal = ctsh(gainPosRow,gainPosColumn);
    obtainVal = img(gainPosRow,gainPosColumn);
    gain = obtainVal/refVal;
    imgNorm = img./gain;
end

