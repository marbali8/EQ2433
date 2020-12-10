% DEFINITIVE second step (0. run cut_straight.m)

% if it's not ran in main.mlx, doesn't work because there are no paths nor
% data to calculate overlap_column.

% 1. read images
% images = {dir([DATA_PATH '/*.png']).name};
images = {dir([CUT_PATH '/*.mat']).name};
n = length(images);

% 2. read cut
% cut_data = readtable([CUT_PATH '/where.csv']);

I = load([CUT_PATH '/' images{1}]).cut_image;
% I = imread([CUT_PATH '/straight_cut' num2str(1) '.png']);
% I = I(600: 1287, :); % TODO (cut here? also in J)
% d = cut_data(1, :);
% I = I(d.top-150:(d.black-d.disp)-150, 1:d.right, :); WITH CUT_EQUAL
% I = I(d.top:(d.black-d.disp), 1:d.right, :);
% I = I(700: 1360, 1: 1024);

overlap_column = round(chord*pixels_per_mm);
col_from_end = size(I, 2) - overlap_column; % assumes all Js are same width

stitch_data = [];
for i = 2: length(images)
    
%     J = imread([CUT_PATH '/' images{i}]);
%     J = imread([CUT_PATH '/straight_cut' num2str(i) '.png']);
    J = load([CUT_PATH '/' images{i}]).cut_image;
%     J = J(600: 1287, :);
%     d = cut_data(i, :);
%     J = J(d.top-150: (d.black - d.disp)-150, 1: d.right, :); WITH CUT_EQUAL
%     J = J(d.top: (d.black - d.disp), 1: d.right, :);
    
%     J = J(700: 1360, 1: 1024);
%     J = flip(J, 2);
%     J = imrotate(J, 3.17, 'bilinear', 'crop');
    new_col = size(I, 2) - col_from_end;
    [I, maxs] = stitcher(I, J, new_col);
    stitch_data = [stitch_data maxs];
    
    if i > round(0.8*length(images)) && mod(i, 10) == 0
        disp(i)
    end
end
H = histeq(I);