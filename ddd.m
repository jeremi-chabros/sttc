clearvars; clc;
addpath('/Users/jeremi/mea/spikes');
load('PAT200219_2C_DIV170002_L_-0.179_spikes.mat');

fs = spikeDetectionResult.params.fs;
duration_s = round(spikeDetectionResult.params.duration);

for i = 1:60
    if length(spikeTimes{i}.mea)>100
        spikeTimes{i}.mea = spikeTimes{i}.mea/fs;
    else
         spikeTimes{i}.mea = [];
    end
end
%%

method = 'mea';
lag_ms = 15;
tail = 0.001;
rep_num = 250;

tic
[adjM, adjMci] = adjM_thr_JC(spikeTimes, method, lag_ms, tail, fs,...
    duration_s, rep_num);
toc
colormap(cmocean('thermal'));
%%
adjM(isnan(adjM))=0;
adjMci(isnan(adjMci))=0;

figure
tiledlayout(1,3, 'tilespacing', 'none', 'padding', 'none');
nexttile
imagesc(adjM);
axis square
title('Original adjM')
caxis([min(adjM(:)) max(adjM(:))])
set(gca, 'xcolor', 'none', 'ycolor', 'none')

nexttile
imagesc(adjMci)
axis square
title('Thresholded adjM')
caxis([min(adjM(:)) max(adjM(:))])
set(gca, 'xcolor', 'none', 'ycolor', 'none')

nexttile
imagesc((adjM-adjMci))
axis square
title('Removed connections')
caxis([min(adjM(:)) max(adjM(:))])
set(gca, 'xcolor', 'none', 'ycolor', 'none')

colormap(cmocean('thermal'));
%%
A = adjMci;
A(1:length(A)+1:end) = 0;

A(isnan(A))=[];

A = reshape(A, [sqrt(length(A)),sqrt(length(A))]);

%%
Z = linkage(A);
[~, ~, outperm] = dendrogram(Z, 0);
sortedSpikeMatrix = A(outperm, :);

%%
clustergram(A, 'cluster', 'all')


