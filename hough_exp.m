RGB = imread('pic1.png');
I  = rgb2gray(RGB); % convert to intensity
% lim = [1 size(I, 1) 1 size(I, 2)]; % all -> -45
lim = [614 880 677 1167]; % center -> 45
% lim = [1 500 1500 2000]; % top right -> 45
% lim = [1 500 1 500]; % top left -> 40
% lim = [1100 1500 1 400]; % down left -> 30
% lim = [1100 1500 1300 1800]; % down right -> 40 (was a bit surprised but
% probably it's a bad example and the box should be bigger / less on the
% strong 45 lines)
% lim = [150 550 1100 1600]; % transition to black -> 45
% lim = [1 size(I, 1)-200 1 size(I, 2)-200]; % all but not center of the record -> 45 (if i put 200 200 it already goes to -45)

alpha = ones(size(I)); alpha(lim(1): lim(2), lim(3): lim(4)) = 0.8;
I = I(lim(1): lim(2), lim(3): lim(4));

BW = double(edge(I, 'canny')); % extract edges
image = BW;
% image = I;
% image = BW(lim(1): lim(2), lim(3): lim(4));
[H, T, R] = hough(image);

% init_siz = 1500;
% siz = [init_siz init_siz];
% [r, c] = size(BW);
% for i = 0: round(siz(1)/3): r
%     if ((i + siz(1)) >= r)
%         siz(1) = r - (i+1);
%     end
%     for j = 0: round(siz(2)/3): c
%         
%         if ((j+1 + siz(2)) > c)
%             siz(2) = c - (j+1);
%         end
%         image = BW((i+1): (i+1)+siz(1), (j+1): (j+1)+siz(2));
% 
%         [H, T, R] = hough(image);
% 
%         maximum = max(max(H));
%         [x, y] = find(H == maximum);
%         if T(y) <= 0
%             figure,
%             alpha = ones(size(BW)); alpha((i+1): (i+1)+siz(1), (j+1): (j+1)+siz(2)) = 0.8;
%             ir = imshow(BW); set(ir, 'AlphaData', alpha); title(sprintf('i %d j %d T(y) %.1f', i, j, T(y)))
%         end
%         siz(2) = init_siz;
%     end
%     siz(1) = init_siz;
% end


% option 1: find maximum theta
% maximum = max(max(H));
% [x, y] = find(H == maximum);
% fprintf('max theta is %.1fº. \n', T(y))

% option 2: find top k maximum theta
maximums = maxk(H(:), 5);
text_res = sprintf('max theta are ');
for m = 1: size(maximums, 1)
    [~, y] = find(H == maximums(m));
%     fprintf('(%.1f, %.1fº), ', R(x)/R(end), T(y))
    text_res = strcat(text_res, sprintf('%.1fº, ', T(y)));
end

% option 3: find top k local maximum theta
[~, P] = islocalmax(H);
loc_maximums = maxk(P(:), 5);
text_res = strcat(text_res, sprintf('\nlocal max theta are'));
for m = 1: size(loc_maximums, 1)
    [~, y] = find(P == loc_maximums(m));
    text_res = strcat(text_res, sprintf('%.1fº, ', T(y)));
end

figure;

ax1 = subplot(4, 3, 1); ir = imshow(RGB); title('original with bbox'), set(ir, 'AlphaData', alpha);
ax2 = subplot(4, 3, 4); imshow(I), title('cut in b&w');
ax3 = subplot(4, 3, [2 3 5 6]); imshow(BW), title('edge detection');
% linkaxes([ax1 ax2 ax3], 'xy')

subplot(4, 3, 7: 9);
% mesh(T, R, imadjust(rescale(H)));
imshow(imadjust(rescale(H)),'XData', T, 'YData', R);
title('hough transform'); xlabel('\theta'), ylabel('\rho');
axis on, axis normal, colormap(gca, hot);

ax = subplot(4, 3, 10: 12); text(0, 0, text_res), set(ax, 'visible', 'off')