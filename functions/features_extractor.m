function imageFeatures = features_extractor(center, radius, image, scaleFactor)
% EXTRACT_IMAGE_FEATURES Extracts specific image features based on
% spatial and color characteristics in a circular region.
%
% Syntax:
%   imageFeatures = extract_image_features(center, radius, image, scaleFactor)
%
% Inputs:
%   center      - [x, y] coordinates representing the center of the circular region.
%   radius      - Radius of the circular region (in pixels).
%   image       - Input image in RGB format.
%   scaleFactor - Scaling factor applied to the image during calibration.
%
% Outputs:
%   imageFeatures - A vector containing the extracted features:
%                   [Diameter, WeightedHue, SaturationDifference, AvgHue, AvgSaturation]
%
% Description:
%   This function processes the input image to extract key features 
%   from a circular region. It computes the diameter, hue and saturation 
%   statistics (weighted and average), and differences between inner 
%   and outer saturation levels.
%
% Example:
%   features = extract_image_features([150, 120], 50, img, 1.2);

    % Convert the image to HSV color space
    hsvImage = rgb2hsv(image);

    % Compute the scaled diameter of the circular region
    diameter = 2 * scaleFactor * radius;

    % Pre-allocate matrices for hue and saturation
    hueMatrix = zeros(size(image, 1), size(image, 2));
    saturationMatrix = zeros(size(image, 1), size(image, 2));

    % Initialize arrays for inner and outer saturation values
    innerSaturation = [];
    outerSaturation = [];

    % Loop through each pixel in the image
    for row = 1:size(hsvImage, 1)
        for col = 1:size(hsvImage, 2)
            % Calculate the squared distance from the center
            distSquared = (col - center(1))^2 + (row - center(2))^2;

            % Check if the pixel lies within the circular region
            if distSquared <= radius^2
                % Extract hue and saturation for the current pixel
                hueMatrix(row, col) = hsvImage(row, col, 1);
                saturationMatrix(row, col) = hsvImage(row, col, 2);

                % Classify pixels into inner or outer saturation regions
                if distSquared <= (0.70 * radius)^2
                    innerSaturation = [innerSaturation; hsvImage(row, col, 2)];
                elseif distSquared <= (0.90 * radius)^2
                    outerSaturation = [outerSaturation; hsvImage(row, col, 2)];
                end
            end
        end
    end

    % Calculate weighted hue using saturation as weights
    weightedHue = sum(hueMatrix(:) .* saturationMatrix(:)) / sum(saturationMatrix(:));

    % Calculate the difference between inner and outer saturation means
    saturationDifference = mean(innerSaturation) - mean(outerSaturation);

    % Compute average hue and saturation
    avgHue = mean(hueMatrix(:));
    avgSaturation = mean(saturationMatrix(:));

    % Compile the features into a single vector
    imageFeatures = [diameter, weightedHue, saturationDifference, avgHue, avgSaturation];
end
