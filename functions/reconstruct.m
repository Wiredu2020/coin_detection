function Image_mask = reconstruct(image, checkerboardPoints, boardSize)
% RECONSTRUCT Masks the checkerboard region in the image and replaces it 
% with the mean intensity of a small region at the top-left corner.
%
% Syntax:
%   Image_mask = reconstruct(image, checkerboardPoints, boardSize)
%
% Inputs:
%   image              - The input image to be masked.
%   checkerboardPoints - A matrix containing the detected corner points 
%                        of the checkerboard in the image.
%   boardSize          - A 1x2 or 2x1 matrix specifying the number of
%                        interior corners along the checkerboard's rows 
%                        and columns ([rows, columns]).
%
% Output:
%   Image_mask         - The resulting image with the checkerboard region 
%                        masked and replaced with a uniform intensity.
%
% Description:
%   This function identifies the four corner points of a checkerboard in an
%   input image, creates a binary mask for the region enclosed by the 
%   checkerboard, and replaces the pixel values within this region with the
%   mean intensity of a small (5x5) region at the top-left corner of the image.
%
% Example:
%   Image_mask = reconstruct(inputImage, detectedPoints, [8, 6]);

    % Detect the four corners of the checkerboard
    [topLeft, topRight, bottomLeft, bottomRight] = detect_corners(checkerboardPoints, boardSize);

    % Define a polygon using the detected corners
    Polygon = [topLeft; bottomLeft; bottomRight; topRight];

    % Calculate the mean intensity of a small region (5x5) at the top-left corner
    Image_mean = mean2(image(1:5, 1:5, :));

    % Create a binary mask for the specified checkerboard region
    binary2D = poly2mask(Polygon(:, 1), Polygon(:, 2), size(image, 1), size(image, 2));

    % Extend the 2D binary mask to 3D for multi-channel (color) images
    color_3D = repmat(binary2D, [1, 1, size(image, 3)]);

    % Create a copy of the original image to apply the mask
    Image_mask = image;

    % Replace the masked region with the calculated mean intensity
    Image_mask(color_3D) = Image_mean;
end

