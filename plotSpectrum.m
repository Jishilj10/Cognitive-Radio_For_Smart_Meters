freqStart = 90e6; % Start frequency
freqStop = 110e6; % Stop frequency

% Obtain frequency spectrum using fft
spectrum = fft(data);
spectrum = spectrum(1:length(spectrum)/2+1); % Only plot positive frequencies
spectrum = abs(spectrum); % Take magnitude of spectrum

% Set frequency axis
freqAxis = linspace(0, sampleRate/2, length(spectrum));

% Find indices of frequency range of interest
startIndex = find(freqAxis >= freqStart, 1);
stopIndex = find(freqAxis >= freqStop, 1);

% Plot spectrum in frequency range of interest
plot(freqAxis(startIndex:stopIndex), spectrum(startIndex:stopIndex));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Spectrum in Frequency Range of Interest');