function [] = plot_hub(hub_norm_weights, ID, frequency, task, hemisphere, outdir,labels)
    % this function is to create and save the figure of the HUB
    % INPUT: 
    
    %% plot the HUB
    figure_title = strcat('HUB-',ID,'-',frequency,'-',task,'-',hemisphere);
    
    fig = topoplot(hub_norm_weights,labels,'maplimits','absmax');
    caxis([0 10]);
    colorbar()
    title (figure_title);
    
    % save the file with the appropriate name
    saveas(fig, fullfile(outdir, figure_title), 'jpg')
    %pause(2);
    close()
    % path of the figure added in front of the title

end
