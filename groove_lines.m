function [BW_line] = groove_lines(BW, col, line)

    % inputs:
    % - BW = binary image
    % - line = groove line of interest (int)
    % - col = columns of binary image that voted for the winning number of lines
    % output:
    % - BW_line = binary image that only contains the line of interest

    
%     [rows, cols] = size(BW);
%     row_indices_matrix = []; % row j will contain the line indices for the j:th column
%     for j = col % loop over the columns that voted for the winning number of lines
%         row_indices = [];
%         for i = 2:rows
%             if BW(i-1, j) == 1 && BW(i, j) == 0
%                 row_indices = [row_indices i-1];
%             end
%         end
%         row_indices_matrix = [row_indices_matrix; row_indices];
%     end
    
    % identifying row indices with line crossing for each column
    % row j will contain the line indices for the j:th column, the
    % resulting matrix will be size = [#col, "correct" nlines].
    [row_indices_matrix, ~] = find(diff(BW(:, col)) == -1);
    row_indices_matrix = reshape(row_indices_matrix, [], length(col))';

    % for each column col(i) with "correct" nlines, find connected
    % components with detected line number line. because bwselect needs a
    % specific point: column is col(i), row is row_indices_matrix(i, line).
    [rows, cols] = size(BW);
    BW_line = zeros(rows, cols);
    for i = 1: length(col)
        BW_temp = bwselect(BW, col(i), row_indices_matrix(i, line));
        BW_line = BW_line | BW_temp;
    end
    
    % interpolation to remove line discontinuities
    % we can see the line as a 1D function where row is f(col).
    y = [];
    for x = 1: cols % for all the columns
        height = find(BW_line(:, x) == 1, 1); % assuming only 1 value per column.
        if ~isempty(height)
            y = [y; [x height]];
        end
    end
    new_heights = round(interp1(y(:, 1), y(:, 2), 1: cols, 'nearest', 'extrap'));

    BW_line = zeros(rows, cols);
    for j = 1: cols
        BW_line(new_heights(j), j) = 1;
    end
    
    % to erase vertical discontinuities
    BW_line = imclose(BW_line, strel('diamond', 3));

end