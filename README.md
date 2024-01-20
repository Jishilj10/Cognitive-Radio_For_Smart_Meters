# RTL-SDR Spectrum Monitoring with MATLAB

This repository contains a MATLAB script for spectrum monitoring using an RTL-SDR (Software Defined Radio) receiver. The script captures radio frequency (RF) data, performs energy detection, and detects spectral gaps in the received signal. Additionally, it saves the spectral data, including frequency and gap information, into a CSV file.

## Requirements
1. MATLAB with Communications System Toolbox
2. RTL-SDR hardware
3. RTL-SDR driver support package for windows

## Getting Started
1. Clone the repository to your local machine.
```
git clone https://github.com/Jishilj10/Cognitive-Radio_For_Smart_Meters.git
```
2. Open MATLAB and navigate to the project directory.
3. Run the MATLAB script main.m.

## Configuration
Adjust the RTL-SDR parameters in the script to match your setup:
- *frequency*:  Center frequency in Hertz.
- *sampleRate*: Sample rate in Hertz.
- *gain*: Receiver gain in decibels.
- *fftSize*: FFT size for energy detection.
- *numAverages*: Number of averages for threshold updating.
- *threshold*:  Initial detection threshold.
- *bin_width*: Width of frequency bins for power calculation.

## Output
The script generates a real-time plot of the power spectral density and detected spectral gaps. The spectral data, including frequency and gap information, is saved to a CSV file named **gaps.csv**.

## Legal Considerations
Ensure compliance with legal and regulatory requirements when monitoring or interacting with radio frequency signals.

## Acknowledgements
This project utilizes the RTL-SDR hardware and MATLAB Communications System Toolbox.
Feel free to customize the script based on your specific use case and requirements. If you encounter issues or have suggestions for improvements, please open an issue or submit a pull request.






