% DEFINITIVE first step

% if it's not ran in main.mlx, doesn't work because there are no paths nor
% where to cut.

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
straighten = strcmp(input('only cut? [y/n] ', 's'), 'n');

cut_file = fopen([CUT_PATH '/where.csv'],'a');
if dir([CUT_PATH '/where.csv']).bytes == 0
    fprintf(cut_file, 'image,black,disp,top,right\n');
    fclose(cut_file);
end

for i = 1: n
    
    name = split(images{i}, '.');
    if straighten
        
        RGB = imread([DATA_PATH '/', images{i}]);
    
        % 3. b&w and straigthen
        BW = rgb2gray(RGB);
        S = straighten(BW, d.black);
        save([STRAIGHTEN_PATH '/' name{1} '.mat'], 'S')
    else
        S = load([STRAIGHTEN_PATH '/' name{1} '.mat']).S;
    end
    %     S = imgaussfilt(S, [1e-5 0.9]);
    
    % 4. cut
    cut_image = S(d.top: (d.black-d.disp), 1: d.right);
    cut_image = flip(cut_image')';
    save([CUT_PATH '/' name{1} '.mat'], 'cut_image')
    data = [i, d.black, d.disp, d.top, d.right];
    dlmwrite([CUT_PATH '/where.csv'], data, '-append');
    
    if mod(i, 10) == 0
        disp(i)
    end
end