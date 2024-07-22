from Methods.calcDVA import calcDVA
import matplotlib.pyplot as plt
import glob
import os.path
import pickle


def calculate_DVA_for_input_files(smoothing_method="sgolay", smoothing_parameter=0.04, smoothing_location="all",
                                  output_size=None):
    # Designed by: Lukas Köning (FTM, Technical University of Munich)
    # -------------
    # Created on: 23.02.2023
    # ------------
    # Version: Python 3.11
    # ------------
    # Description: This function calculates the DVA of all given input file (.csv) that are located in the
    #              data_in folder and saves the pickle file in the data_out folder.
    # ------------
    # Input:   .csv files in data_in folder with time, voltage and current as columns
    # Options: smoothing_method: ["cubic", "sgolay", "movmean", "spline"], which smoothing method do you want to use;
    #                            default: sgolay
    #          smoothing_parameter: Float, how much the data is smoothed; default: 0.04
    #          smoothing_location: ["U", "I", "Output", "all"], what do you want to smooth; default: "all"
    #          output_size: Integer, size of the output, must be smaller or equal of input size; default: input size
    # ------------
    # Output: pickle file with time, DVA and normed DVA or ICA, charge, SOC saved in the data_out folder
    # ------------
    print('Initialize...')

    # Collect all csv files
    filelist = []
    for file in glob.glob(os.path.join("..", "data_in", "*csv")):
        filelist.append(file)

    if len(filelist) == 0:
        print("No measurements to process. Please check data_in folder.")
        return

    # Run Main Loop for DVA calculation and saving
    for i in range(len(filelist)):
        file = filelist[i]
        print("Processing file {}...".format(i + 1))

        try:
            DVAOutput = calcDVA(file, "DVA", smoothing_method=smoothing_method, smoothing_parameter=smoothing_parameter,
                                smoothing_location=smoothing_location)
        except Exception as ex:
            print("--> File {}: Failed to calculate DVA ({})!".format(i + 1, str(ex)))
            continue

        # Save results to pickle file
        filename = file.split(os.path.sep)[-1]
        with open(os.path.join("..", "data_out", filename[:-4] + ".pickle"), 'wb') as f:
            pickle.dump(DVAOutput, f)

        print("--> File {}: Saved successfully!".format(i + 1))


if __name__ == "__main__":
    # Function to evaluate all files in data_in folder
    # Calculates only the DVA!
    # Optional parameters are set so default
    calculate_DVA_for_input_files()

    # Example to run code on one Datafile and plot the results
    DVA = calcDVA("../data_in/Samsung35E_CU0.csv", "DVA", smoothing_method="sgolay", smoothing_parameter=0.03,
                  smoothing_location="all")

    plt.plot(DVA["Charge"], DVA["DVA"])
    plt.xlabel("Charge throughput in Ah")
    plt.ylabel("DVA in V/Ah")
    plt.title("Example DVA plotted over the charge throughput")
    plt.show()
