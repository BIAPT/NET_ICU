% Modifying functions spectopo_function 
% By: Miriam Han

function errors = spectopo_function(EEG,spectopo_prp,workingDirectory,check_data,isWarning)
    % EEG: EEG recording 
    
    % Spectrogram parameters: 
    
    fp = [0.1 50]; % Frequency pass of [high_pass low_pass]
    stepSize = 0.1; % The step length over which to move the window.
                    % Was set to 0.1 in the previous code (NEED TO CHECK)
                    
    tso = 4; % Temporal smoothing median filter order (reduces the noise)
    
    numberTaper = spectopo_prp.numberTaper;
    timeBandwidth = spectopo_prp.timeBandwidth; 
    
    %timeBandwidth product and numberTaper
        % should generally set the nubmer of tapers to be 2 x (time-bandwidth product-1)
        % using more tapers will include tapers with poor concentration in the
        % speciied frequency bandwidth (chronux documentation for more info)
   
    windowLength = recording. % The length of window for spectrum to be calculated. 
    %windowLength = spectopo_prp.windowLength; 
    
    % Topographic Map Parameters:
    freqidx = (2*frequencies) + 1; % NOT quite sure what this is.
    frequencies = [4 5 6 7 8 9 10 11 12 13]; % Frequencies of the topographic map from 4 to 13Hz. 

    %% spectopo_prp struct
    spectopo_prp = struct('fp',fp,'tso',tso,'timeBandwidth',timeBandwidth,...
   'numberTaper',numberTaper,'windowLength',windowLength,'stepSize',stepSize,...
   'freqidx',freqidx,'frequencies',frequencies,'print_spect',1,...
   'save_spect',0,'print_topo',1,'save_topo',0);

    % Preparing print/save for spectopo
    print_spect = spectopo_prp.print_spect;
    save_spect = spectopo_prp.save_spect; 
    print_topo = spectopo_prp.print_topo; 
    save_topo = spectopo_prp.save_topo; 
    
    %% Directory for saving 
    % Create a directory if it doesn't exist to save data        
    if ~exist(strcat(workingDirectory,['/' EEG.filename]),'dir') && (save_topo == 1 || save_spect == 1)
        mkdir(workingDirectory,EEG.filename);
    end
    savingDirectory = [workingDirectory '/' EEG.filename];
    
    %Compute Spectrogram
    data = EEG.data; 
    params.tapers = [timeBandwidth numberTaper];
    params.Fs = EEG.srate;
    params.fpass = fp;
    params.trialave = 1;
    
    [S, t, f] = mtspecgramcWaitBar(data', [windowLength stepSize], params);

    y = medfilt1(S, tso, 2);  % Perform temporal smoothing with a median filter of order tso7
    set(0,'DefaultFigureVisible','off');% disable output to screen

    %Create the figure for the spectrogram
    spect_plot = figure;
    plot_matrix(y, t, f);
    
    % title: patient name + state + Spectrogram
    title(strcat(EEG.filename,' Spectrogram(Average of all electrodes)'));
    ylabel('Frequency','fontsize',12);
    xlabel('Time','fontsize',12);
    colormap(jet);
    caxis ([-27 29]); % NEED to discuss the value
    movegui(spect_plot,'west');
    
    %Save it to right directory
    if save_spect == 1
       %we create the right directory and concatenaate the right name          
       if ~exist(strcat(savingDirectory,'/Spectrogram'),'dir')
            mkdir(savingDirectory,'Spectrogram');
       end
       figName = '/Spectrogram/';
       figName = strcat(figName,datestr(now, 'dd-mmm-yyyy'));
       figName = strcat(figName,'_');
       figName = strcat(figName,datestr(now, 'HH-MM-SS'));
                   
       %Make the log string name
       logName = strcat(figName,'_input.txt');
       dataName = strcat(figName,'_data.mat');
       figName = strcat(figName,'.fig');
       
       set(spect_plot,'CreateFcn','set(gcf,''Visible'',''on'')');    
       saveas(spect_plot,[savingDirectory figName]);
       set(spect_plot,'CreateFcn','set(gcf,''Visible'',''off'')');
       data_path = [savingDirectory dataName];
       save(data_path,'y','t','f');
       
       %Log the inputs
       fid = fopen([savingDirectory logName],'w+');
       fprintf(fid,'File Name: %s\n',EEG.filename);    
       fprintf(fid,'Frequency Pass : [%.2fHZ %.2fHZ]\n',fp(1,1),fp(1,2));
       fprintf(fid,'Temporal Smoothing Median Filter : %d\n',tso);
       fprintf(fid,'Time-Bandwidth Product : %d\n',timeBandwidth);
       fprintf(fid,'Number of Tapers : %d\n',numberTaper);
       fprintf(fid,'Windows Length : %d seconds\n',windowLength);
       fprintf(fid,'Step size : %.2f\n',stepSize);
       fclose(fid);
    end
 
    % Load variables for 'Topographic Map'
    freqidx = spectopo_prp.freqidx; 
    frequencies = spectopo_prp.frequencies; 
    
    % Problem // Don't know why this was labelled problem
   [eegspecdB,freqs,compeegspecdB,resvar,specstd] = spectopo(EEG.data,length(EEG.data),EEG.srate,'chanlocs', EEG.chanlocs,'freqfac',2,'plot','off');

    % Calculate the topographic map
    lfidx = length(freqidx);
    for i=1:lfidx
        topodata(:,i) = eegspecdB(:,freqidx(1,i)) - mean(eegspecdB(:,freqidx(1,i)));
    end
    
    % Prepare the rows and columns needed for the subplots
    % NEED TO DISCUSS: how should the subplots be plotted
        % 1. alpha vs theta? (theta on top and alpha on the bottom?)
        % 2. since its 10 diff frequencies, 5 on each row?
    
    mapframes = 1:size(eegspecdB,1);
    if lfidx == 1
        rows = 1;
        cols = 1;
    elseif lfidx == 2
        rows = 1;
        cols = 2;
    else
       rows = 2;
       cols = 2;
    end
    
    % Here we make the plot
    topo_plot = figure;
    for i=1:lfidx
        subplot(rows,cols,i);
        disp(['Calculating Topographic Map #' num2str(i)])
        topoplot(topodata(mapframes,i),EEG.chanlocs,'maplimits','absmax', 'electrodes', 'off');
        title_text = num2str(frequencies(i));
        title([title_text 'Hz']);
        colorbar;
    end
    movegui(topo_plot,'east');
    
    %Here we save the topographic map in the right directory
    if save_topo == 1
       if ~exist(strcat(savingDirectory,'/TopographicMap'),'dir')
            mkdir(savingDirectory,'TopographicMap');
       end
       figName = '/topographicMap/';
       figName = strcat(figName,datestr(now, 'dd-mmm-yyyy'));
       figName = strcat(figName,'_');
       figName = strcat(figName,datestr(now, 'HH-MM-SS'));
       
       %Make the log string name
       logName = strcat(figName,'_input.txt');
       dataName = strcat(figName,'_data.mat');
       figName = strcat(figName,'.fig');
       set(topo_plot,'CreateFcn','set(gcf,''Visible'',''on'')');   
       saveas(topo_plot,[savingDirectory figName]) ;
       set(topo_plot,'CreateFcn','set(gcf,''Visible'',''off'')');
       data_path = [savingDirectory dataName];
       save(data_path,'topodata');       
       
       fid = fopen([savingDirectory logName],'w+');
       fprintf(fid,'File Name: %s\n',EEG.filename);
       fprintf(fid,'Frequencies : ');
       if(size(frequencies) <= 4)
            fprintf(fid,' %d',frequencies(:,:));
       else
           fprintf(fid,' %d',frequencies(:,1:4));
       end
       fclose(fid);
    end
    
    %Here we show the output to the screen
    set(0,'DefaultFigureVisible','on');

    if print_spect == 1 || check_data == 1
        figure(spect_plot)
    end
    
    if print_topo == 1 || check_data == 1
        figure(topo_plot)
    end
    
    %Here we output a warning to the screen (only if there has been no
    %warning outputted to the screen)
    if isempty(warningLabel) == 0
        if isWarning == 0
            w = msgbox(warningLabel,'Warning!');
            movegui(w,'north');
            assignin('base','isWarning',1);
        end
    end
    
catch Exception
     errors = 1;
     disp(Exception.getReport());
     return
end    

end