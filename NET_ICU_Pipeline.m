%% NET_ICU Pipeline
% This code is still in progress and not a final version
% Resonsible authors: 
% Miriam Han 
% Charlotte Maschke

%% Define Parameters
% wPLI and dPLI parameters
frequencies = ["alpha" "theta"]; % This can be ["alpha" "theta" "delta"]
window_size = 10; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 20; % Number of surrogate wPLI to create / # of permutations
p_value = 0.05; % the p value to make our test on
step_size = window_size;

% HUB parameters
% threshold can be either an float between 0 and 1 for an absolute threshold or "MSG" standing for minimally
% spanning graph. If "MSG" is used, you need to define the range of thrsholds
threshold = "MSG"; % Minimally Spanning graph OR a value between 0 to 1
threshold_range = 0.90:-0.01:0.01; % used ONLY if MSG More connected to less connected

%% Load clean EEG data set
% select the folder with the 
waitfor(msgbox('Select the folder which contains the data in BIDS format.'));
datafolder=uigetdir(path);

waitfor(msgbox('Select the Saving directory'));
resultsfolder = uigetdir(path);

cd(datafolder)
cd("eeg")
files = dir('*.set*');
    
for f = 1:numel(files)
    %% Load data and get information about the state
    recording = load_set(files(f).name,pwd);
    sampling_rate = recording.sampling_rate;
    info = split(files(f).name,'_');
    ID = info{1}(5:end);
    task = info{2}(6:end);
    hemispheres = ["Left", "Right","Whole"];

    disp("load complete: " + ID + '_' + task)
    
    %% Spectrogram 
    spectopo_prp = spectopo_prp_struct;
    disp('spectopo_prp load complete')
    outdir_spectrogram = fullfile(resultsfolder, ID,"Whole",'Spectrogram');
    spectrogram = spectrogram_function(recording, spectopo_prp, ID, task, outdir_spectrogram);
    
    %% Topographic Maps of Alpha and Theta Power
    outdir_topographicmap = fullfile(resultsfolder, ID, "Whole",'Topographic Maps');
    topographic_map = topographic_map_function(recording, spectopo_prp, ID, task, outdir_topographicmap);

    %% wPLI analysis for alpha and theta frequencies
    for fr = 1:length(frequencies) 
        frequency = frequencies(fr); 
        
        outdir = fullfile(resultsfolder , ID);
        mkdir(fullfile(outdir,'fc_data'));
        participant_out_path_wpli = strcat(fullfile(outdir,'fc_data'),filesep,'wpli_',frequency,'_',ID,'_',task,'.mat');            
        participant_out_path_dpli = strcat(fullfile(outdir,'fc_data'),filesep,'dpli_',frequency,'_',ID,'_',task,'.mat');            

        if frequency == "alpha"
            frequency_band = [8 13]; % This is in Hz
        elseif frequency == "theta"
            frequency_band = [4 8]; % This is in Hz
        elseif frequency == "delta"
            frequency_band = [1 4]; % This is in Hz
        end
        
        %% Calculate Results for whole brain:
        
        % Calculate the wpli
        disp(strcat("Participant: ", ID , "_wPLI"));
        result_wpli = na_wpli(recording, frequency_band, window_size, step_size, number_surrogate, p_value);

        % Calculate the dpli
        disp(strcat("Participant: ", ID , "_dPLI"));
        result_dpli = na_dpli_corrected(recording, frequency_band, window_size, step_size, number_surrogate, p_value);
        
        %% Save wPLI and dPLI for later Matlab and Python use
        % save dPLI and wPLI for later in Matlab
        save(participant_out_path_wpli,'result_wpli')
        save(participant_out_path_dpli,'result_dpli')
        
        %save wPLI and dPLI in an easier format for python
        % add a 'py' at the end for python
        participant_out_path_wpli = strcat(fullfile(outdir,'fc_data'),filesep,'wpli_',frequency,'_',ID,'_',task,'py.mat');            
        participant_out_path_dpli = strcat(fullfile(outdir,'fc_data'),filesep,'dpli_',frequency,'_',ID,'_',task,'py.mat');            
        participant_channel_path_wpli = strcat(fullfile(outdir,'fc_data'),filesep,'channel_wpli_',frequency,'_',ID,'_',task,'py.mat');            
        participant_channel_path_dpli = strcat(fullfile(outdir,'fc_data'),filesep,'channel_dpli_',frequency,'_',ID,'_',task,'py.mat');            
        
        % extract channels and data directly and save
        channels = struct2cell(result_wpli.metadata.channels_location);
        data = result_wpli.data.wpli;
        save(participant_out_path_wpli,'data')
        save(participant_channel_path_wpli,'channels')

        % extract channels and data directly and save
        channels = struct2cell(result_dpli.metadata.channels_location);
        data = result_dpli.data.dpli;
        save(participant_out_path_dpli,'data')
        save(participant_channel_path_dpli,'channels')

        %% Loop over Hemispheres and save images
        for h = 1:length(hemispheres)
            hemisphere = hemispheres(h);
            
            % only keep the channels in the hemispere and reorder them
            % according the indicated file
            pattern_file = "biapt_egi129_" + hemisphere + ".csv";
            
            %% reorder and save wPLI and dPLI
            % reorder average wpli
            data = result_wpli.data.avg_wpli;
            channels = result_wpli.metadata.channels_location;
            [ro_wpli, ro_w_channels, ro_w_regions] = filter_and_reorder_channels(data,channels,pattern_file);

            % reorder average dpli
            data = result_dpli.data.avg_dpli;
            channels = result_dpli.metadata.channels_location;
            [ro_dpli, ro_d_channels, ro_d_regions] = filter_and_reorder_channels(data,channels,pattern_file);

            % define new outdir
            outdir = fullfile(resultsfolder , ID, hemisphere);
            mkdir(fullfile(outdir,'wPLI'));
            mkdir(fullfile(outdir,'dPLI'));
            
            plot_wPLI(ro_wpli, ID, frequency, task, hemisphere, fullfile(outdir,'wPLI'),ro_w_regions)
            plot_dPLI(ro_dpli, ID, frequency, task, hemisphere, fullfile(outdir,'dPLI'),ro_d_regions)

            %% calculate and save HUB
            disp(strcat("Participant: ", ID , "_HUB"));

            if isfloat(threshold)
                finalthreshold = threshold;
                [b_wpli] = binarize_matrix(threshold_matrix(ro_wpli, finalthreshold));
            elseif threshold == "MSG"
                [finalthreshold] = find_smallest_connected_threshold(ro_wpli, threshold_range);
                [b_wpli] = binarize_matrix(threshold_matrix(ro_wpli, finalthreshold));
            else
                disp("HUB can not be calculated! Threshold input incorrect. Please enter either a float or a string MSG ")
            end
            % here we are using only the degree and not the betweeness centrality
            [~, hub_weights] = binary_hub_location(b_wpli, ro_w_channels,  1.0, 0.0);
            % normalize hub to z-score
            hub_norm_weights = (hub_weights - mean(hub_weights)) / std(hub_weights);
            
            mkdir(fullfile(outdir,'HUB'));
            plot_hub(hub_norm_weights, ID, frequency, task, hemisphere, fullfile(outdir,'HUB'), ro_w_channels)

        end
    end
end  