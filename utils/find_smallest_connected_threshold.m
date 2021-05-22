
function [smallest_threshold] = find_smallest_connected_threshold(pli_matrix, threshold_range)
    %loop through threshold_range and find the one with the minmally
    %spanning tree
    for j = 1:length(threshold_range) 
        current_threshold = threshold_range(j);
        
        % Thresholding and binarization using the current threshold
        t_network = threshold_matrix(pli_matrix, current_threshold);
        b_network = binarize_matrix(t_network);

        % check if the binary network is disconnected
        % Here our binary network (b_network) is a weight matrix but also an
        % adjacency matrix.
        distance = distance_bin(b_network);

        % Here we check if there is one node that is disconnected
        if(sum(isinf(distance(:))))
            disp(strcat("Final threshold: ", string(threshold_range(j-1))));
            smallest_threshold = threshold_range(j-1);
            break;
        end
    end
end
