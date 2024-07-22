function [time_cut,I_cut,U_cut] = thinOutData(time, I, U, output_size)
    % Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
    %-------------
    % Created on: 20.12.2022
    % ------------
    % Version: Matlab2020b
    %-------------
    % Description: This function thins out the input data to reduce noise from sensors.
    %              It reduces the number of data points to a given output size.
    % ------------
    % Input: time: Vector of time series
    %        I: Vector of current data
    %        U: Vector of voltage data
    %        output_size: Integer, desired output size
    % ------------
    % Output: time, I and U with reduced data
    % ------------
    %% Calculation
    % Prepare time series
    time_cut = linspace(time(1),time(end),output_size);
    [time_fit, dup_index] = unique(time);
    U_fit_red = U(dup_index);
    I_fit_red = I(dup_index);
   
    % Interpolate corresponding voltage and current values
    U_cut = interp1(time_fit,U_fit_red,time_cut);
    I_cut = interp1(time_fit,I_fit_red,time_cut);
    
    % Change rows to column
    U_cut = U_cut';
    I_cut = I_cut';
    time_cut = time_cut';
end