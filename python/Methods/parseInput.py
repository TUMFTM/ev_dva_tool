import os
import csv
import numpy as np


def parseInput(data_path: str, calc_method: str, smoothing_method="sgolay", smoothing_parameter=0.04,
               smoothing_location="all", output_size=None):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 22.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This functions reads and parses the input of the DVA tool.
    # ------------
    # Input: data_path: String, path to data
    #        calc_method: String, DVA or ICA
    # Options: smoothing_method: ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use; default: sgolay
    #          smoothing_parameter: Float, how much the data is smoothed; default: 0.04
    #          smoothing_location: ["U", "I", "Output", "all"], what do you want to smooth; default: "all"
    #          output_size: Integer, size of the output, must be smaller or equal of input size; default: input size
    # ------------
    # Output: Dictionary of input variables
    # ------------

    # Pretasks
    input_dict = {"time": [], "U": [], "I": []}

    # --- Read data from file ---
    # Perform prechecks
    if not os.path.isfile(data_path):
        raise TypeError("First input argument must be a path to a file!")

    # Read in data depending on file format
    if data_path[-4:] == ".csv":
        file = open(data_path)
        csvreader = csv.reader(file)
        header = next(csvreader)
        data_matrix = []
        for r in csvreader:
            data_matrix.append(r)
        file.close()
    else:
        raise TypeError("Data input file must be csv-file.")

    # Check size of input
    if len(data_matrix[0]) < 3:
        raise ValueError("Input data size to small (" + str(len(data_matrix[0])) + ")! Is data missing?")
    elif len(data_matrix[0]) > 3:
        raise ValueError("Input data size to big (" + str(len(data_matrix[0])) + ")! Is data missing?")

    # TODO: Maybe perform further data validation here.

    # Parse input data into dictionary
    for j in range(len(data_matrix)):
        input_dict["time"].append(float(data_matrix[j][0]))
        input_dict["U"].append(float(data_matrix[j][1]))
        input_dict["I"].append(float(data_matrix[j][2]))
    input_dict["time"] = np.array(input_dict["time"])
    input_dict["U"] = np.array(input_dict["U"])
    input_dict["I"] = np.array(input_dict["I"])

    # --- Determine calculation method ---
    if not (calc_method == "DVA" or calc_method == "ICA"):
        raise ValueError("Wrong calculation method. Options are 'DVA' or 'ICA'.")
    input_dict["calc_method"] = calc_method

    # --- Parse options ---
    # Output size
    if output_size is None:
        input_dict["output_size"] = len(data_matrix)
    else:
        if output_size < 1:
            raise ValueError("Output Size has to be 1 or bigger.")
        if not type(output_size) is int:
            raise ValueError("Output Size must be an integer value.")
        if output_size > len(data_matrix):
            raise ValueError("Output Size must be smaller than Input Size.")
        input_dict["output_size"] = output_size

    # Smoothing location
    if smoothing_location in ["U", "I", "Output", "all"]:
        input_dict["smoothing_location"] = smoothing_location
    else:
        raise ValueError("Wrong Smoothing Location. Input must be either I, U, Output, or all.")

    # Smoothing method
    if smoothing_method in ["cubic", "sgolay", "movmean", "spline"]:
        input_dict["smoothing_method"] = smoothing_method
    else:
        raise ValueError("Wrong Smoothing Method. Input must be either cubic, sgolay, movmean or spline.")

    # Smoothing parameter
    input_dict["smoothing_parameter"] = smoothing_parameter

    return input_dict
