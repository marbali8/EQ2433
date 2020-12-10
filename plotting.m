% FOR IMAGE PRE-PROCESSING

% DATA_PATH = 'data';
% STRAIGHTEN_PATH = [DATA_PATH '/precut_warp'];
% 
% images = {dir([DATA_PATH '/*.png']).name};
% 
% for i = 1: n
%     
%     name = split(images{i}, '.');
%     II = imread([DATA_PATH '/' name{1} '.png']);
%     SS = load([STRAIGHTEN_PATH '/' name{1} '.mat']).S;
%     
%     f = imshowpair(rgb2gray(II), SS); title(name{1}),
%     saveas(f, ['../../warp_images/' name{1}], 'png')
% end

% FOR STITCHING AND GROOVE DETECTION

jump = 500; last = 3000; title_length = 50;
i = 1: jump: size(I_show, 2);
times = find(i + last <= size(I_show, 2), 1, 'last');
for i = i(1: times)
        
        start = round(i/size(I_show, 2)*title_length)+1;
        finish = round((i + last)/size(I_show, 2)*title_length);
        t = char(ones(1, title_length) * '-');
        t(1, start:finish) = char(ones(1, length(start:finish)) * '*');
        f = imshow(I_show(:, i: i + last, :));
        title(t)
        saveas(f, ['../../groove_images/' num2str(i)], 'png')

end

% AUDIO
% audiowrite('../../final_audio.wav', final/max(final), round(Fs))