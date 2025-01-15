%This is the function for updating the checker board and masking the
%checkerboard for further operation
function Image_masked = Checkerboard_updated(image, checkerboardPoints, boardSize)
   

    % Detect corner points of the checkerboard
    [topLeft, topRight, bottomLeft, bottomRight] = detect_corners(checkerboardPoints, boardSize);
    
    % Specify the region by defining a area of the checkerboard
    checkerboard_polygon = [topLeft; bottomLeft; bottomRight; topRight];

    % Calculate Image_mean the mean intensity of the entire image
    Image_mean = mean2(image(1:5, 1:5, :));
    
    % Let's create a binary mask in 2D

    Binary_mask_2D = poly2mask(checkerboard_polygon(:, 1), checkerboard_polygon(:, 2), size(image, 1), size(image, 2));
    
    % Now convert it into 3D using repmat function

    Binary_mask_3D = repmat(Binary_mask_2D, [1, 1, size(image, 3)]);

    % Copy the masked image
    Image_masked = image;

   %define the value for further calculation
    Image_masked(Binary_mask_3D) = Image_mean;
    
end