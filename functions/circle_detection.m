function [center, Radii] = circle_detection(calibratedimage, checkerboardPoints, boardSize)
    % Convert the image to grayscale
    grayImage = rgb2gray(calibratedimage);
    
    % Replace checkerboard with mean image intensity
    checkerboardCorrected = Checkerboard_updated(grayImage, checkerboardPoints, boardSize);

    % Perform Otsu's thresholding to binarize the image
    %Binarizing the image helps to detect the coins existed in the image
    %Use graythresh for threshold value
    threshold_value = graythresh(uint8(checkerboardCorrected));
    binaryImage = ~imbinarize(grayImage, threshold_value);

    % Open and close the binary image using morphological operations
    closing = imclose(binaryImage, strel('disk', 8));
    opening = imopen(closing, strel('disk', 3));

    % Detect circles using `imfindcircles`
    % Specify the expected range of circle radii as [6 size(grayImage, 1)]
    % Use 'bright' object polarity and set sensitivity to 0.95
    [center, Radii] = imfindcircles(opening, [6 size(grayImage, 1)], 'ObjectPolarity', 'bright', 'Sensitivity', 0.95);
end

