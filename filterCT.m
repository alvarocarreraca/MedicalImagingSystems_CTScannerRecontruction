function [filteredData] = filterCT(CT_data,type,k)
% Alvaro Carrera Cardeli & Federico Medea - Original version (24/11/2020)
        % Generate filter:
        filterOrder = size(CT_data,1)*2; % causal
        CT_data(filterOrder,1) = 0;
        x = linspace(-0.5,0.5,filterOrder);
        filt = abs(x.*0.5); % Ideal filter
        if strcmp(type,'hann')
            filt = filt.*hann(length(filt))'; % Hann weighted filter
        elseif strcmp(type,'shepp')
            sheppLogan = (sin(filt/k)./(filt/k)); % k = 0.16
            filt = filt.*sheppLogan; % Shepp-Logan filter
        end
        filt = [filt(filterOrder/2+1:end) filt(1:filterOrder/2)];
        % Filtrate:
        spec = fft(CT_data); % change to frequency domain
        filtered_spec = spec .* filt'; % filtrate
        filteredData = ifft(filtered_spec,'symmetric'); % change to time domain
        filteredData(filterOrder/2+1:end,:) = []; % remove padding
end