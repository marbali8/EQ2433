function [S] = straighten(BW, black)
    
    if length(size(BW)) ~= 2
        return
    end
    
    % 1. pre-cut
    BW = BW(1: black, :);
    [m, n] = size(BW);

    x_tuning = 0; %tuning parameter which can be changed until desired result which never happens.
    theta_tuning = atan((x_tuning/207)/53); %tuning angle in radians

    %theta_displacement = atan(((m-x_tuning)/207)/53) + theta_tuning; %the maximum change of theta in radians
    theta_displacement = 0.055;
    delta_theta = theta_displacement/n; %one column corresponds to this change in angle

    r_min = 53; %minimum radius in mm
    if x_tuning <= n/2
        r_max = sqrt((53 + m/207)^2 + ((m-x_tuning)/207)^2); %maxmimum radius
    else
        r_max = sqrt((53 + m/207)^2 + (x_tuning/207)^2);
    end
    r_displacement = r_max - r_min; %the maximum change of radius in mm
    delta_r = r_displacement/m; %one row corresponds to this change in radius

    r_values = 53 + (0:m-1)*delta_r;
    theta_values = -theta_tuning + (0:n-1)*delta_theta;

    S = zeros(m,n);

    for i=1:m
        y = 53 + (i-1)/207; %y-coordinate of position in mm
        for j = 1:n
            x = ((j-1) - x_tuning)/207; %x displacement from center in mm. negative if (j-1) < x_tuning
            r = sqrt((x^2 + y^2));
            theta = asin(x/r);
            %see which value of theta_values is closest to theta
            [~, col] = min(abs(theta_values - theta));
            %see which value of r_values is closest to r
            [~, row] = min(abs(r_values - r));
            %move the point at position (i,j) in old image to new position (r,theta) in the new image
            S(row, col) = BW(i,j);
        end
    end
end