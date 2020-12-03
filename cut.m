DATA_PATH = 'data';
CUT_PATH = [DATA_PATH '/cut'];

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

h = 710; w = 1024; from_center = 15;
for i = 1: n
    
    % 3. b&w and edge detection
    RGB = imread(strcat([DATA_PATH '/'], images{i}));
    BWr = preprocessing(RGB);
    
    % 4. show and cut
    ir = imshow(1-BWr); title(['cutting ' images{i} ' (showing 1-edges)'], 'Interpreter', 'none');
    key = 121; % y, zoom super in
    if i == 1
        [x, y, key] = ginput(1); x = round(x); y = round(y);
    end
    
    xx = x; yy = y;
    while ~isempty(key) % key pressed is return
        
        if key == 105 % i, zoom in
            axis([lim(3)-20 lim(4)+20 lim(1)-20 lim(2)+20])
        elseif key == 111 % o, zoom out
            axis([1 size(BWr, 1) 1 size(BWr, 2)])
            axis tight
        elseif key == 121 % y, zoom super in
            axis([x-20 x+20 y-20 y+20])
        elseif key == 30 % up arrow
            y = y - 1;
        elseif key == 31 % down arrow
            y = y + 1;
        elseif key == 28 % left arrow
            x = x - 1;
        elseif key == 29 % left arrow
            x = x + 1;
%         elseif key == 113 % q
%             BWr = imrotate(BWr, 1, 'bilinear', 'crop');
%             ir = imshow(1-BWr); title(['cutting ' images{i} ' (showing 1-edges)'], 'Interpreter', 'none');
%         elseif key == 119 % w
%             BWr = imrotate(BWr, -1, 'bilinear', 'crop');
%             ir = imshow(1-BWr); title(['cutting ' images{i} ' (showing 1-edges)'], 'Interpreter', 'none');
        else
            x = xx; y = yy;
        end
        if x < 1, x = 1; end
        if x > size(BWr, 2), x = size(BWr, 2); end
        if y < 1, y = 1; end
        if y > size(BWr, 1), y = size(BWr, 1); end
        
        lim = [y-(from_center+h-1) y-from_center x x+w-1];
        alpha = ones(size(BWr)); alpha(lim(1): lim(2), lim(3): lim(4)) = 0.2;
        set(ir, 'AlphaData', alpha);

        [xx, yy, key] = ginput(1); xx = round(xx); yy = round(yy);
    end
    
    cut_image = BWr(lim(1): lim(2), lim(3): lim(4));
    name = split(images{i}, '.');
    save(strcat(CUT_PATH, '/', name{1}, '.mat'),'cut_image')
    data = [i, y, from_center, lim(1), lim(4)];
    dlmwrite([CUT_PATH '/where.csv'],data, '-append');
%     fprintf(cut_file, '\n%s,%d,%d,%d,%d', name{1}, y, from_center, lim(1), lim(4));
    % if we want to see the cut, we would do im(top:(black-disp), 1:right)
end
