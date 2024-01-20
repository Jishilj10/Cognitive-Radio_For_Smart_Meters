clc
close all
clear all

% Set RTL-SDR parameters
frequency = 101e6; % Set center frequency to 101 MHz
sampleRate = 3.2e6; % Set sample rate to 3.2 MHz
gain = 20; % Set gain to 20 dB

% Configure RTL-SDR object
radio = comm.SDRRTLReceiver('CenterFrequency', frequency, 'SampleRate', sampleRate, 'OutputDataType', 'double', 'SamplesPerFrame', 4096);

% Set energy detection parameters
fftSize = 4096; % Set FFT size to 4096
numAverages = 10; % Set number of averages to 10
threshold = 1; % Set detection threshold to 1
bin_width = 100e3;

% Create figure for spectrum plot
figure;
% subplot(2,1,1)
psd_plot = plot(nan, nan);
title('Power Spectral Density')

% subplot(2,1,2)
% gap_plot = bar(nan,nan,'r');
% title('Spectral Gaps')

% Receive signal and perform energy detection
while true
    % Receive signal
    tic
    [data, ~] = radio();

    % Perform energy detection
    [psd, freq] = periodogram(data, rectwin(length(data)), fftSize, sampleRate);
    energy = 10*log10(sum(psd)/fftSize); % Calculate energy of signal
    threshold = threshold + (energy - threshold)/numAverages; % Update threshold

    % Split into frequency bins and calculate power in each bin
    bin_start = min(freq);
    bin_end = bin_start + bin_width;
    bin_powers = [];
    centre_freqs = [];
    while bin_end <= max(freq)
        bin_index = find(freq >= bin_start & freq < bin_end);
        centre_freqs = [centre_freqs (bin_start+bin_end)/2];
        bin_pwr = mean(psd(bin_index));
        bin_powers = [bin_powers bin_pwr];
        bin_start = bin_end;
        bin_end = bin_start + bin_width;
    end

    % Detect spectral gaps using energy thresholding
    spectral_gaps = [];
    gap_index = [];
    for i = 1:length(bin_powers)
        if bin_powers(i) < 10^(threshold/10)
            spectral_gaps = [spectral_gaps i];
            gap_index = [gap_index 0]
        else
            gap_index = [gap_index 1]
        end
    end
    data = [centre_freqs', gap_index']

    filename = 'gaps.csv';
    writematrix(data,filename)

    % Plot spectrum and spectral gaps
    set(psd_plot, 'XData', freq/1e6, 'YData', 10*log10(psd))
    xlabel('Frequency (MHz)');
    ylabel('Power/Frequency (dB/Hz)');
    title(sprintf('Signal Spectrum (Threshold = %.1f dB)', threshold));
    axis([(min(freq)-(sampleRate))/1e6 (max(freq)+(sampleRate))/1e6 -120 0]);

%     set(gap_plot, 'XData', spectral_gaps, 'YData', gap_index*(-30))
    

    % Add squares for spectral gaps
    %gap_indices = find(gap_index == 0); % get indices of spectral gaps
    %gap_width = bin_width; % convert bin width to MHz
%     for i = 1:length(gap_indices)
%         idx = gap_indices(i);
%         x = spectral_gaps(gap_indices(i)) - gap_width/2;
%         y = -15; % center the square on the y-axis
%         width = gap_width;
%         height = 30; % set the height of the square
%         rectangle('Position', [x, y, width, height], 'FaceColor', 'none', 'EdgeColor', 'k');
%         %if idx <= length(spectral_gaps)
%         %x = spectral_gaps(idx) - gap_width/2;
%         %width = gap_width;
%         %height = 30; % set the height of the square
%         %rectangle('Position', [x, y, width, height], 'FaceColor', 'r', 'EdgeColor', 'b');
%        %end
%     end
%     gap_width = bin_width;
%     for i = 1:length(gap_index)
%        x = centre_freqs(i);
%        y = -15;
%        height = 30;
%        if gap_index(i) == 1
%           rectangle('Position', [x,y,gap_width,height], 'FaceColor', 'r', 'EdgeColor','none')     
%        else 
%           rectangle('Position', [x,y,gap_width,height], 'FaceColor','none','EdgeColor','k')
%        end   
%     end
%     xlabel('Frequency (MHz)');
%     title(sprintf('Spectral Gaps (Threshold = %.1f dB)', threshold));
    %axis([min(spectral_gaps) max(spectral_gaps) -120 0]);
   drawnow
   pause(0.5)
end

% Release
