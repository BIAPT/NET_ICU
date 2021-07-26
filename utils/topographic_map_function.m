% Topographic Map
% Computate, plot, and save 
% By: Miriam Han June 23rd, 2021

function topographic_map = topographic_map_function(EEG,spectopo_prp, ID, task, outdir)
    % Input  (data type we are looking for: int, array, (formats))
        % EEG: EEG recording 
        % spectopo_prp: spectopo_prp struct (detailed information on what it is supposed to do) 
        % defined in main pipeline*
        % ID: patient ID
        % task: patient state (Sedon1, Sedoff, or Sedon2)
        % outdir: outdirectory for saving the topographic maps
    
    % Load variables for 'Topographic Map'
    freqidx = spectopo_prp.freqidx; 
    frequencies = spectopo_prp.frequencies;
    
    % Compute Topographic Maps
    %[eegspecdB,freqs,compeegspecdB,resvar,specstd] = spectopof(EEG.data,length(EEG.data),EEG.sampling_rate,'chanlocs', EEG.chanlocs,'freqfac',2,'plot','off');
    [eegspecdB,freqs,compeegspecdB,resvar,specstd] = spectopof(EEG.data,length(EEG.data),EEG.sampling_rate);
    
    % Plot Topographic Maps
    caxis_range = [-5 5; -10 10]; % color bar limits
    
    for color_bar_ranges = 1:length(caxis_range) 
        mkdir(fullfile(outdir));
        disp(['Calculating Topographic Map #' num2str(color_bar_ranges)])
        topographic_map = figure(color_bar_ranges);
        figure_name = strcat('Topographic Maps','-',ID,'-',task,'-','Whole','-',num2str(color_bar_ranges));
        %t= tiledlayout(2,6, 'TileSpacing','compact','Padding','compact');
        t= tiledlayout(2,5, 'TileSpacing','compact','Padding','compact');
        title(t,figure_name);
        
        for lfidx=1:length(freqidx)
                topodata(:,lfidx) = eegspecdB(:,freqidx(1,lfidx)) - mean(eegspecdB(:,freqidx(1,lfidx)));
              
                %if lfidx <=5
                    nexttile(lfidx)
                    topoplot(topodata(1:size(eegspecdB,1),lfidx),EEG.channels_location,'maplimits','absmax', 'electrodes', 'off');
               % elseif lfidx>5
                   %nexttile(lfidx+1)
                  % topoplot(topodata(1:size(eegspecdB,1),lfidx),EEG.channels_location,'maplimits','absmax', 'electrodes', 'off');
                %end
                
                % labels
                title_text = num2str(frequencies(lfidx));
                title([title_text, 'Hz']);
                %title.FontSize=14;
                caxis(caxis_range(color_bar_ranges,:));
                set(0,'DefaultFigureVisible','on');  
        end
       
        % position the color bar as a global colorbar
        %cb = colorbar("eastoutside");
        %cb.Layout.Tile = 'eastoutside';
        
        % Save Topographic Maps figures and mat.files
        disp(['Saving the figure of Topographic Map #' num2str(color_bar_ranges)])
        saveas(figure(color_bar_ranges), fullfile(outdir,figure_name),'jpg');
        pause(1);
        disp('Topographic Map figure successfully saved')
        pause(2);
        close(topographic_map)   
        
        % Save topodata in mat.file
        %save(topodata,fullfile('topodata'));
    end

    