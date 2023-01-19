function [img] = reconstructImRotate(N,CT_data)
img = zeros(N);
angle = linspace(0,179,size(CT_data,2));

%figure;
for ii = 1:size(CT_data,2)
    %aux = meshgrid(ct_data(:,ii),1:lengthGrid);
    projection_filtered = filterCT(CT_data(:,ii),1);
    gridProj = meshgrid(projection_filtered,1:N);
    img_rotated = imrotate(gridProj,angle(ii));
    %limitis:
    xMin = size(img_rotated,1)/2 - size(img,1)/2 + 1;
    xMax = size(img_rotated,1)/2 + size(img,1)/2;
    yMin = size(img_rotated,2)/2 - size(img,2)/2 + 1;
    yMax = size(img_rotated,2)/2 + size(img,2)/2;
    centered_img = img_rotated(xMin:xMax,yMin:yMax); % 256x256
    if (size(centered_img,1) ~= 256 || size(centered_img,2) ~= 256)
        disp('Error')
    else
        img = img + centered_img;
    end
    %imagesc(img);
    %pause();
end

