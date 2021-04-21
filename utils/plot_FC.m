function [] = plot_FC(result_fc, ID, frequency,phase,hemisphere, path)
% This function saves the output from the wPLI and dPLI
% Figures will be saved with different thresholds

for ii = 1:4
    figure(ii);clf;hold on;
    set(gca, 'FontSize', 12);
    xlabel ('Electrodes'); ylabel ('Electrodes');
    title ('Average wPLI');
    imagesc(result_fc)
    %grid on
    colorbar;
    colormap(jet);

    % adjust the colorbar
    if ii == 1
        caxis ([0 0.1]);
    elseif ii == 2
        caxis ([0 0.215]);
    elseif ii == 3
        caxis ([0 0.22]);
    else 
        caxis ([0 0.25]);
    end  

    % save the file with the appropriate name
    if i==1
        figure_title = ['Theta_wPLI_', num2str(ii)];
    else 
        figure_title = ['Alpha_wPLI_', num2str(ii)];
    end
    saveas(figure(ii), figure_title, 'jpg')
    pause(5);
    % path of the figure added in front of the title
end