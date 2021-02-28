clearvars; clc;
addpath('/Users/jeremi/mea/spikes');
load('PAT200219_2C_DIV170002_L_-0.179_spikes.mat');

% Conversion to seconds (if spikes times are in frames)
% For ms --> s conversion, use 25 instead of 25,000 at line 9
for i = 1:60
    if length(spikeTimes{i}.mea)>100 % Crude exclusion of silent channels
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
rep_num = 10;

%% Fast but no plots
[adjM, adjMci] = adjM_thr_parallel(spikeTimes, method, lag_ms, tail, fs,...
    duration_s, rep_num);

%% Slow but useful for visuals/troubleshooting

[adjM, adjMci] = adjM_thr_JC(spikeTimes, method, lag_ms, tail, fs,...
    duration_s, rep_num);




