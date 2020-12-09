function [Opimg, maxs] = stitcher(I, J, boundary)

    % I = rgb2gray(I);
    % J = rgb2gray(J);

    I = im2double(I);
    J = im2double(J);
    [rows, cols, ~] = size(J);

    block_side = 5;
    J_start = 5;
    J_tmp = J(:, J_start: J_start+block_side-1);
    coeffs = [];
    max_delay = 0;
    for j = (boundary-50): (boundary+50)
        
%         mask = false(size(J));
%         mask(:, 5: 5+block_side-1) = true;
        
%         J_r = imrotate(J, -j/size(I, 2)*3.17, 'crop');
%         maskR = imrotate(mask, -j/size(I, 2)*3.17, 'crop');
        
        I_tmp = I(:, j: j+block_side-1);
        d = finddelay(I_tmp, J_tmp, max_delay);
        d = round(mean(d));
        
        J_d = zeros(size(J_tmp, 1) + abs(d), block_side);
        if d > 0
            J_d(1: rows-d, :) = J_tmp(1+d: rows, :);
        else
            J_d(1-d: rows, :) = J_tmp(1: rows+d, :);
        end
        
        c = [];
        for col = 1: block_side
            c(:, col) = xcorr(I_tmp(:, col), J_d(:, col));
        end
        % max will be at 0 displacement (position size(J_d, 1))
        c_max = max(c(size(J_d, 1), :));
        coeffs = [coeffs [c_max; d]];
    end
    [max_corr, index] = max(coeffs(1, :));
    d_max = coeffs(2, index);
    maxs = [max_corr; d_max];
%     disp(index)
%     disp(max_corr)

    index = index + (boundary-50);

    n_cols = index + cols - 1 - J_start+1; % new column of output image
    
%     Opimg(1: size(I, 1), 1: index-1, :) = I(:, 1: index-1, :);
    Opimg(1: size(I, 1), 1: index-1, :) = I(:, 1: index-1, :);

    if d_max > 0
        Opimg(1: rows-d_max, index: n_cols, :) = J(1+d_max: rows, J_start:end, :);
    else
        Opimg(1-d_max: rows, index: n_cols, :) = J(1: rows+d_max, J_start:end, :);
    end

end