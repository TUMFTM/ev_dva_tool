from Methods.parseInput import parseInput
from Methods.thinOutData import thinOutData
from Methods.smoothingDVA import smoothingDVA
from Methods.processDVA import processDVA

import numpy as np
import scipy


def calcDVA(data_path: str, calc_method: str, smoothing_method="sgolay", smoothing_parameter=0.04,
            smoothing_location="all", output_size=None):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 09.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This function calculates the DVA or ICA of a given input file (.csv / .mat).
    # ------------
    # Input: data_path: String, path to data
    #        calc_method: String, DVA or ICA
    # Options: smoothing_method: ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use; default: sgolay
    #          smoothing_parameter: Float, how much the data is smoothed; default: 0.04
    #          smoothing_location: ["U", "I", "Output", "all"], what do you want to smooth; default: "all"
    #          output_size: Integer, size of the output, must be smaller or equal of input size; default: input size
    # ------------
    # Output: Struct with time, DVA and normed DVA or ICA, charge, SOC
    # ------------

    # Import Data
    DVAData = parseInput(data_path, calc_method, smoothing_method, smoothing_parameter, smoothing_location, output_size)

    # Thin Out Data / Reduce Number of Data Points
    DVAData = thinOutData(DVAData)

    # Smooth Input Data
    # --> Smooth U
    if DVAData["smoothing_location"] in ["U", "all"]:
        DVAData["U"] = smoothingDVA(DVAData["U"], DVAData["time"], DVAData["smoothing_method"],
                                    DVAData["smoothing_parameter"])

    # --> Smooth I
    if DVAData["smoothing_location"] in ["I", "all"]:
        DVAData["I"] = smoothingDVA(DVAData["I"], DVAData["time"], DVAData["smoothing_method"],
                                    DVAData["smoothing_parameter"])

    # Calculate DVA and ICA
    # --> Calculate DVA
    dt = np.diff(DVAData["time"])
    dU = np.diff(DVAData["U"]) / dt
    DVAData["DVA"] = dU / DVAData["I"][1:]

    # --> Calculate ICA
    if DVAData["calc_method"] == "ICA":
        DVAData["ICA"] = np.ones(np.size(DVAData["DVA"])) / DVAData["DVA"]

    # Calculate Charge
    DVAData["Charge"] = scipy.integrate.cumtrapz(np.abs(DVAData["I"]), DVAData["time"])

    # Calculate Axis
    # --> Calculate SOC
    total_charge = DVAData["Charge"][-1] - DVAData["Charge"][0]
    DVAData["SOC"] = np.array(
        [(DVAData["Charge"][-1] - DVAData["Charge"][i]) / total_charge for i in range(len(DVAData["Charge"]))])

    # --> Calculate the DVA normed to Charge Q
    DVAData["DVA_Qnorm"] = DVAData["DVA"] * DVAData["Charge"][-1]

    # Smoothing Output Data
    # --> Smooth DVA
    if DVAData["smoothing_location"] in ["Output", "all"]:
        DVAData["DVA"] = smoothingDVA(DVAData["DVA"], DVAData["time"][1:], DVAData["smoothing_method"],
                                      DVAData["smoothing_parameter"])

    # --> Smooth ICA
    if DVAData["calc_method"] == "ICA":
        if DVAData["smoothing_location"] in ["Output", "all"]:
            DVAData["ICA"] = smoothingDVA(DVAData["ICA"], DVAData["time"][1:], DVAData["smoothing_method"],
                                          DVAData["smoothing_parameter"])

    # Process Output Data
    DVAData = processDVA(DVAData)

    # Build return variable
    DVAOutput = {
        "time": DVAData["time"],
        "Charge": DVAData["Charge"],
        "SOC": DVAData["SOC"]
    }

    # --> Return either DVA or ICA depending on calculation method
    if DVAData["calc_method"] == "ICA":
        DVAOutput["ICA"] = DVAData["ICA"]
    else:
        DVAOutput["DVA"] = DVAData["DVA"]
        DVAOutput["DVA_Qnorm"] = DVAData["DVA_Qnorm"]

    return DVAOutput
