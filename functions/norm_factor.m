function scale = norm_factor(checkerboardPoints, boardSize)
% NORM_FACTOR Calculates the scaling factor between real-world dimensions
% and image-based measurements using a checkerboard pattern.
%
% Syntax:
%   scale = norm_factor(checkerboardPoints, boardSize)
%
% Inputs:
%   checkerboardPoints - A matrix containing the detected corner points 
%                        of the checkerboard in the image.
%   boardSize          - A 1x2 or 2x1 matrix specifying the number of
%                        interior corners along the checkerboard's rows 
%                        and columns ([rows, columns]).
%
% Output:
%   scale              - The scaling factor that converts pixel distances
%                        in the image to real-world measurements (mm/pixel).
%
% Description:
%   This function calculates the scaling factor by comparing the known size
%   of a checkerboard square (12.5 mm x 12.5 mm) with the average pixel 
%   distance between corresponding points in the checkerboard image.
%
% Example:
%   scale = norm_factor(detectedPoints, [8, 6]);

    % Validate the size of boardSize
    [rows, cols] = size(boardSize);
    if ~(rows == 1 && cols == 2) && ~(rows == 2 && cols == 1)
        error('Invalid boardSize. It should be a 1x2 or 2x1 matrix.');
    end

    % Known size of each square on the checkerboard (in mm)
    squareSize = 12.5;  % Square length in mm

    % Extract the four corner points of the checkerboard
    [topLeft, topRight, bottomLeft, bottomRight] = detect_corners(checkerboardPoints, boardSize);

    % Estimate pixel distances along rows and columns
    pixel_row_distance = sqrt(sum((topLeft - bottomLeft).^2)) / boardSize(1);
    pixel_column_distance = sqrt(sum((topRight - bottomRight).^2)) / boardSize(2);

    % Average pixel size per square
    pixel_image = mean([pixel_row_distance, pixel_column_distance]);

    % Calculate the scale (real-world distance per pixel)
    scale = squareSize / pixel_image;
end
