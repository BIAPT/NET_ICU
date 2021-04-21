% NeuroAlgo_Miriam
%% Add Path to NeuroAlgo matlab function folders
%% Load clean EEG data set
%% Create folders to save analyzed figures

filename = input('State the filename of the patient: ','s'); % Input the patient's filename, format: NET_ICU_000_MG or MW)
possible_states = ["Sedon1","Sedoff","Sedon2"]; % Three possible states of the patients
hemispheres = ["Left", "Right", "Whole"];

num_of_state = input('Enter the number of patient states: '); % Input number of patient states we need to analyze
states = strings(num_of_state,1);

one_hemis = ["wPLI","dPLI"];
whole_hemis = ["Graph Theory", "Spectrogram", "Topographic map"];
%whoo = ['1','2','3']
%who = [1,2,3]

% create folders to save the data generated
for i=1:num_of_state
    number = input('Type 1 for sedon 1, 2 for sedoff, 3 for sedon2 => ') % select the states that needs to be analyzed
    states(i) = possible_states(number)
    for ii = 1:length(hemispheres)
        hemisphere = hemispheres(ii)
        if ii ~= 3
            for iii = 1:length(one_hemis)
                pli = one_hemis(iii)
                mkdir(fullfile(filename, states(i), hemisphere, pli))
            end
        else 
            for iiii = 1:length(whole_hemis)
                analysis = whole_hemis(iiii)
                %analysis2 = num2str(whoo(iiii))
                mkdir(fullfile(filename, states(i), hemisphere, analysis))
              %  mkdir(fullfile(filename, states(i), hemisphere, analysis2))
            end    
        end
    end
end
%%
mkdir(fullfile(filename, 'Sedon1', 'Whole', '3'))

%% wPLI parameters
frequency_bands = [4 7; 8 11]; % This is theta and alpha frequency in Hz 
window_size = 10; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 20; % Number of surrogate wPLI to create / # of permutations
p_value = 0.05; % the p value to make our test on
step_size = window_size;

%% wPLI analysis for alpha and theta frequencies
for i = 1:2
    result_wpli = na_wpli(recording, frequency_bands(i,:), window_size, step_size, number_surrogate, p_value);
    for ii = 1:4
        figure(ii);clf;hold on;
        set(gca, 'FontSize', 12);
        xlabel ('Electrodes'); ylabel ('Electrodes');
        title ('Average wPLI');
        imagesc(result_wpli.data.avg_wpli)
        %grid on
        colorbar;
        colormap(jet);
        
        % adjust the colorbar
        if ii == 1
            caxis ([0 0.1]);
        elseif ii == 2
            caxis ([0 0.215]);
        elseif ii == 3
            caxis ([0 0.22]);
        else 
            caxis ([0 0.25]);
        end  
       
        % save the file with the appropriate name
        if i==1
            figure_title = ['Theta_wPLI_', num2str(ii)];
        else 
            figure_title = ['Alpha_wPLI_', num2str(ii)];
        end
        saveas(figure(ii), figure_title, 'jpg')
        pause(5);
        % path of the figure added in front of the title
    end
end

%% dPLI parameters
frequency_bands = [4 7; 8 11]; % This is theta and alpha frequency in Hz 
window_size = 10; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 20; % Number of surrogate wPLI to create / # of permutations
p_value = 0.05; % the p value to make our test on
step_size = window_size;
%% dPLI analysis for alpha and theta frequencies
for i = 1:2
    result_dpli = na_dpli(recording, frequency_bands(i,:), window_size, step_size, number_surrogate, p_value);
    for ii = 1:4
        figure(ii);clf;hold on;
        set(gca, 'FontSize', 12);
        xlabel ('Electrodes'); ylabel ('Electrodes');
        title ('Average dPLI');
        imagesc(result_dpli.data.avg_dpli)
        %grid on
        colorbar;
        colormap(jet);
        
        % adjust the colorbar
        if ii == 1
            caxis ([0.45 0.55]);
        elseif ii == 2
            caxis ([0.4 0.6]);
        elseif ii == 3
            caxis ([0.35 0.65]);
        else 
            caxis ([0.2 0.7]);
        end
       
        % save the file with the appropriate name
        if i==1
            figure_title = ['Theta_dPLI_', num2str(ii)];
        else 
            figure_title = ['Alpha_dPLI_', num2str(ii)];
        end
        saveas(figure(ii), figure_title, 'jpg')
        pause(5);
        % path of the figure added in front of the title
    end
end
