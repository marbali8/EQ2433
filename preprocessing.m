function [rotated_clean_BW] = preprocessing(image)
    
image_gray = rgb2gray(image);

    % find angle of rotation with Hough transform. Here, edge detection is made
    % with Sobel since we found that Sobel removes noise to a large extent.
    BW_sobel = edge(image_gray, 'sobel');
    BW_clean = bwareaopen(BW_sobel, 50);
    angles = [];
    for angle = 1: 90
        BW_rot = imrotate(BW_clean,(-1)*angle, 'crop');
        [H , ~, ~] = hough(BW_rot);
        P = houghpeaks(H, 1, 'threshold', ceil(0.3*max(H(:))));
        angles = [angles P(2)];
    end
    [~, best_angle] = min(angles);

    % rotate image and then perform edge detection with Canny.
    rotated_image = imrotate(image_gray,- best_angle, 'bilinear', 'crop');
    BW_canny = edge(rotated_image, 'canny');
    rotated_clean_BW = bwareaopen(BW_canny, 20);
end