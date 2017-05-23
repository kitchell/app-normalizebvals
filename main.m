function [] = main()
% normalizes the bvals and splits the bvecs

% load config.json
config = loadjson('config.json');

% Parameters used for normalization
params.single_shells       = config.shells;
params.thresholds.b0_normalize    = 200;
params.thresholds.bvals_normalize = 100;


%% Normalize HCP files to the VISTASOFT environment

bvals.val = dlmread(config.bvals);

% Round the numbers to the closest thousand 
% This is necessary because the VISTASOFT software does not handle the B0
% when they are not rounded.
[bvals.unique, ~, bvals.uindex] = unique(bvals.val);
if ~isequal(bvals.unique, params.single_shells)
    bvals.unique(bvals.unique <= params.thresholds.b0_normalize) = 0;
    bvals.unique  = round(bvals.unique./params.thresholds.bvals_normalize) ...
        *params.thresholds.bvals_normalize;
    bvals.valnorm = bvals.unique( bvals.uindex );
    dlmwrite('dwi_normalized.bvals',bvals.valnorm);
else
    bvals.valnorm = bvals.val;
    dlmwrite('dwi_normalized.bvals',bvals.valnorm);
end
end