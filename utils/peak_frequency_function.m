% Spectrogram
% Compute, plot, and save Spectrogram
% By: Miriam Han June 23rd, 2021

function peak_fig = peak_frequency_function(EEG, ID, task, outdir)
    % Input
        % EEG: EEG recording 
        % spectopo_prp: spectopo_prp struct
        % ID: patient ID
        % task: patient state (Sedon1, Sedoff, or Sedon2)
        % outdir: outdirectory for saving the spectogram 
        
    % Compute Spectogram
    data = EEG.data'; 
    params.Fs = EEG.sampling_rate;
    %params.trialave = 1;
    
    [pxx,f] = pwelch(data,500,30,500,params.Fs);
    %average over channels
    pxx = mean(pxx,2);
    
    % Plot peak
    mkdir(fullfile(outdir)); % create the outdirectory to save the figures
    peak_fig = figure();
    plot(f,10*log(pxx))
    % label
    title(strcat('Peak-',ID,'-',task),'fontsize',15);
    xlabel('Frequency (Hz)','fontsize',14)
    ylabel('PSD (dB/Hz)','fontsize',14)
    xlim([0,60])
    set(0,'DefaultFigureVisible','on'); % able output to screen

    % Save Peak
    figure_name = strcat('Peak-',ID,'-',task,'-',"Whole");
    saveas(peak_fig, fullfile(outdir, figure_name), 'jpg');
    %save(figure(color_bar_ranges),fullfile (outdir, figure_name),'mat');
    pause(1);
    disp('Peak figure successfully saved')
    pause(2);
    close(peak_fig)
    end   
   
        
        
        
   
    
    
    
    
   
    
   
    
   
 