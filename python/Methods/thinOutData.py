import numpy as np


def thinOutData(DVAData: dict):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 22.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This function thins out the input data to reduce noise from sensors.
    #              It reduces the number of data points to a given output size.
    # ------------
    # Input: DVAData: Dictionary with DVA data
    # ------------
    # Output: Dictionary with reduced data
    # ------------

    # Prepare time series
    time_cut = np.linspace(DVAData["time"][0], DVAData["time"][-1], DVAData["output_size"])
    time_fit, dup_index = np.unique(DVAData["time"], return_index=True)
    U_fit_red = DVAData["U"][dup_index]
    I_fit_red = DVAData["I"][dup_index]

    # Interpolate corresponding voltage and current values
    U_cut = np.interp(time_cut, time_fit, U_fit_red)
    I_cut = np.interp(time_cut, time_fit, I_fit_red)

    # Update dictionary
    DVAData["time"] = time_cut
    DVAData["U"] = U_cut
    DVAData["I"] = I_cut

    return DVAData
