function Hd = filterDesignPassband
%FILTERDESIGNPASSBAND Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.10 and Signal Processing Toolbox 8.6.
% Generated on: 22-May-2021 10:26:47

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 128;  % Sampling Frequency

Fstop1 = 0.1;         % First Stopband Frequency
Fpass1 = 0.9;         % First Passband Frequency
Fpass2 = 49;        % Second Passband Frequency
Fstop2 = 51;        % Second Stopband Frequency
Astop1 = 6;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 10;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% [EOF]
