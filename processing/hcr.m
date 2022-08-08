function  b = hcr(fc)
%HCR - calulates hierarchical coefficient of regression from a weighted
%      functional connectome.
%
%   b = hcr(fc);
%
%   Input:      fc,     distance matrix
%
%   Outputs:    b,      hierarhical coefficient of regression
%
%   Jure Demsar, University of Ljubljana, 2022

% load Brain Connectivity Toolbox
addpath('../../2019_03_03_BCT')

% get clustering coefficient per node
cc = clustering_coef_wu(fc);

% get degree per node
dg = degrees_wei(fc);

% linear regression
b = dg'\cc;