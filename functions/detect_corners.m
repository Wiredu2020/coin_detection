function [topLeftOuter, topRightOuter, bottomLeftOuter, bottomRightOuter] = detect_corners(checkerboardPoints, boardSize)
% DETECT_CORNERS Calculates the coordinates of the four outer corners of a checkerboard.
%
% Syntax:
%   [topLeftOuter, topRightOuter, bottomLeftOuter, bottomRightOuter] = detect_corners(checkerboardPoints, boardSize)
%
% Inputs:
%   checkerboardPoints - Matrix of detected inner corner points on the checkerboard (Nx2).
%   boardSize          - Dimensions of the checkerboard as a 1x2 or 2x1 matrix [rows, columns].
%
% Outputs:
%   topLeftOuter       - Coordinates of the top-left outer corner.
%   topRightOuter      - Coordinates of the top-right outer corner.
%   bottomLeftOuter    - Coordinates of the bottom-left outer corner.
%   bottomRightOuter   - Coordinates of the bottom-right outer corner.
%
% Description:
%   This function calculates the coordinates of the outer corners of a 
%   checkerboard based on its detected inner corner points and its size.
%
% Example:
%   [topLeftOuter, topRightOuter, bottomLeftOuter, bottomRightOuter] = ...
%       detect_corners(innerPoints, [8, 6]);

    % Validate the boardSize input
    [rows, cols] = size(boardSize);
    if ~(rows == 1 && cols == 2) && ~(rows == 2 && cols == 1)
        error('Invalid boardSize. It must be a 1x2 or 2x1 matrix.');
    end

    % Adjust boardSize to ensure it's in [rows, columns] format
    boardSize = reshape(boardSize, [1, 2]);

    % Update the height and width to adjust for edge calculations
    heightAdjusted = boardSize(1) - 2;
    widthAdjusted = boardSize(2) - 2;

    % Extract the inner corner points
    topLeftInner = checkerboardPoints(1, :);                              % Top-left inner corner
    bottomLeftInner = checkerboardPoints(1 + heightAdjusted, :);          % Bottom-left inner corner
    topRightInner = checkerboardPoints(end - heightAdjusted, :);          % Top-right inner corner
    bottomRightInner = checkerboardPoints(end, :);                        % Bottom-right inner corner

    % Calculate the outer corner points
    % Top-left outer corner
    topLeftOuter = topLeftInner + ...
        (topLeftInner - topRightInner) / widthAdjusted + ...
        (topLeftInner - bottomLeftInner) / heightAdjusted;

    % Bottom-left outer corner
    bottomLeftOuter = bottomLeftInner + ...
        (bottomLeftInner - bottomRightInner) / widthAdjusted + ...
        (bottomLeftInner - topLeftInner) / heightAdjusted;

    % Bottom-right outer corner
    bottomRightOuter = bottomRightInner + ...
        (bottomRightInner - bottomLeftInner) / widthAdjusted + ...
        (bottomRightInner - topRightInner) / heightAdjusted;

    % Top-right outer corner
    topRightOuter = topRightInner + ...
        (topRightInner - topLeftInner) / widthAdjusted + ...
        (topRightInner - bottomRightInner) / heightAdjusted;
end
