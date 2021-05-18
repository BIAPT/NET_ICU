%% NET_ICU Pipeline
% This code is still in progress and not a final version
% Resonsible authors: 
% Miriam Han 
% Charlotte Maschke

%% Define Parameters
% wPLI and dPLI parameters
frequencies = ["alpha"]; % This can be ["alpha" "theta" "delta"]
window_size = 10; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 20; % Number of surrogate wPLI to create / # of permutations
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
    hemispheres = ["Left", "Right"];

    disp("load complete: " + ID + '_' + task)

    %% wPLI analysis for alpha and theta frequencies
    for frequency = 1:length(frequencies) 
        if frequencies(frequency) == "alpha"
            frequency_band = [8 13]; % This is in Hz
        elseif frequencies(frequency) == "theta"
            frequency_band = [4 8]; % This is in Hz
        elseif frequencies(frequency) == "delta"
            frequency_band = [1 4]; % This is in Hz 
        end
        
        %% Calculate Results for whole brain: 
        hemisphere = "Whole";
        outdir = fullfile(resultsfolder , ID, hemisphere);
        mkdir(fullfile(outdir,'wPLI'));
        mkdir(fullfile(outdir,'dPLI'));
        
        % Calculate the wpli
        disp(strcat("Participant: ", ID , "_wPLI"));
        result_wpli = na_wpli(recording, frequency_band, window_size, step_size, number_surrogate, p_value);
        labels = struct2cell(struct('labels', {result_wpli.metadata.channels_location.labels}));
        plot_wPLI(result_wpli.data.avg_wpli, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'wPLI'),labels)

        % Calculate the dpli
        disp(strcat("Participant: ", ID , "_dPLI"));
        result_dpli = na_dpli(recording, frequency_band, window_size, step_size, number_surrogate, p_value);
        labels = struct2cell(struct('labels', {result_dpli.metadata.channels_location.labels}));
        plot_dPLI(result_dpli.data.avg_dpli, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'dPLI'),labels)

        % Calculate the Hub-DRI
        disp(strcat("Participant: ", ID , "_HUB"));
        % TODO
        
        for i = 1:length(hemispheres)
            hemisphere = hemispheres(i);
            location = result_wpli.metadata.channels_location;
            location = {location.labels};
            
            % get subset of channels 
            Subset_hem = readtable('utils/EGI128_' + hemisphere + 'Hemisphere+Midline.txt');
            Subset_hem = struct2cell(reshape(table2struct(Subset_hem),1,[]));

            % find overlap between recording and subset
            common_labels = intersect(location,Subset_hem, 'stable');
            common_labels = reshape(common_labels,1,[]);
            
            % filter the data
            wpli_hem = filter_matrix(result_wpli.data.avg_wpli,location, common_labels);
            dpli_hem = filter_matrix(result_dpli.data.avg_dpli,location, common_labels);
            
            % define new outdir
            outdir = fullfile(resultsfolder , ID, hemisphere);
            mkdir(fullfile(outdir,'wPLI'));
            mkdir(fullfile(outdir,'dPLI'));
            
            plot_wPLI(wpli_hem, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'wPLI'),common_labels)
            plot_dPLI(wpli_hem, ID, frequencies(frequency), task, hemisphere, fullfile(outdir,'dPLI'),common_labels)

        end
    end
end    

