% Topographic Map
% Computate, plot, and save 
% By: Miriam Han June 23rd, 2021

function topographic_map = topographic_map_function(EEG,spectopo_prp, ID, task, outdir)
    % Input
        % EEG: EEG recording 
        % spectopo_prp: spectopo_prp struct
        % ID: patient ID
        % task: patient state (Sedon1, Sedoff, or Sedon2)
        % outdir: outdirectory for saving the topographic maps
    
    % Load variables for 'Topographic Map'
    freqidx = spectopo_prp.freqidx; 
    frequencies = spectopo_prp.frequencies;
    
    % Compute Topographic Maps
    [eegspecdB,freqs,compeegspecdB,resvar,specstd] = spectopo(EEG.data,length(EEG.data),EEG.srate,'chanlocs', EEG.chanlocs,'freqfac',2,'plot','off');
    lfidx = length(freqidx);
    for i=1:lfidx
        topodata(:,i) = eegspecdB(:,freqidx(1,i)) - mean(eegspecdB(:,freqidx(1,i)));
    end
    
    % Plot Topographic Maps
    figure_name = strcat('Topographic_Maps-',ID,'-',task,'-',"Whole");
    topographic_map = figure;
    
    for i=1:lfidx
        sgtitle('Topographic Maps of Alpha and Theta Power');
        subplot(2,5,i);
        disp(['Calculating Topographic Map #' num2str(i)])
        topoplot(topodata(mapframes,i),EEG.chanlocs,'maplimits','absmax', 'electrodes', 'off');
        % labels
        title_text = num2str(frequencies(i));
        title([title_text 'Hz']);
        colorbar;
        caxis([-5 5]); % need to discuss the values
        %set(0,'DefaultFigureVisible','on');
    end
   
    % Save Topographic Maps
    disp(strcat("Participant: ",ID, "_Topographic_Maps"));
    mkdir(fullfile(outdir,'Topographic Maps'));
    saveas(topographic_map,fullfile ('Topographic Maps', figure_name), 'jpg');
    close(topographic_map)
    
    
    
    
    
    
    
    

   
    
   
 