
function calibratedImage = calibration_measurement(measurement, mean_B, mean_D, norm_F, checkerboardPoints, boardSize)
% CALIBRATION_MEASUREMENT Calibrates a raw measurement image using bias,
% dark, and flat field images.
%
% Syntax:
%   calibratedImage = calibration_measurement(measurement, mean_B, mean_D, norm_F, checkerboardPoints, boardSize)
%
% Inputs:
%   measurement        - The raw measurement image to be calibrated.
%   mean_B             - The mean of the bias images (used to correct for
%                        fixed-pattern noise introduced by the sensor).
%   mean_D             - The mean of the dark images (used to correct for
%                        thermal noise).
%   norm_F             - The normalized flat field image (used to correct
%                        for pixel-to-pixel variation in sensitivity).
%   checkerboardPoints - A matrix containing the detected corner points 
%                        of the checkerboard in the flat field image.
%   boardSize          - A 1x2 or 2x1 matrix specifying the number of
%                        interior corners along the checkerboard's rows 
%                        and columns ([rows, columns]).
%
% Output:
%   calibratedImage    - The resulting calibrated image, where systematic
%                        sensor artifacts have been corrected.
%
% Description:
%   This function calibrates a raw measurement image by subtracting the 
%   contributions of bias and dark noise and dividing by a flat field 
%   correction image. The flat field correction image is reconstructed 
%   to exclude the region occupied by a detected checkerboard pattern.
%
%   The calibration formula used is:
%       calibratedImage = (measurement - mean_B - mean_D) ./ Norm_f_noboard
%
% Example:
%   calibratedImage = calibration_measurement(rawImage, biasMean, darkMean, normalizedFlat, detectedPoints, [8, 6]);

    % Reconstruct the flat field image to exclude the checkerboard region
    Norm_f_noboard = reconstruct(norm_F, checkerboardPoints, boardSize);

    % Apply the calibration formula to generate the calibrated image
    calibratedImage = (measurement - mean_B - mean_D) ./ Norm_f_noboard;
end
