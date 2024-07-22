function DVAData_processed = processDVA(DVAData)
    % Designed by: Jonas Göhmann and Lukas Köning (FTM, Technical University of Munich)
    %-------------
    % Created on: 20.12.2022
    % ------------
    % Version: Matlab2020b
    %-------------
    % Description: This function processes the DVA Data, cuts extreme values in beginning and ending and flips the DVA if necessary.
    % ------------
    % Input: DVAData: struct with time, U, I, Charge, SOC and DVA and normed DVA
    % ------------
    % Output: postprocessed input struct
    % ------------
    %% Decide to flip DVA
    nrOfData = length(DVAData.U);
    
    % Get voltage of beginning of data
    U_start = DVAData.U(round(nrOfData*0.20));
    
    % Get voltage of end of data
    U_end = DVAData.U(round(nrOfData*0.80));
    
    % if voltage is bigger at the beginning, the input is from a discharge
    if U_start > U_end
        % Only flip the charge for a natural display from 0 to 100% SOC
        DVA_flipped = DVAData.DVA;
        DVA_Qnorm_flipped = DVAData.DVA_Qnorm;
        Charge_flipped = flip(DVAData.Charge);
        DVA_SOC_flipped = DVAData.SOC;
    else
        % Flip DVA over x-axis for a universal display above the x-axis
        Charge_flipped = DVAData.Charge;
        DVA_flipped = -1 * DVAData.DVA;
        DVA_Qnorm_flipped = -1 * DVAData.DVA_Qnorm;

        % Flip SOC for a natural display from 0 to 100% SOC
        DVA_SOC_flipped = flip(DVAData.SOC);
    end

    %% Noise to Signal Ratio
    % Check the noise level to recommend more or fewer smoothing.
    % noise_lvl = snr(DVAData.DVA(2:end));

    % Naive calculation of noise level
    m = mean(DVAData.DVA(2:end));
    sd = std(DVAData.DVA(2:end));
    if sd == 0
        noise_lvl = 20 * log10(0);
    else
        noise_lvl = 20 * log10(abs(m / sd));
    end
    
    % Too less noise
    if (noise_lvl) > -0.6
        warning("Possibly too much smoothing. Try with less smoothing for more accurate results.")
    end

    % Too much noise
    if (noise_lvl) < -0.9
        warning("Possibly not enough smoothing. Try with more smoothing or a bigger Output Size for better plots.")
    end

%     %New version to check noise without SNR
%     % Compute the standard deviation of the input signal
%     x_std = std(DVAData.DVA(2:end));
%     
%     % Set a threshold for the amount of noise that is acceptable
%     upper_threshold = 0.021;
%     lower_threshold = 0.01;
%     % Compare the standard deviation to the threshold
%     if x_std > upper_threshold
%         disp('Possibly not enough smoothing. Try with more smoothing or a samller Output Size for better plots.')
%     end
%     if x_std < lower_threshold 
%         disp('Possibly too much smoothing. Try with less smoothing for more accurate results.')
%     end
    
    %% Build return variable
    DVAData_processed = DVAData;
    DVAData_processed.DVA = DVA_flipped;
    DVAData_processed.DVA_Qnorm = DVA_Qnorm_flipped;
    DVAData_processed.Charge = Charge_flipped;
    DVAData_processed.SOC = DVA_SOC_flipped;
    DVAData_processed.noise_lvl = noise_lvl;
end