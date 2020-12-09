% % DEFINITIVE third step (0. run stitching.m) (I is the stitched image)

% 1. define constants
I_ = I;
groove_h = 29; % estimated groove height
n_rev = 5;
I_show = zeros(size(I_, 1), size(I_, 2), 3);
I_show(:, :, 3) = I_;
[rows, cols] = size(I_);
centers = [492 zeros(1, cols*n_rev)];
maxs = zeros(cols*n_rev, 1);
% imshow(I_), hold on
i = 0; r = 1;
while r <= n_rev
    
    for c = 1: cols
        
        start = centers(c+cols*(r-1)) - groove_h;
        slice = I_((1: 2*groove_h-1) + start, c); % (2*groove_h-1, 1)
        mean_filter = ones(groove_h, 1)/(groove_h);
        intensities = conv(slice, mean_filter); % (2*groove_h-1 + groove_h - 1, 1)
        [m, i] = max(intensities);
        if m < 0.7
            i = i + 1;
            centers(c+1+cols*(r-1)) = centers(c+cols*(r-1));
    %         figure(2), stem(slice, 'r.'), hold on,
    %         stem(intensities, 'b.'), title(num2str(c)), ginput(1);
        else
            centers(c+1+cols*(r-1)) = centers(c+cols*(r-1)) + i - groove_h - floor(groove_h/2); % - length filter - first half of filter + start
        end
        maxs(c+cols*(r-1)) = m;
    %     plot(c, centers(c+1), 'r.', 'MarkerSize', 2), hold on
        I_show(centers(c+1+cols*(r-1)), c, 1) = 1;
%         if mod(c, 10000) == 0
%             imshow(I_show(1:end, c-9999: c, :))
%             ginput(1);
%         end
    end
    r = r + 1;
end
centers = centers(2:end); % eliminates the constant starting column
centers = flip(size(I_, 1) - centers); % flips in two directions

% for i = 1: 300: size(I_show, 2)
%     
%     if i + 5000 > size(I_show, 2)
%         break
%     end
%     imshow(I_show(1:end, i: i + 5000, :))
% %     pause(0.5)
%     
% end

P = polyfit(1:cols*n_rev, centers, 1);
line = polyval(P, 1:cols*n_rev);
figure(3), plot(centers, 'b'), hold on, plot(line, 'r')
time = 1/78 * n_rev * 60; % 1/(revxmin) * rev * s/min = s
Fs = cols*n_rev/time; % samples / s = hz

soundsc(centers-line, Fs)