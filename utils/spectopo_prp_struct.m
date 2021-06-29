function spectopo_prp = spectopo_prp_struct
% Spectrogram parameters: 
    fp = [0.1 50]; % Frequency pass of [high_pass low_pass]
    stepSize = 0.1; % The step length over which to move the window. / independent from PLI % Was set to 0.1 in the previous code           
    tso = 4; % Temporal smoothing median filter order (reduces the noise)
    numberTaper = 3;
    timeBandwidth = 2; 
    
    %timeBandwidth product and numberTaper
        % should generally set the nubmer of tapers to be 2 x (time-bandwidth product-1)
        % using more tapers will include tapers with poor concentration in the
        % specified frequency bandwidth (chronux documentation for more info)
   
    windowLength = 2; % The length of window for spectrum to be calculated.
    
    % Topographic Map Parameters:
    frequencies = [4 5 6 7 8 9 10 11 12 13]; % Frequencies of the topographic map from 4 to 13Hz. 
    freqidx = (2* frequencies) + 1; % NOT quite sure what this is.
    
 % spectopo_prp struct
    spectopo_prp = struct('fp',fp,'tso',tso,'timeBandwidth',timeBandwidth,...
   'numberTaper',numberTaper,'windowLength',windowLength,'stepSize',stepSize,...
   'freqidx',freqidx,'frequencies',frequencies);

 % spectopo_prp = struct('fp',fp,'tso',tso,'timeBandwidth',timeBandwidth,...
   %'numberTaper',numberTaper,'windowLength',windowLength,'stepSize',stepSize,...
   %'freqidx',freqidx,'frequencies',frequencies,'print_spect',1,...
   %'save_spect',0,'print_topo',1,'save_topo',0);