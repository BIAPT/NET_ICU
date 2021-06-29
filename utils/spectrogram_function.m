% Spectrogram
% Compute, plot, and save
% By: Miriam Han June 23rd, 2021

function spectrogram = spectrogram_function(EEG,spectopo_prp, ID, task, outdir)
    % Input
        % EEG: EEG recording 
        % spectopo_prp: spectopo_prp struct
        % ID: patient ID
        % task: patient state (Sedon1, Sedoff, or Sedon2)
        % outdir: outdirectory for saving the spectogram 
        
    % Compute Spectogram
    data = EEG.data; 
    params.tapers = [spectopo_prp.timeBandwidth spectopo_prp.numberTaper];
    params.Fs = EEG.srate;
    params.fpass = spectopo_prp.fp;
    params.trialave = 1;
    
    [S, t, f] = mtspecgramcWaitBar(data', [windowLength stepSize], params);
    y = medfilt1(S, spectopo_prp.tso, 2);  % Perform temporal smoothing with a median filter of order tso7
    set(0,'DefaultFigureVisible','off');% disable output to screen

    % Plot Spectogram
    mkdir(fullfile(outdir,'SPECTROGRAM')); % create a folder to save the figures and mat. files
    caxis_range = [-25 25; -30 30]; % color bar limits
    disp(strcat("Participant: ",ID, "_SPECTROGRAM"));
    
    for i = 1: length(caxis_range)
        disp(['Calculating Spectrogram #' num2str(i)])
        figure_title = strcat('Spectrogram-',ID,'-',task,'-',"Whole",'-',i);
        spectrogram = figure(i);
        plot_matrix(y, t, f);
        
        % labels
        title(strcat('Spectrogram (Average of all electrodes)'));
        ylabel('Frequency','fontsize',12);
        xlabel('Time','fontsize',12);
        colormap(jet);
        movegui(spectrogram,'west');
        set(spectrogram,'CreateFcn','set(gcf,''Visible'',''on'')');
        caxis(caxis_range(i));
        
        % Save Spectogram
        saveas(spectrogram,fullfile ('SPECTROGRAM', figure_title), 'jpg');
        close(spectrogram)
        
    end
    
    
   
    
   
    
   
 