% % DEFINITIVE third step (0. run stitching.m) (I is the stitched image)

% if it's not ran in main.mlx, doesn't work because there are no
% data to detect (n_rev and groove_h and init_rev_col).

% 1. define constants
I_ = I;
% I_ = imgaussfilt(I, [1e-5 0.9]);
% I_ = imgaussfilt(I, [1e-5 0.4]);

I_show = zeros(size(I_, 1), size(I_, 2), 3);
I_show(:, :, 3) = I_;
[rows, cols] = size(I_);
% centers = [init_rev_col zeros(1, cols*n_rev)];
centers = [init_rev_col zeros(1, cols*n_rev)];
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
        else
            centers(c+1+cols*(r-1)) = centers(c+cols*(r-1)) + i - groove_h - floor(groove_h/2); % - length filter - first half of filter + start
        end
        maxs(c+cols*(r-1)) = m;
    %     plot(c, centers(c+1), 'r.', 'MarkerSize', 2), hold on
        I_show(centers(c+1+cols*(r-1))-1:centers(c+1+cols*(r-1))+1, c, 1) = 1;
%         if mod(c, 10000) == 0
%             imshow(I_show(1:end, c-9999: c, :))
%             ginput(1);
%         end
    end
    r = r + 1;
end
centers = centers(2:end); % eliminates the constant starting column
centers = flip(size(I_, 1) - centers); % flips in two directions

show = strcmp(input('show grooves over image? [y/n] ', 's'), 'y');
if show
    for i = 1: 300: size(I_show, 2)

        if i + 5000 > size(I_show, 2)
            break
        end
        imshow(I_show(:, i: i + 5000, :))
%         pause(0.5)

    end
end

% here it looks like a tilted sinusoid (tilted bc of the revolutions,
% sinusiodal bc of off-centered black center), so we try to first correct
% the tilt and then remove the sinusoid
x = 1:cols*n_rev;
P = polyfit(x, centers, 1);
line = polyval(P, x);
straight = centers - line;

dc = mean(straight);
amp = (max(straight) - min(straight))/2;
phase = n_rev;
phase_shift = 0;

straight_fitted = NonLinearModel.fit((x/max(x)*2*pi)', straight', ...
    'y ~ b0 + b1*sin(b2*x1 + b3)', [dc, amp, phase, phase_shift]).Fitted;
new = straight-straight_fitted';

plot_x = 2*pi*n_rev/length(x)*x;
figure(3), 
plot(plot_x, centers / pixels_per_mm + start_mm, 'b'), hold on, 
plot(plot_x, line / pixels_per_mm + start_mm, 'r'), hold on,
plot(plot_x, straight / pixels_per_mm + start_mm, 'g'), hold on, 
plot(plot_x, straight_fitted' / pixels_per_mm + start_mm, 'm'), hold off
legend('centers', 'regression', 'centers-regression', 'straight fitted')
ylabel('distance from center (mm)'), xlabel('angle (rad)')

% "new" still looks like a (less) tilted (more frequent) sinusoid ("wow" 
% effect), so we try to first correct the tilt and then remove the sinusoid

Ps = polyfit(x, new, 1);
line_s = polyval(Ps, x);
new_straight = new - line_s;

dc_ = mean(new_straight);
amp_ = (max(new_straight) - min(new_straight))/2;
phase_ = 2*n_rev;
phase_shift_ = pi/2;

straight_fitted2 = NonLinearModel.fit((x/max(x)*2*pi)', new_straight, ...
    'y ~ b0 + b1*sin(b2*x1 + b3)', [dc_, amp_, phase_, phase_shift_]).Fitted;

final = new_straight-straight_fitted2';

figure(4), 
plot(plot_x, new_straight / pixels_per_mm + start_mm, 'b'), hold on, 
plot(plot_x, straight_fitted2 / pixels_per_mm + start_mm, 'r'), hold on
plot(plot_x, final / pixels_per_mm + start_mm, 'g'), hold off
legend('new straight', 'new straight fitted', 'new - new fitted')
ylabel('distance from center (mm)'), xlabel('angle (rad)')

% it's already pretty straight

time = 1/78 * n_rev * 60; % 1/(revxmin) * rev * s/min = s
Fs = length(x)/time; % samples / s = hz

% help from https://es.mathworks.com/matlabcentral/answers/36999-how-do-i-regression-fit-a-sinwave-to-a-dataset