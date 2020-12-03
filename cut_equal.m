DATA_PATH = 'data';
CUT_PATH = [DATA_PATH '/cut_equal_higher'];

% 1. read images
images = {dir([DATA_PATH '/*.png']).name};
n = length(images);

% 2. create subfolder
if isempty(dir(CUT_PATH))
    mkdir(CUT_PATH);
end

cut_file = fopen([CUT_PATH '/where.csv'],'a');
if dir([CUT_PATH '/where.csv']).bytes == 0
    fprintf(cut_file, 'image,black,disp,top,right\n');
    fclose(cut_file);
end

% cut_data = readtable([DATA_PATH '/cut/where.csv']);
% d = cut_data(1, :);
d = table(1, 1303, 15, 579, 1024);
d.Properties.VariableNames = ["image", "black","disp","top","right"];
for i = 1: n
    
    % 3. b&w and edge detection
    RGB = imread(strcat([DATA_PATH '/'], images{i}));
    BWr = preprocessing(RGB);
    cut_image = BWr(d.top:(d.black-d.disp), 1:d.right);
    name = split(images{i}, '.');
    save(strcat(CUT_PATH, '/', name{1}, '.mat'),'cut_image')
    data = [i, d.black, d.disp, d.top, d.right];
    dlmwrite([CUT_PATH '/where.csv'],data, '-append');
end
