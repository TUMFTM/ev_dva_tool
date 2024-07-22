# EV DVA

This repository unites all the FTM EV Lab's Differential Voltage Analysis (DVA) tools in a single place for future publication (-> Github) and use in scientific publications.
There is a version for MATLAB and one for Python.

## Authors and acknowledgment
This code was created by Jonas Göhmann and Lukas Leonard Köning during their time as Student Assistants at the Institute of Automotive technology of the Technical University of Munich.

## Features
- Calculation of Differential Voltage Analysis (DVA) and Incremental Capacity Analysis (ICA)
- Different smoothing methods
- Different smoothing location (which data to smooth)
- Noise detection with recommendations for smoothing parameter changes
- Scripts for automatic DVA calculation for multiple files

## How to run

### Single file
To use the DVA Tool simply use the function `calcDVA(filepath, "DVA")`. Examples are shown below.

Two inputs are mandatory:
- filepath = (string) path to input file
- calculation method = (string) either "DVA" or "ICA"

Below you can find two examples:

```python
output = calcDVA(filepath, "DVA")
output = calcDVA("C:\Users\(User_Name)\Documents\lib_discharge.csv", "ICA")
``` 

### Multiple files
A second option is, to calculate the DVA of multiple files. Simply use
- the `RunMe.m` file for MATLAB or
- the `main.py` for Python.

These will calculate the DVA for all files within the `data_in` folder. The results will be saved either as .mat-file (MATLAB) or as .pickle-file (Python) in the `data_out` folder.

### Options
The user can also add a number of additional input arguments to control
- the smoothing method,
- the amount of smoothing, 
- which data to smooth or 
- the output size. 

For more details on this, please refer to the following section.

## Input data
__Matlab__: .mat-file or .csv-file containing a matrix with raw time, voltage and current data as separate columns

__Python__: .csv-file containing a matrix with raw time, voltage and current data as separate columns

### Required input variables:
- Datapath: (string) file path to input file
- Calculation method: (string) "DVA" or "ICA"

### Optional input variables:

- Smoothing Method: (string) what smoothing method one want to use, must be "cubic", "sgolay", "movmean" or "spline" (default: "sgolay")
- Smoothing Parameter: (float) how much the data is smoothed (default: 0.04)
- Smoothing Location: (string) which data should be smoothed, must be "U", "I", "Output" or "all" (default: "all")
- Output Size: (integer) size of the output, must be smaller or equal of input size (default: input size)

How to define these options depends on the coding language. Following are examples for MATLAB and Python.

#### MATLAB
```python
Output = calcDVA(filepath, "DVA", "Smoothing Method", "spline", "Smoothing Parameter", 10, "Smoothing Location", "all", "Output Size", 1000)
```

#### Python
```python
DVA = calcDVA("../data_in/Samsung35E_CU0.csv", "DVA", smoothing_method="sgolay", smoothing_parameter=0.03, smoothing_location="all")
```

## Output data

__Matlab__: struct with time, DVA and normed DVA or ICA, charge, SOC

__Python__: dictionary of numpy arrays with the same content as the Matlab struct

The output is always formatted as SOC 0-100% in positive x-axis regardless of whether the input was a discharge or charge measurement.

The result could look like on the follow image:

![Example result of DVA-Tool](/assets/example_result.png)

## Installation
The MATLAB code should run in all native MATLAB environments. To install the required packages for the python code, one could use the `requirements.txt`-file in the `python`-folder.
For development the following software versions were used:
- MATLAB R2020b (tested also in R2022b).
- Python 3.11

## Documentation
In the following sections one can find more information on the tool and its implementation.

