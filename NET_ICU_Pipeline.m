%% NET_ICU Pipeline
% This code is still in progress and not a final version
% Resonsible authors: 
% Miriam Han 
% Charlotte Maschke

%% Define Parameters
% wPLI and dPLI parameters
frequencies = ["alpha"]; % This can be ["alpha" "theta" "delta"]
window_size = 20; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 10; % Number of surrogate wPLI to create / # of permutations
p_value = 0.05; % the p value to make our test on
step_size = window_size;



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

    %% wPLI analysis for alpha and theta frequencies
    for fr = 1:length(frequencies) 
        frequency = frequencies(fr); 
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
        
        %labels = struct2cell(struct('labels', {result_wpli.metadata.channels_location.labels}));
        %plot_wPLI(result_wpli.data.avg_wpli, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'wPLI'),labels)

        % Calculate the dpli
        disp(strcat("Participant: ", ID , "_dPLI"));
        result_dpli = na_dpli(recording, frequency_band, window_size, step_size, number_surrogate, p_value);
        %labels = struct2cell(struct('labels', {result_dpli.metadata.channels_location.labels}));
        %plot_dPLI(result_dpli.data.avg_dpli, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'dPLI'),labels)
        
        for h = 1:length(hemispheres)
            hemisphere = hemispheres(h);

            % get subset of channels in one hemisphere 
            %Subset_hem = readtable('utils/EGI128_' + hemisphere + 'Hemisphere.txt');
            %Subset_hem = Subset_hem.Electrode;
            
            % only keep the channels in the hemispere and reorder them
            % according the indicated file
            pattern_file = "biapt_egi129_" + hemisphere + ".csv";
            
            % reorder average wpli
            data = result_wpli.data.avg_wpli;
            channels = {result_wpli.metadata.channels_location.labels};
            [ro_wpli, ~, ro_w_regions] = filter_and_reorder_channels(data,channels,pattern_file);

            % reorder average dpli
            data = result_dpli.data.avg_dpli;
            channels = {result_dpli.metadata.channels_location.labels};
            [ro_dpli, ~, ro_d_regions] = filter_and_reorder_channels(data,channels,pattern_file);

            % define new outdir
            outdir = fullfile(resultsfolder , ID, hemisphere);
            mkdir(fullfile(outdir,'wPLI'));
            mkdir(fullfile(outdir,'dPLI'));
            
            plot_wPLI(ro_wpli, ID, frequency, task, hemisphere, fullfile(outdir,'wPLI'),ro_w_regions)
            plot_dPLI(ro_dpli, ID, frequency, task, hemisphere, fullfile(outdir,'dPLI'),ro_d_regions)

        end
    end
end    

