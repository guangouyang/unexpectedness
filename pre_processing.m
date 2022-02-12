clear;
eeglab nogui;


    
    EEG = pop_loadset('filename','sampe_data.set',...
        'filepath','');
    
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',45,'plotfreqz',0);
    
    pop_eegplot(EEG,1,1,1);
    
    std_temp= std(EEG.data,1,2);
    ol = find(isoutlier(std_temp,'ThresholdFactor',4)&std_temp>mean(std_temp));
    if ~isempty(ol) EEG = pop_interp(EEG, ol, 'spherical');end
    
    EEG = pop_reref( EEG, []);
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'stop',0.1,'interrupt','on');
    
    
    [comps,info] = MARA(EEG);
    EEG.comps = comps;
    EEG.info = info;
    EEG = pop_subcomp( EEG, find(EEG.info.posterior_artefactprob>0.5), 0);

    pop_eegplot(EEG,1,1,1);
