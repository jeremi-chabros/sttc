clearvars; clc;
addpath('/Users/jeremi/mea/spikes');
load('PAT200219_2C_DIV170002_L_-0.179_spikes.mat');

for i = 1:60
    if length(spikeTimes{i}.mea)>100
        spikeTimes{i}.mea = spikeTimes{i}.mea/25000;
    else
         spikeTimes{i}.mea = [];
    end
end
%%

clc;
method = 'mea';
lag_ms = 10;
tail = 0.05;
fs = spikeDetectionResult.params.fs;
duration_s = spikeDetectionResult.params.duration;
rep_num = 1000;
num_nodes = length(channels);
num_frames = round(duration_s)*fs;

% Actual loop:
tic
adjM = get_sttc(spikeTimes, lag_ms, duration_s, method, fs);
for i = 1:rep_num
    synth_spk = spikeTimes;
    
    for n = 1:num_nodes
        
        k = randi(num_frames,1); % padding used in circshift
        
        % Fast circshift: logical indexing and basic operations used
        spk_vec = synth_spk{n}.(method)*fs + k;
        overhang = spk_vec > num_frames;
        spk_vec(overhang) = spk_vec(overhang)-num_frames;
        spk_vec = sort(spk_vec);
        synth_spk{n}.(method) = spk_vec/fs;
    end
    
    adjM_synth = get_sttc(synth_spk, lag_ms, duration_s, method, fs);
    adjM_synth(1:num_nodes+1:end) = 0; % Faster than removing from adjMi
    adjM_synth(adjM_synth<0)=0;
    adjM_all(:,:,i) = adjM_synth;
end
toc
%%
h1 = histogram(adjM(:));

hold on
% h2 = histogram(adjM_all(:,:,:));
[N,EDGES] = histcounts(adjM_all(:),100);
N = rescale(N(1:end),min(h1.Values),max(h1.Values));
h2 = histogram('BinCounts', N, 'BinEdges', EDGES(1:end));

synth_mean = nanmean(adjM_all,'all');
synth_std = nanstd(adjM_all,1,'all');
thr = synth_mean+5*synth_std;
% xlim([0,1])
% ylim([min(h1.Values) max(h1.Values)]);

pv = [90 95 97.5 99.5];
ps = prctile(adjM_all(:), pv);

hold on

for i = 1:length(ps)
    l = xline(ps(i), 'r--', num2str(pv(i)));
    l.LineWidth = 2;
    hold on
end




% tic
% adjMci = adjM_thr_JC(spikeTimes, method, lag_ms, tail, fs,...
%     duration_s, rep_num);
% toc
%
%%
tiledlayout(1,3, 'padding','none','tilespacing','none')

nexttile
imagesc(adjM)
title('original adjM');
axis square
set(gca, 'xcolor','none','ycolor','none');
caxis([min(adjM(:)), max(adjM(:))])

nexttile
adjMci = ((adjM>ps(end)).*adjM);
imagesc(adjMci);
axis square
title('thresholded adjM');
set(gca, 'xcolor','none','ycolor','none');
caxis([min(adjM(:)), max(adjM(:))])
% caxis([0 1]);

nexttile 
imagesc(adjM-adjMci);
axis square
title('removed connections')
set(gca, 'xcolor','none','ycolor','none');
caxis([min(adjM(:)), max(adjM(:))])

colorbar
caxis([min(adjM(:)), max(adjM(:))])

