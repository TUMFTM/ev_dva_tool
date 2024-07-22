%% Demo Skript showcasing the latest version of the DVA Tool
% 21.12.2022
% Default: Savitzky Golay; Output Size 2000; Smoothing Location == all;

%% Default Tesla Pack

filepath = "/Users/jonasgohmann/ev-dva/data_in/tesla_pack_2021_charge.csv";
 
DVAOutput = calcDVA(filepath, "DVA");


%Plot
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)
ylim([-0.00001 0.0003])
xlabel('SOC in %'); ylabel('dV/dQ in V/Ah')
title('DVA')
set(gca, 'FontSize', 15)

%% Default Tesla cell

filepath = "/Users/jonasgohmann/ev-dva/data_in/tesla_cell_c40_discharge.csv";

DVAOutput = calcDVA(filepath, "DVA");


%Plot
figure
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)
ylim([-0.0001 0.007])
xlabel('SOC in %'); ylabel('dV/dQ in V/Ah')
title('DVA')
set(gca, 'FontSize', 14)

%% Default VW LG 78Ah

filepath = "/Users/jonasgohmann/ev-dva/data_in/AMS_LG_VW_78Ah_1964_LG_discharge.csv";

DVAOutput = calcDVA(filepath, "DVA");


%Plot
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)
ylim([0 0.035])
xlabel('SOC in %'); ylabel('dV/dQ in V/Ah')
title('DVA')
set(gca, 'FontSize', 15)

%% Default Knopfzelle

filepath = "/Users/jonasgohmann/ev-dva/data_in/Knopfzellen_Manu.csv";

DVAOutput = calcDVA(filepath, "DVA");

%Plot
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)
ylim([0 0.0002])
xlabel('SOC in %'); ylabel('dV/dQ in V/mAs')
title('DVA')
set(gca, 'FontSize', 15)

%% Variation Input Parameter Tesla cell

filepath = "/Users/jonasgohmann/ev-dva/data_in/tesla_cell_c40_discharge.csv";


DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "spline", "Smoothing Parameter", 10, "Output Size", 2000);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.001);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "movmean", "Smoothing Parameter", 0.04, "Output Size", 30);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "movmean", "Smoothing Parameter", 0.001);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "movmean", "Smoothing Parameter", 0.1);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "movmean", "Smoothing Parameter", 0.04, "Smoothing Location", "Output");
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "movmean", "Smoothing Parameter", 0.04, "Smoothing Location", "U");
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.99);

%Plot
figure
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)
ylim([-0.0001 0.007])
xlabel('SOC in %'); ylabel('dV/dQ in V/Ah')
title('DVA')
set(gca, 'FontSize', 15)


%% Variation VW normed Charge

filepath = "/Users/jonasgohmann/ev-dva/data_in/AMS_LG_VW_78Ah_1964_LG_discharge.csv";

DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.85);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.01);
%DVAOutput = calcDVA(filepath, "DVA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.9999);



%Plot
plot(DVAOutput.SOC, DVAOutput.DVA_Qnorm, 'LineWidth', 2)
ylim([0 3])
xlabel('SOC in %'); ylabel('dV/dQ in V')
title('DVA normed Charge')
set(gca, 'FontSize', 15)

%% Variation VW normed Charge ICA


filepath = "/Users/jonasgohmann/ev-dva/data_in/AMS_LG_VW_78Ah_1964_LG_discharge.csv";

DVAOutput = calcDVA(filepath, "ICA", "Smoothing Method", "cubic", "Smoothing Parameter", 0.85);



%Plot
plot(DVAOutput.SOC, DVAOutput.ICA, 'LineWidth', 2)

xlabel('SOC in %'); ylabel('dQ/DV in Ah/V')
title('ICA')
set(gca, 'FontSize', 15)

%% Plotter

figure
plot(DVAOutput.SOC, DVAOutput.DVA, 'LineWidth', 2)

xlabel('SOC in %'); ylabel('dV/dQ in ???')
title('DVA')
set(gca, 'FontSize', 15)