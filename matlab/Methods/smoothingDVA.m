function [DataSmooth] = smoothingDVA(input_Data, input_time, smoothing_method, smoothing_parameter)
    % Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
    %-------------
    % Created on: 20.12.2022
    % ------------
    % Version: Matlab2020b
    %-------------
    % Description: This function implements different smoothing methods.
    % ------------
    % Input: input_Data: vector, data to be smoothed
    %        input_time: vector, corresponding time vector to input data
    %        smoothing_method: ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use
    %        smoothing_parameter: Float, how much the data is smoothed
    % ------------
    % Output: smoothed data
    % ------------
    %% Pretasks
    warning('off','SPLINES:CHCKXYWP:NaNs')
    warning('off','MATLAB:interp1:NaNstrip')

    %% Cubic Smoothing Spline
    if strcmp(smoothing_method, "cubic")
        DataSmooth = csaps(input_time, input_Data, smoothing_parameter, input_time);
    end
    
    %% Savitzky Golay
    if strcmp(smoothing_method, "sgolay")
        % Calculate window size from smoothing parameter
        ws_factor = smoothing_parameter * length(input_Data);
        ws = round((ws_factor-1)/2)*2+1;    % Nearest odd value for windowsize
        
        % Smoothing
        DataSmooth = smoothdata(input_Data,'sgolay',ws);
    end
    
    %% Moving Mean
    if strcmp(smoothing_method, "movmean")
        % Calculate window size from smoothing parameter
        ws_factor = smoothing_parameter*length(input_Data);
        ws = round((ws_factor-1)/2)*2+1;    % Nearest odd value for windowsize
        
        % Smoothing
        DataSmooth = smoothdata(input_Data,'movmean',ws);
    end
    
    %% Spline smothing
    if strcmp(smoothing_method, "spline")
        %Thinning out Data
        time_thinnedout = input_time(1:smoothing_parameter:end);
        Data_thinnedout_raw = input_Data(1:smoothing_parameter:end);
        
        % Interpolate data over time for matching datapoints
        DataSmooth = interp1(time_thinnedout, Data_thinnedout_raw, input_time, "spline");
    end
end