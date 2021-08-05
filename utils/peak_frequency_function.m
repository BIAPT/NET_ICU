% Spectrogram
% Compute, plot, and save Spectrogram
% By: Miriam Han June 23rd, 2021

function peak_fig = peak_frequency_function(EEG,spectopo_prp, ID, task, outdir)
    % Input
        % EEG: EEG recording 
        % spectopo_prp: spectopo_prp struct
        % ID: patient ID
        % task: patient state (Sedon1, Sedoff, or Sedon2)
        % outdir: outdirectory for saving the spectogram 
        
    % Compute Spectogram
    data = EEG.data; 
    params.tapers = [spectopo_prp.timeBandwidth spectopo_prp.numberTaper];
    params.Fs = EEG.sampling_rate;
    params.fpass = spectopo_prp.fp;
    %params.trialave = 1;
    
    % Compute Spectrogram
    % [eegspecdB,freqs,compeegspecdB,resvar,specstd] = spectopof(data, length(data),params.Fs);
    
    % non-overlapping window of 10s
    [S, t, f] = mtspecgramcWaitBar(data', [spectopo_prp.windowLength spectopo_prp.stepSize], params);
    y = medfilt1(S, spectopo_prp.tso, 2);  % Perform temporal smoothing with a median filter of order tso7
    
    % Averaged over all the electrodes and time
    averaged_y_time = squeeze(mean(y,1));
    averaged_y_space = squeeze(mean(averaged_y_time,2));

    % Plot Spectogram
    mkdir(fullfile(outdir)); % create the outdirectory to save the figures
    
    peak_fig = figure();
    plot(f,log(averaged_y_time));
    
    % label
    title(strcat('Peak-',ID,'-',task),'fontsize',15);
    ylabel('Power','fontsize',14);
    xlabel('Frequency','fontsize',14);
    set(0,'DefaultFigureVisible','on'); % able output to screen
    axis square;

    % Save Spectogram
    figure_name = strcat('Peak-',ID,'-',task,'-',"Whole");
    saveas(figure(color_bar_ranges),fullfile (outdir, figure_name), 'jpg');
    %save(figure(color_bar_ranges),fullfile (outdir, figure_name),'mat');
    pause(1);
    disp('Peak figure successfully saved')
    pause(2);
    close(peak_fig)
    end   
   
        
        
        
   
    
    
    
    
   
    
   
    
   
 