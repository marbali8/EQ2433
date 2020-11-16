% 1. read cuts
cuts = {dir('data/cut/*.mat').name};
n = length(cuts);
cut_image = [];

for i = 62: 68 % for i = 2: n
    
    load(strcat('data/cut/', cuts{i}))
    [nr_of_lines, col] = line_counter(cut_image);
    
    if nr_of_lines ~= 12
        sprintf('i %d nr_of_lines %d', i, nr_of_lines)
    end
    
    for line = 1: 2: nr_of_lines
        l1 = groove_lines(cut_image, col, line);
        l2 = groove_lines(cut_image, col, line+1);
        width = groove_width(l1, l2);
        pause(0.1)
        subplot(2, 1, 1), imshow(l1 + l2), title(num2str(i))
        subplot(2, 1, 2), plot(width)
        if bwconncomp(l1 + l2).NumObjects > 2
            sprintf('i %d line %d', i, line)
        end
    end
end