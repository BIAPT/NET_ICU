% Computate, plot, and save Spectrogram
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
    figure_title = strcat('Spectrogram-',ID,'-',task,'-',"Whole");
    spectrogram = figure;
    plot_matrix(y, t, f);
    
    % labels
    title(strcat('Spectrogram (Average of all electrodes)'));
    ylabel('Frequency','fontsize',12);
    xlabel('Time','fontsize',12);
    colormap(jet);
    movegui(spectrogram,'west');
    set(spectrogram,'CreateFcn','set(gcf,''Visible'',''on'')'); 
    
    % Save Spectogram
    disp(strcat("Participant: ",ID, "_SPECTROGRAM"));
    mkdir(fullfile(outdir,'SPECTROGRAM'));
    saveas(spectrogram,fullfile ('SPECTROGRAM', figure_title), 'jpg');
    close(spectrogram)
    
   
 