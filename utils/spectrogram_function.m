% Spectrogram
% Compute, plot, and save Spectrogram
% By: Miriam Han June 23rd, 2021

function spectrogram_fig = spectrogram_function(EEG,spectopo_prp, ID, task, outdir)
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
    %y_avg = y(:,:,
    % Average by the electrodes
    %for i = 1: length(y(:,:,1))
        
    %end
    

    % Plot Spectogram
    caxis_range = [-25 25; -30 30]; % color bar limits
    mkdir(fullfile(outdir)); % create the outdirectory to save the figures

    % squeeze (reduce the x1 )
    % averaging over the electrodes (3d -> 2d) 
    
    for color_bar_ranges = 1: length(caxis_range)
            disp(['Calculating Spectrogram #', num2str(color_bar_ranges)])
            spectrogram_fig = figure(color_bar_ranges);
            plot_matrix(y(:,:,1), t, f);
            
            % label
            title(strcat(ID,' - ',task,'- Spectrogram: Average of all electrodes'));
            ylabel('Frequency','fontsize',12);
            xlabel('Time','fontsize',12);
            colormap(jet);
            caxis(caxis_range(color_bar_ranges,:));
            %movegui(spect_plot,'west');
            set(0,'DefaultFigureVisible','on'); % able output to screen
            
            % Save Spectogram
            figure_name = strcat('Spectrogram-',ID,'-',task,'-',"Whole",'-',num2str(color_bar_ranges));
            saveas(figure(color_bar_ranges),fullfile (outdir, figure_name), 'jpg');
            % save(figure(color_bar_ranges),fullfile (outdir, figure_name));
            pause(1);
            disp('Spectrogram figure successfully saved')
            pause(2);
            close(spectrogram_fig)
    end   
   
        
        
        
   
    
    
    
    
   
    
   
    
   
 