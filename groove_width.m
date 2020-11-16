function width = groove_width(BW1, BW2)
    % input:
    % - two binary images with (ideally) only one groove line in each
    % output:
    % - width of the groove
    [rows, cols] = size(BW1);
    top_row = zeros(1, cols);
    bottom_row = zeros(1, cols);
    c_count = 0;
    
    for c = 1: cols
        c_count = c_count + 1;
        hole_top = 0;
        hole_bottom = 0;
        for r = 1: rows
            if BW1(r, c) ~= 0
                top_row(1, c_count) = r;
            else
                hole_top = hole_top+1;
            end
            if BW2(r, c) ~= 0
                bottom_row(1, c_count) = r;
            else
                hole_bottom = hole_bottom+1;
            end    
        end
        if hole_top == rows || hole_bottom == rows
            top_row(1, c_count) = 0;
            bottom_row(1, c_count) = 0;
        end 
    end
    width = bottom_row - top_row;

end