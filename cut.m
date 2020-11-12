% 1. read images
images = {dir('data/*.png').name};
n = length(images);

% 2. create subfolder
if isempty(dir('data/cut'))
    mkdir('data/cut');
end

h = 180; w = 700;
for i = 1: n
    
    % 3. b&w and rotate and edge detection
    RGB = imread(strcat('data/', images{i}));
    BWr = preprocessing(RGB);
    
    % 4. show and cut
    ir = imshow(1-BWr); title(['cutting ' images{i} ' (showing 1-edges)']);
    key = -8; % not an ascii
    if i == 1
        [x, y, key] = ginput(1); x = round(x); y = round(y);
    end
    
    xx = x; yy = y;
    while ~isempty(key) % key pressed is return
        
        if key == 30 % up arrow
            y = y - 5;
        elseif key == 31 % down arrow
            y = y + 5;
        elseif key == 28 % left arrow
            x = x - 5;
        elseif key == 29 % left arrow
            x = x + 5;
        else
            x = xx; y = yy;
        end
        
        lim = [y-h y x x+w];
        alpha = ones(size(BWr)); alpha(lim(1): lim(2), lim(3): lim(4)) = 0.4;
        set(ir, 'AlphaData', alpha);

        [xx, yy, key] = ginput(1); xx = round(xx); yy = round(yy);
    end
    
    cut_image = BWr(lim(1): lim(2), lim(3): lim(4));
    name = split(images{i}, '.');
    save(strcat('data/cut', '/', name{1}, '.mat'),'cut_image')
    
end



