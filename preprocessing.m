function [rotated_clean_BW] = preprocessing(image)

    % this function finds the angle of the groove lines, rotates the image,
    % does edge detection, cleans vertical lines (shouldn't be any) and
    % cleans noise.
    
    image_gray = rgb2gray(image);

    % find angle of rotation with Hough transform
    % edge detection with Sobel since we found that it removes noise to a large extent
    BW_sobel = edge(image_gray, 'sobel');
    BW_clean = bwareaopen(BW_sobel, 50);
    angles = [];
    for angle = 1: 90
        BW_rot = imrotate(BW_clean,-angle, 'crop');
        [H , ~, ~] = hough(BW_rot);
        P = houghpeaks(H, 1, 'threshold', ceil(0.3*max(H(:))));
        angles = [angles P(2)];
    end
    [~, best_angle] = min(angles);

    % rotate image and perform edge detection with Canny
    rotated_image = imrotate(image_gray, -best_angle, 'bilinear', 'crop');
    BW_canny = edge(rotated_image, 'canny');
    
    % clean vertical lines
    BW_canny = BW_canny - imerode(BW_canny, [0 1 0; 0 1 0; 0 1 0]);
    % clean away connected components for size <= 30
    rotated_clean_BW = bwareaopen(BW_canny, 30); 
end