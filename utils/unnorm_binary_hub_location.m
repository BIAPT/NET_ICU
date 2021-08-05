function [hub_location, weights] = unnorm_binary_hub_location(b_wpli, location, a_degree, a_bc)
%BETWEENESS_HUB_LOCATION select a channel which is the highest hub based on
%betweeness centrality and degree
% input:
% b_wpli: binary matrix
% location: 3d channels location
% a_degree: weight to put on the degree for the definition of hub
% a_bc: weight to put on the betweeness centrality for the definition of
% hub
%
% output:
% hub_location: This is a number between 0 and 1, where 0 is fully
% posterior and 1 is fully anterior
% weights: this is a an array containing weights of each of the channel in
% the order of the location structure

    %% 1.Calculate the degree for each electrode.
    degree = degrees_und(b_wpli);
    %norm_degree = (degrees - mean(degrees)) / std(degrees);
    
    %% 2. Calculate the betweeness centrality for each electrode.
    bc = betweenness_bin(b_wpli);
    %norm_bc = (bc - mean(bc)) / std(bc);
    
    
    %% 3. Combine the two Weightsmetric (here we assume equal weight on both the degree and the betweeness centrality)
    weights = a_degree*degree + a_bc*bc;
    
    %% Obtain a metric for the channel that is most likely the hub epicenter
    [~, channel_index] = max(weights);
    hub_location = threshold_anterior_posterior(channel_index, location);

end

