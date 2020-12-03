% help from https://stackoverflow.com/questions/7580623/how-to-change-an-image-from-cartesian-to-polar-coordinates-in-matlab
% easy warp: https://es.mathworks.com/help/images/ref/images.geotrans.warper.images.geotrans.warper.warp.html?lang=en
% heavy warp: https://es.mathworks.com/help/images/ref/warp.html
% imwarp: https://es.mathworks.com/help/images/ref/imwarp.html#btqog63-2_1
% pcolor (maybe to plot): https://es.mathworks.com/help/matlab/ref/pcolor.html
% exportgraphics (maybe to save): https://es.mathworks.com/help/matlab/ref/exportgraphics.html#mw_0f2a4f3a-4308-4733-a4ce-30925773dd4b
% projective2d: https://es.mathworks.com/help/images/ref/projective2d.html?lang=en

DATA_PATH = 'data';
I = imread(strcat([DATA_PATH '/'], '0001.png'));
% d = cut_data(1, :);
% I = I(d.top-150:(d.black-d.disp)-150, 1:d.right, :);

img = I;

% convert pixel coordinates from cartesian to polar
[h, w, ~] = size(img);
[X,Y] = meshgrid((1:w), (1:h)-h-53*207);

[theta, rho] = cart2pol(X, Y);
Z = zeros(size(theta));

% show images
f = figure;
hello = warp(theta, rho, Z, img); 
view([0 0 -270]);

% source1 = single(zeros(size(X)));
% i = 1;
% for r = 1:h
%     for c = 1:w
%         source1(r, c) = i;
%         i = i + 1;
%     end
% end
% w = images.geotrans.Warper(source1, source1);
% b = imwarp(w, img(:, :, 2));
% imshow(b)

% I1 = I(:, 1:1024, :);
% I2 = I(:, 1025:2048, :);
% movingPoints = [1024 1310; 1023 750; 1020 500; 1015 495];
% fixedPoints = [1 1310; 2 750; 15 500; 20 5];
% tform = fitgeotrans(movingPoints, fixedPoints,'projective');
% I2registered = imwarp(I2, tform, 'OutputView', imref2d(size(I)));
% figure
% imshowpair(I1, I2registered)
        
% grid off; axis tight; axis off;
% exportgraphics(hello,'0001_warp_better.jpg', 'Resolution',300, 'BackgroundColor','none')
% saveas(hello, '0001_warp.jpg');
% figure, imshow(imread('0001_warp_better.jpg'))

% S = surf(theta, rho, Z);
% set(S,'FaceColor','Texturemap','CData',I(:,:,2));
% view([0 0 -270])
