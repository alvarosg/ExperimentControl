% (c) Alvaro Sanchez Gonzalez 2014
function [ intensity, wavelenths, timestamp, params ] = CurrentSpectrum( spectrometer )
%CURRENTSPECTRUM Summary of this function goes here
%   Detailed explanation goes here

    intensity=spectrometer.intensity;
    wavelenths=spectrometer.lambda;
    timestamp=spectrometer.timestamp;
    params=spectrometer.params;


end

