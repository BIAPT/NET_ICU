function [ro_pli, ro_channels, ro_regions] = filter_and_reorder_channels(data,channels,pattern)
    % 
    % By Charlotte Maschke 21.05.2021
    %
    % This function will filter and reorder the FC matrix.
    % INPUT 
    % data: a 2D wPLI or dpLI Matrix
    % channels: an array of channels from the original recording (corresponding to 'data') 
    % Subset_hem: a cell array with the electrodes which want to be kept after 
    %              filtering (corresponding to left, right whole txt file)  
    % pattern: A string indicating the direction of the csv containing area and
    %           electrode ordering example: biapt_egi129_right_left.csv
    %
    % OUTPUT 
    % ro_pli: reordered averaged pli
    % ro_electrodes: selected electrodes in new arrangement
    % ro_region: corresponding regions
    
    pattern = readtable(pattern);
    channels_order = pattern.label;
    regions_order = pattern.region;
    
    channels_origin = {channels.labels};
    
    % Init the return data structure
    ro_indices = [];
    ro_regions = {};

    % a is just an index to append the struct
    for i = 1:length(channels_order)
        c = channels_order{i};
        [~,~,index] = intersect(c, channels_origin);

        % if the electrode is in the pattern file (all but non-brain)
        if  ~isempty(index)
            % as a sanity-check on compare both: 
            if char(channels_origin(index)) ~= char(channels_order(i))
                disp("ERROR: Electrodes not matching!")
            end
            ro_indices = [ro_indices, index];
            ro_regions = [ro_regions, regions_order(i)];
        end
    end
    
    ro_pli = data(ro_indices,ro_indices);
    ro_channels = channels(ro_indices);
end
