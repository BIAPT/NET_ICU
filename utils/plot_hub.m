function [] = plot_hub(hub_norm_weights, ID, frequency, task, hemisphere, outdir,labels)
    % this function is to create and save the figure of the HUB
    % INPUT: 
    
    %% plot the HUB
    
    caxis_range = [0 5; 0 10; 0 15]; % colorbar limits
    
    for color_bar_ranges = 1:length(caxis_range)
        figure_title_save = strcat('HUB-',ID,'-',frequency,'-',task,'-',hemisphere,'-',num2str(color_bar_ranges));
        figure_title = strcat('HUB-',ID,'-',frequency,'-',task,'-',hemisphere);
        
        % plot the hub
        fig = topoplot(hub_norm_weights,labels,'maplimits','absmax');
        
        % labels 
        title (figure_title);
        caxis(caxis_range(color_bar_ranges,:));
        colorbar;
        set(0,'DefaultFigureVisible','on'); 
        
        % save the figures
        saveas(fig, fullfile(outdir, figure_title_save), 'jpg')
        close()
    end
