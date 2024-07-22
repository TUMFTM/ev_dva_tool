% Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
%-------------
% Created on: 03.01.2023
% ------------
% Version: Matlab2020b
%-------------
% Description: This script calculates the DVA or ICA of all given input file (.csv / .mat) that are located in the
% data_in folder and saves the .mat file in the data_out folder. 
% ------------
% Input: .csv/ .mat files in data_in folder with time, voltage and current as columns 
%        
% Options: "Smoothing Method": ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use; default: sgolay
%          "Smoothing Parameter": Float, how much the data is smoothed; default: 0.04
%          "Smoothing Location": ["U", "I", "Output", "all"], what do you want to smooth; default: "all"
%          "Output Size": Integer, size of the output, must be smaller or equal of input size; default: input size
% ------------
% Output: .mat file with time, DVA and normed DVA or ICA, charge, SOC
% saved in the data_out folder
% ------------

%% Initialize
close all
clearvars
clearvars -GLOBAL
fclose('all');

disp('Initialize...')

% Generate path to working directory
addpath(genpath(pwd));

% filelist = dir([pwd '\data_in']); %Windows
% filelist = dir([pwd '/data_in']); %Mac OS
filelist = dir(fullfile(pwd, "..", "data_in"));

if numel(filelist) < 3 % If folder is empty, count is 2 because binary files
    msgbox('No measurements to process. Please check data_in folder.', 'Error','error');
    return;
end

%% Run Main Loop for DVA calculation and saving

for i = 3:numel(filelist) % Main for loop for processing
    disp(['Processing file ' num2str(i - 2) '...']);
    
    % Check if file is .csv or .mat
    if strcmp(filelist(i).name(end - 3:end), '.csv') || strcmp(filelist(i).name(end - 3:end), '.mat')  
        
        % Create filepath to working file
        filepathtemp = fullfile(filelist(i).folder, filelist(i).name);
        
        % Run Main function of DVA Tool with defaults
        try
            DVAOutput = calcDVA(filepathtemp, "DVA");    
        catch Exception
            disp(['--> File ' num2str(i-2) ': Failed to calculate DVA (' Exception.message ').'])
            continue
        end

        % Save files
        disp(['--> File ' num2str(i-2) ': Saving...'])
        save(fullfile("..", "data_out", filelist(i).name(1:end-4)), 'DVAOutput');
    
        clear DVAOutput
    
        disp(['--> File ' num2str(i-2) ': Successfully saved in output.'])
    else
        disp(['--> File ' num2str(i-2) ' is no .mat or .csv...']); 
    end
end


