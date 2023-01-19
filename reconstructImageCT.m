function [img] = reconstructImageCT(CT_data,type,gain,k)
% Alvaro Carrera Cardeli & Federico Medea - Original version (24/11/2020)
    projection_filtered = filterCT(CT_data,type,k);
    img = calculateInverseRadon(projection_filtered,gain);
end

