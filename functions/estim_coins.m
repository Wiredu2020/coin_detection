function [coins] = estim_coins(measurement, bias, dark, flat)
% ESTIM_COINS Detect and classify coins from an input image.
% 
% This function processes the input images to calibrate and detect circular
% objects (coins) based on intensity adjustments and feature extraction. The
% classification is performed using pre-defined calibration data.
%
% INPUTS:
%   measurement - The measurement image containing the objects (coins).
%   bias        - The bias image for calibration.
%   dark        - The dark field image for calibration.
%   flat        - The flat field image for calibration.
%
% OUTPUT:
%   coins - A 1x6 vector where each element corresponds to the count of coins 
%           for each detected class (1 to 6).

    % Define target size for resizing images
    targetSize = 520;

    % Resize all images to have the same height for consistency
    measurement = imresize(measurement, targetSize / size(measurement, 1)); 
    dark = imresize(dark, targetSize / size(dark, 1));
    flat = imresize(flat, targetSize / size(flat, 1));
    bias = imresize(bias, targetSize / size(bias, 1));

    % Detect checkerboard points for geometric calibration
    [checkerboardPoints, boardSize] = detectCheckerboardPoints(measurement, ...
        'PartialDetections', false);

    % Calibrate intensity of the images using the calibration measurements
    % Dark, bias, and flat field corrections are applied
    calibratedImage = calibration_measurement(measurement, bias, dark, flat, ...
        checkerboardPoints, boardSize);
    
    % Detect circular objects (potential coins) in the calibrated image
    [centers, radii] = circle_detection(calibratedImage, ...
        checkerboardPoints, boardSize);
    
    % Scale the detected points to real-world dimensions
    updatedImagePoints = norm_factor(checkerboardPoints, boardSize);

    % Initialize the coin count vector (six possible classes of coins)
    coins = zeros(1, 6);

    % Iterate through the detected circular objects to classify coins
    numObjects = size(centers, 1);
    for j = 1:numObjects
        % Extract features for the current detected object
        features = features_extractor(centers(j, :), radii(j), ...
            calibratedImage, updatedImagePoints);
        
        % Classify the coin based on its features
        coinClass = classifier(features);
     
        % Update the count of the classified coin if valid
        if coinClass > 0
            coins(coinClass) = coins(coinClass) + 1;
        end
    end
end
