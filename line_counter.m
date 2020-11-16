function [nr_of_lines, col] = line_counter(BW)
    % returns:
    % - nr_of_lines = the hypothesized number of groove lines in image
    % - col = the columns of the image that voted for the winning number of groove lines
    
    lines = sum(abs(diff(BW)) == 1)/2; % -1 is when goes from 1 to 0
    nr_of_lines = mode(lines);
    col = find(lines == nr_of_lines);

%     [rows, cols] = size(BW);
%     lines = [];
%     for j = 1: cols
%         lines_temp = 0;
%         for i = 2: rows
%             if BW(i-1, j) == 1 && BW(i, j) == 0
%                 lines_temp = lines_temp+1;
%             end
%         end
%         lines = [lines lines_temp];
%     end
%     nr_of_lines = mode(lines);
%     col = find(lines == nr_of_lines); %columns with correct number of lines
    
    
end