### Smoothing
Different smoothing options are implemented. The user can choose between cubic smoothing spline, Savitzky Golay, moving mean and a combination of spline smoothing and thining out the data.
- cubic smoothing spline
  - **method identifier**: "cubic"
  - uses the cubic smoothing spline interpolation to smooth the given data
  - **smoothing parameter** is a value between 0 and 1
    - Values closer to 0 result in stronger smoothing with the extreme of a resulting straight line with a smoothing parameter of 0. 
    - Values closer to 1 will result in fewer smoothing with the extreme of the value 1 resulting in a cubic interpolation with no smoothing at all.
- Savitzky Golay filter: 
  - **method identifier**: "sgolay"
  - smooths according to a quadratic polynomial that is fitted over each window of the input data. 
  - **smoothing parameter** is a value between 0 and 1 (excluding 0)
    - corresponds to the window size used for the smoothing algorithm. 
    - window size is calculated by `windowsize = smoothing paramter * length of the input data`. 
    - Values closer to 0 result in fewer smoothing, however 0 can not be used. 
    - Values closer to 1 will result in stronger smoothing with the extreme of the value 1 resulting in a straight line.
- moving mean: 
  - **method identifier**: "movmean"
  - moving average over each window of the input data
  - **smoothing parameter** is a value between 0 and 1 (excluding 0)
    - corresponds to the window size used for the smoothing algorithm. 
    - window size is calculated by `windowsize = smoothing paramter * length of the input data`
    - Values closer to 0 result in fewer smoothing, however 0 can not be used. 
    - Values closer to 1 will result in stronger smoothing with the extreme of the value 1 resulting in a straight line.
- spline filtering: 
  - **method identifier**: "spline"
  - combination of thinning out the data by using every n_th datapoint and performing spline interpolation
  - The interpolation is based on cubic spline. 
  - **smoothing parameter** corresponds to the n_th data point that will be used in the thinning out
    - e.g. smoothing Parameter 5 = every 5th point of the input data will be used. 
    - All other data points will be deleted. 
    - value between 1 and the length of the inputdata
    - The bigger the smoothing parameter, the more smoothing. 
    - Smoothing parameters around 10 will often result in usable smoothing.

### Units

The DVA Tool accepts various units as input. However, the user has to keep in mind which units will result from the input. 

As a help common input units and there corresponding output units are listed in the table below:

| Input Unit                                          | Output Unit                                            | 
|-----------------------------------------------------|--------------------------------------------------------|
| time in s<br />voltage U in V <br />current I in mA | DVA in V/mAs<br />Charge in mAs <br />DVA_Qnormed in V |
| time in h<br />voltage U in V <br />current I in A  | DVA in V/Ah<br />Charge in Ah <br />DVA_Qnormed in V   |

### Open tasks
- [ ] Adaption of the LAB2MAT script, such that it outputs the data in the correct input format for this tool
- [ ] Expand tool to pack DVA (--> number series and parallel cells)
- [ ] Add discussion of smoothing methods
- [ ] second derivative of DVA
- [ ] Input of Q0 for DVA scaling
- [ ] Smoothing option for ICA (first smooth DVA then calculate ICA and not smooth ICA)

### Literature

| Author            | Title                                                                                                               | Year | DOI                                            | short description  |
|-------------------|---------------------------------------------------------------------------------------------------------------------|------|------------------------------------------------|--------------------|
| I. Bloom et al.   | Differential voltage analyses of highpower, lithium-ion cells: 1. technique and application                         | 2005 | https://doi.org/10.1016/j.jpowsour.2004.07.021 | Method description |
| H. M. Dahn et al. | User-friendly differential voltage analysis freeware for the analysis of degradation mechanisms in li-ion batteries | 2012 | https://doi.org/10.1149/2.013209jes            | Application        |
| M. Dubarry et al. | Best practices for incremental capacity analysis                                                                    | 2022 | https://doi.org/10.3389/fenrg.2022.1023555     | ICA Application    |

## License
TO BE DEFINED!

## Project status
This repository includes working implementations of the DVA tool for MATLAB and Python (2022-02-23).
Further work and documentation should be done according to the `Open tasks` section of the documentation.
