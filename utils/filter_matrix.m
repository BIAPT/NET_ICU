function [f_matrix] = filter_matrix(matrix, location, new_location)
% FILTER MATRIX this function take a matrix, it's location structure for
% the channels and a new location & filter out all the channels in the
% matrix that are not in the new location.
%
% matrix: N*N square matrix
% location: 1*N struct array of location (eeglab way)
% new_location: 1*M struct array of location which is smaller than the
% location structure. *a thing to note here is that new_location HAS to be
% a subset of location

    %% Variable Initiatlization
    num_channels = length(new_location);
    good_index = zeros(1, num_channels);
    
    % Iterate over each location in new location and check if we have that
    % location in the old location
    for l = 1:num_channels
        label = new_location{l};
        
        % use this helper to find the location of label in old location
        m_index = get_label_index(label, location);
        
        % Take the index as being good and store it for later indexing
        good_index(l) = m_index;
    end
    
    % Create a subset matrix which will contains only the good value
    f_matrix = matrix(good_index, good_index);
end