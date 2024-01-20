% Load spectral gaps from the CSV file
gap_data = csvread('gaps.csv');
spectral_gaps = gap_data(:, 1);
gap_bins = gap_data(:, 2);

% Determine reuse group for each spectral gap
reuse_group = zeros(size(spectral_gaps));
current_group = 1;
for i = 1:length(spectral_gaps)
    if gap_bins(i) == 0
        reuse_group(i) = current_group;
        current_group = current_group + 1;
    end
end

% Display reuse group allocation
disp('Reuse Group Allocation:');
for i = 1:length(spectral_gaps)
    fprintf('Frequency %.2f MHz: Reuse Group %d\n', spectral_gaps(i), reuse_group(i));
end