# High-performance mex implementation of Spike Time Tiling Coefficient.
 
 *   Originally written by Catherine S Cutts (2014): https://github.com/CCutts/Detecting_pairwise_correlations_in_spike_trains/blob/master/spike_time_tiling_coefficient.c
 *   See the original paper: https://www.ncbi.nlm.nih.gov/pubmed/25339742

**IMPORTANT:** If you don't have the appropriate `.mex` version of your `.c` script (e.g. `.mexmaci64` for OSX, `.mexw64` for Windows), you need to first run in command window:

``mex sttc.c -R2018a``
