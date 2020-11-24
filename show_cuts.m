DATA_PATH = 'data';
CUT_PATH = [DATA_PATH '/cut_equal'];
% CUT_PATH = [DATA_PATH '/cut'];

% 1. read images
images = {dir([DATA_PATH '/*.png']).name};
n = length(images);

% 2. read cut
cut_data = readtable([CUT_PATH '/where.csv']);
cut_image = nan;

for i = 1: n
    
    RGB = imread(strcat([DATA_PATH '/'], images{i}));
    d = cut_data(i, :);
    name = split(images{i}, '.');
    load([CUT_PATH '/' name{1} '.mat'])
    imshowpair(RGB(d.top:(d.black-d.disp), 1:d.right), cut_image, 'montage')
    title(name{1})
    pause(0.1)
end