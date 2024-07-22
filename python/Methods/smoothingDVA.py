import csaps
import numpy as np
from scipy.signal import savgol_filter
from scipy.interpolate import CubicSpline


def smoothingDVA(input_Data, input_time, smoothing_method: str, smoothing_parameter: float):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 22.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This function implements different smoothing methods.
    # ------------
    # Input: input_Data: numpy array, data to be smoothed
    #        input_time: numpy array, corresponding time vector to input data
    #        smoothing_method: ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use
    #        smoothing_parameter: Float, how much the data is smoothed
    # ------------
    # Output: numpy array, smoothed input data
    # ------------

    # Cubic Smoothing Spline
    if smoothing_method == "cubic":
        DataSmooth = csaps.csaps(input_time, input_Data, input_time, smooth=smoothing_parameter)

    # Savitzky Golay
    elif smoothing_method == "sgolay":
        # Calculate window size from smoothing parameter
        ws_factor = smoothing_parameter * len(input_Data)
        ws = round((ws_factor - 1) / 2) * 2 + 1  # Nearest odd value

        # Smoothing
        DataSmooth = savgol_filter(input_Data, ws, 2)

    # Moving Mean
    elif smoothing_method == "movmean":
        # Calculate window size from smoothing parameter
        ws_factor = smoothing_parameter * len(input_Data)
        ws = round((ws_factor - 1) / 2) * 2 + 1  # Nearest odd value

        # Smoothing
        kernel = np.ones(ws) / ws
        DataSmooth = np.convolve(input_Data, kernel, "same")

    # Spline smoothing
    elif smoothing_method == "spline":
        time_thinnedout = input_time[1::smoothing_parameter]
        Data_thinnedout_raw = input_Data[1::smoothing_parameter]
        cubic_spline = CubicSpline(time_thinnedout, Data_thinnedout_raw)
        DataSmooth = cubic_spline(input_time)

    else:
        raise ValueError("Wrong smoothing method (" + smoothing_method + ")!")

    return DataSmooth
