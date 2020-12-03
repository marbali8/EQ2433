% clc
% clear all
DATA_PATH = 'data';
CUT_PATH = [DATA_PATH '/cut_equal'];

% 1. read images
images = {dir([DATA_PATH '/*.png']).name};
n = length(images);

% 2. read cut
cut_data = readtable([CUT_PATH '/where.csv']);

I = imread(strcat([DATA_PATH '/'], images{1}));
d = cut_data(1, :);
I = I(d.top-150:(d.black-d.disp)-150, 1:d.right, :);
% I = I(700: 1360, 1: 1024);
% I = flip(I, 2);

r_record = 5.3;
theta = 3.17;
% chord is approx of the horizontal displacement in mm
chord = 2 * r_record * sind(theta/2) * 10;
pixels_per_mm = 207;
overlap_column = round(chord*pixels_per_mm);
col_from_end = size(I, 2) - overlap_column; % assumes all Js are same width

coeffs = [];
for i = 2: length(images)
    
    J = imread(strcat([DATA_PATH '/'], images{i}));
    d = cut_data(i, :);
    J = J(d.top-150: (d.black - d.disp)-150, 1: d.right, :);
    
%     J = J(700: 1360, 1: 1024);
%     J = flip(J, 2);
%     J = imrotate(J, 3.17, 'bilinear', 'crop');
    new_col = size(I, 2) - col_from_end;
    [I, maximum] = stitcher(I, J, new_col);
    coeffs = [coeffs maximum];
    
    if i > round(0.8*length(images)) && mod(i, 10) == 0
        disp(i)
    end
end
H = histeq(I);

for i = 1: 300: size(H, 2)
    
    if i + 7000 > size(H, 2)
        imshow(I(:, i: size(H, 2)))
    else
        imshow(I(:, i: i + 7000))
    end
    
    if mod(i, 1000) == 0
        disp(i)
    end
end