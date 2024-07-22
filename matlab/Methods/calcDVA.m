function DVAOutput = calcDVA(varargin)
    % Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
    %-------------
    % Created on: 20.12.2022
    % ------------
    % Version: Matlab2020b
    %-------------
    % Description: This function calculates the DVA or ICA of a given input file (.csv / .mat).
    % ------------
    % Input: String, path to data
    %        String, DVA or ICA
    % Options: "Smoothing Method": ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use; default: sgolay
    %          "Smoothing Parameter": Float, how much the data is smoothed; default: 0.04
    %          "Smoothing Location": ["U", "I", "Output", "all"], what do you want to smooth; default: "all"
    %          "Output Size": Integer, size of the output, must be smaller or equal of input size; default: input size
    % ------------
    % Output: Struct with time, DVA and normed DVA or ICA, charge, SOC
    % ------------

    %% Import Data
    DVAData = parseInput(varargin{:});
    
    %% Thin Out Data / Reduce Number of Data Points
    [DVAData.time, DVAData.I, DVAData.U] = thinOutData(DVAData.time, DVAData.I, DVAData.U, DVAData.output_size);
    
    %% Smooth Input Data 
    %Smooth U
    if (strcmp(DVAData.smoothing_location, "U") || strcmp(DVAData.smoothing_location, "all"))    
        DVAData.U = smoothingDVA(DVAData.U, DVAData.time, DVAData.smoothing_method, DVAData.smoothing_parameter);
    end
    
    %Smooth I
    if (strcmp(DVAData.smoothing_location, "I") || strcmp(DVAData.smoothing_location, "all"))    
        DVAData.I = smoothingDVA(DVAData.I,DVAData.time,DVAData.smoothing_method,DVAData.smoothing_parameter);
    end
    
    %% Calculate DVA and ICA
    %Calculate DVA
    dt = diff(DVAData.time);
    dU = [NaN; diff(DVAData.U(1:end))./dt(1:end)];
    DVAData.DVA = dU./DVAData.I(1:end);
    
    %Calculate ICA
    if strcmp(DVAData.calc_method, "ICA")
        DVAData.ICA = 1./DVAData.DVA;
    end

    %% Calculate Charge
    DVAData.Charge = (cumtrapz(DVAData.time, abs(DVAData.I)));
    
    %% Calculate Axis
    %Calculate SOC
    DVAData.SOC = (DVAData.Charge(end)-DVAData.Charge)./(DVAData.Charge(end)-DVAData.Charge(1));
    
    %Calculate the DVA normed to Charge Q
    DVAData.DVA_Qnorm = DVAData.DVA*DVAData.Charge(end);
    
    %% Smoothing Output Data
    %Smooth DVA
    if (strcmp(DVAData.smoothing_location, "Output") || strcmp(DVAData.smoothing_location, "all"))
        DVAData.DVA = smoothingDVA(DVAData.DVA,DVAData.time,DVAData.smoothing_method,DVAData.smoothing_parameter);
    end
    
    %Smooth ICA
    if strcmp(DVAData.calc_method, "ICA")
        if (strcmp(DVAData.smoothing_location, "Output") || strcmp(DVAData.smoothing_location, "all"))
            DVAData.ICA = smoothingDVA(DVAData.ICA,DVAData.time,DVAData.smoothing_method,DVAData.smoothing_parameter);
        end
    end
    
    %% Process Output Data
    DVAData = processDVA(DVAData);
    
    %% Build return variable
    DVAOutput.time = DVAData.time;
    DVAOutput.Charge = DVAData.Charge;
    DVAOutput.SOC = DVAData.SOC;
    
    % Return either DVA or ICA depending on calculation method
    if strcmp(DVAData.calc_method, "ICA")
        DVAOutput.ICA = DVAData.ICA;
    else
        DVAOutput.DVA = DVAData.DVA;
        DVAOutput.DVA_Qnorm = DVAData.DVA_Qnorm;
    end
end