% DEFINITIVE first step

DATA_PATH = 'data';
STRAIGHTEN_PATH = [DATA_PATH '/precut_warp'];
CUT_PATH = [DATA_PATH '/cut_warp'];

% 1. read images
images = {dir([DATA_PATH '/*.png']).name};
n = length(images);

% 2. create subfolders and files
if isempty(dir(CUT_PATH))
    mkdir(CUT_PATH);
end
if isempty(dir(STRAIGHTEN_PATH))
    mkdir(STRAIGHTEN_PATH);
end

cut_file = fopen([CUT_PATH '/where.csv'],'a');
if dir([CUT_PATH '/where.csv']).bytes == 0
    fprintf(cut_file, 'image,black,disp,top,right\n');
    fclose(cut_file);
end

d = table(1, 1375, 0, 1, 1024);
d.Properties.VariableNames = ["image", "black", "disp", "top", "right"];
for i = 1: n
    
    RGB = imread([DATA_PATH '/', images{i}]);
    name = split(images{i}, '.');
    
    % 3. b&w and straigthen
    BW = rgb2gray(RGB);
    S = straighten(BW, d.black);
    save([STRAIGHTEN_PATH '/' name{1} '.mat'], 'S')
    
    % 4. cut
    cut_image = S(d.top: (d.black-d.disp), 1: d.right);
    save([CUT_PATH '/' name{1} '.mat'], 'cut_image')
    data = [i, d.black, d.disp, d.top, d.right];
    dlmwrite([CUT_PATH '/where.csv'], data, '-append');
    
    if mod(i, 10) == 0
        disp(i)
    end
end