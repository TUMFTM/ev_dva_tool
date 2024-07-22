import numpy as np


def processDVA(DVAData: dict):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 23.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This function processes the DVA Data, cuts extreme values in beginning and ending and flips the DVA
    #              if necessary.
    # ------------
    # Input: DVAData: Dictionary with time, U, I, Charge, SOC and DVA and normed DVA
    # ------------
    # Output: Postprocessed input dictionary
    # ------------

    # Decide to flip DVA
    nrOfData = len(DVAData["U"])

    # --> Get voltage of beginning of data
    U_start = DVAData["U"][round(nrOfData * 0.2)]

    # --> Get voltage of end of data
    U_end = DVAData["U"][round(nrOfData * 0.8)]

    # if voltage is bigger at the beginning, the input is from a discharge
    if U_start > U_end:
        # Only flip the charge for a natural display from 0 to 100% SOC
        DVA_flipped = DVAData["DVA"]
        DVA_Qnorm_flipped = DVAData["DVA_Qnorm"]
        Charge_flipped = np.flip(DVAData["Charge"])
        DVA_SOC_flipped = DVAData["SOC"]
    else:
        # Flip DVA over x-axis for a universal display above the x-axis
        Charge_flipped = DVAData["Charge"]
        DVA_flipped = -1 * DVAData["DVA"]
        DVA_Qnorm_flipped = -1 * DVAData["DVA_Qnorm"]

        # Flip SOC for a natural display from 0 to 100% SOC
        DVA_SOC_flipped = np.flip(DVAData["SOC"])

    # Noise to Signal Ratio
    # --> Check the noise level to recommend more or fewer smoothing.
    noise_lvl = signaltonoise_dB(DVAData["DVA"][2:])

    # --> Too less noise
    if noise_lvl > -0.6:
        print("[WARNING]: Possibly too much smoothing. Try with less smoothing for more accurate results.")

    # --> Too much noise
    if noise_lvl < -0.9:
        print("[WARNING]: Possibly not enough smoothing. Try with more smoothing or a bigger Output Size for better "
              "plots.")

    # # New version to check noise without SNR
    # # --> Compute the standard deviation of the input signal
    # x_std = np.std(DVAData["DVA"][2:])
    #
    # # --> Set a threshold for the amount of noise that is acceptable
    # upper_threshold = 0.021
    # lower_threshold = 0.01
    #
    # # --> Compare the standard deviation to the threshold
    # if x_std > upper_threshold:
    #     print("[WARNING]: Possibly not enough smoothing. Try with more smoothing or a bigger Output Size for better "
    #           "plots.")
    #
    # if x_std < lower_threshold:
    #     print("[WARNING]: Possibly too much smoothing. Try with less smoothing for more accurate results.")

    # Build return variable
    DVAData["DVA"] = DVA_flipped
    DVAData["DVA_Qnorm"] = DVA_Qnorm_flipped
    DVAData["Charge"] = Charge_flipped
    DVAData["SOC"] = DVA_SOC_flipped
    DVAData["noise_lvl"] = noise_lvl

    return DVAData


def signaltonoise_dB(a):
    """
    Calculates the naive noise level of an input signal.
    :param a: array, input signal
    :return: noise level in dB
    """
    a = np.asanyarray(a)
    m = np.mean(a)
    sd = a.std()
    return 20 * np.log10(abs(np.where(sd == 0, 0, m / sd)))
