% 1. read cuts
cuts = {dir('data/cut/*.mat').name};
n = length(cuts);
cut_image = [];

for i = 2: n
    
    load(strcat('data/cut/', cuts{i}))
    [nr_of_lines, col] = line_counter(cut_image);
    
    if nr_of_lines ~= 12
        sprintf('i %d nr_of_lines %d', i, nr_of_lines)
    end
    
    fig = figure(1);
    for line = 1: 2: nr_of_lines
        l1 = groove_lines(cut_image, col, line);
        l2 = groove_lines(cut_image, col, line+1);
        width = groove_width(l1, l2);
        pause(0.1)
        subplot(2, 1, 1), imshow(l1 | l2), title(['image' ' ' num2str(i)]), 
        subplot(2, 1, 2), plot(width), xlim([0 650]), ylim([0 20])
        title('Groove width'), ylabel('Vertical pixel distance'), xlabel('Column')
        if bwconncomp(l1 + l2).NumObjects > 2
            sprintf('i %d line %d', i, line)
        end
        saveas(fig, ['animation/' num2str(i) '_' num2str(line)], 'png')
    end
end