function [input_struct] = parseInput(varargin)
    % Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
    %-------------
    % Created on: 20.12.2022
    % ------------
    % Version: Matlab2020b
    %-------------
    % Description: This functions reads and parses the input of the DVA tool.
    % ------------
    % Input: Inputs of the calcDVA function
    % ------------
    % Output: Struct of input variables
    % ------------
    %% Pretasks
    valid_option_string = ["Smoothing Method", "Smoothing Parameter", "Smoothing Location", "Output Size"];
   
    % Check input size
    if nargin < 2 
        error("Not enough input arguments.")
    end

    %% Read in data from file
    data_path = varargin{1};
    
    % Perform prechecks
    if ~ischar(data_path)
        if isstring(data_path)
            data_path = convertStringsToChars(data_path);
        else
            error("First input argument must be a char or string array describing a path to a file!")
        end
    end
    if ~isfile(data_path)
        error("First input argument must be a path to a file!")
    end
    
    % Read in data depending on file format
    if strcmp(data_path(end-3:end),'.csv')
        data_matrix = readmatrix(data_path);
    elseif strcmp(data_path(end-3:end),'.mat')
        input_struct = load(data_path);
        fn = fieldnames(input_struct);
        if numel(fn) > 1
            error("mat-file must contain only one variable (matrix with time, U, I)!")
        end
        data_matrix = input_struct.(fn{1});
    else
        error("Data input file must be csv- or mat-file.")
    end

    % Check size of input
    if size(data_matrix, 2) < 3
        error("Input data size to small (%i)! Is data missing?", size(data_matrix, 2))
    elseif size(data_matrix, 2) > 3
        error("Input data size to big (%i)! Check input data!", size(data_matrix, 2))
    end
    % TODO: Maybe perform further data validation here.
    input_struct.time = data_matrix(:,1);
    input_struct.U = data_matrix(:,2);
    input_struct.I = data_matrix(:,3);

    %% Determine calculation method
    calculation_method = varargin{2};

    % Perform checks
    if ~(ischar(calculation_method) || isstring(calculation_method))
        error("Wrong calculation method input format. Must be a char or string!")
    end
    if ~(strcmp(calculation_method, "DVA") || strcmp(calculation_method, "ICA"))
        error("Wrong calculation method. Options are 'DVA' or 'ICA'.")
    end
    input_struct.calc_method = calculation_method;

    %% Parse options
    if nargin > 2 
        option_strings = varargin(3:2:end);
        option_values = varargin(4:2:end);
        
        % Perform prechecks
        if size(option_strings, 2) ~= size(option_values, 2)
            error("Number of option strings and values do not match!")
        end
        for i=1:numel(option_strings)
            if ~isstring(option_strings{i})
                error("'%s' is not a valid option!", option_strings{i})
            end
            if ~any(strcmp(valid_option_string, option_strings{i}))
                error("'%s' is not a valid option!", option_strings{i})
            end
        end

        % Set default values
        % Output Size
        input_struct.output_size = length(data_matrix);
        % TODO: Begrenzung der default output size?
%         if length(data_matrix) >= 2000 %Input size can`t be smaller than default Output size
%             input_struct.output_size = 2000; length(data_matrix);
%         else
%             input_struct.output_size = length(data_matrix);
%         end
        % Smoothing Location
        input_struct.smoothing_location = "all";
        
        % Smoothing Method
        input_struct.smoothing_method = "sgolay";

        % Smoothing Parameter
        input_struct.smoothing_parameter = 0.04;

        % Process option
        for i=1:numel(option_strings)
            if strcmp(option_strings{i}, valid_option_string{4})    %Output Size
                if option_values{i} < 1
                    error("Output Size has to be 1 or bigger.") 
                end
                if mod(option_values{i},1) ~= 0
                    error("Output Size must be an integer value.")
                end
                if option_values{i} > length(data_matrix)
                    error("Output Size must be smaller than Input Size.")
                end
                input_struct.output_size = option_values{i};
            end
            if strcmp(option_strings{i}, valid_option_string{1})    %Smoothing Mehtod
                input_struct.smoothing_method = option_values{i};
            end
            if strcmp(option_strings{i}, valid_option_string{2})    %Smoothing Parameter
                input_struct.smoothing_parameter = option_values{i};
            end
            if strcmp(option_strings{i}, valid_option_string{3})    %Smoothing Location
                if ~isstring(option_values{i})
                    error("Wrong Smoothing Location. Input must be a string.")
                end
                if (~strcmp(option_values{i},"U") && ~strcmp(option_values{i},"I") ...
                        && ~strcmp(option_values{i},"Output") && ~strcmp(option_values{i},"all"))
                    error("Wrong Smoothing Location. Input must be either I, U, Output, or all.")
                end
                input_struct.smoothing_location = option_values{i};
            end
        end
    else
        %% Set default values, if there are no optional inputs
        % Output Size
        input_struct.output_size = length(data_matrix);
        % TODO: Begrenzung der default output size?
%         if length(data_matrix) >= 2000 %Input size can`t be smaller than default Output size
%             input_struct.output_size = 2000; length(data_matrix);
%         else
%             input_struct.output_size = length(data_matrix);
%         end
        
        %Smoothing Location
        input_struct.smoothing_location = "all";

        %Smoothing Method
        input_struct.smoothing_method = "sgolay";

        %Smoothing Parameter
        input_struct.smoothing_parameter = 0.04;
    end
end