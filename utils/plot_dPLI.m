function [] = plot_dPLI(result_fc, ID, frequency, task, hemisphere, outdir,labels)
% This function saves the output from the dPLI
% Figures will be saved with different thresholds

for ii = 1:4
    figure_title = strcat('dPLI-',ID,'-',frequency,'-',task,'-',hemisphere,'-',num2str(ii));
    figure(ii);clf;hold on;
    set(gca, 'FontSize', 12);
    xlabel ('Electrodes'); ylabel ('Electrodes');
    title (figure_title);
    imagesc(result_fc)
    set(gca, 'YDir','reverse')
    axis tight
    %grid on
    colorbar;
    colormap(jet);

    % adjust the colorbar
    if ii == 1
        caxis ([0.45 0.55]);
    elseif ii == 2
        caxis ([0.4 0.6]);
    elseif ii == 3
        caxis ([0.35 0.65]);
    else 
        caxis ([0.3 0.7]);
    end

    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',5)
    
    % setting the x ticks to be vertical with the right label names
    xtickangle(90)
    xticks(1:length(labels));
    xticklabels(labels);

    % setting the y ticks with the right label names
    yticklabels(labels); 
    yticks(1:length(labels));


    % save the file with the appropriate name
    saveas(figure(ii), fullfile(outdir, figure_title), 'jpg')
    %pause(2);
    close(figure(ii))
    % path of the figure added in front of the title
end