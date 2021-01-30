%% Sophia Bakar
% Plot Monthly Avg Precipitation Data vs GLDAS Data from NASA
% January 2nd, 2020
 
% Thiessen Areall Average Method for Precipitation
A = xlsread('WeatherStationWeights.xlsx','B2:B40'); % polygon areas calculated in QGIS
p = xlsread('LimpopoPrecipitationData.xlsx','July','B2:L40'); 
p_nonan = ~isnan(p);
P = A.*p_nonan;
avg_p = transpose(sum(P)/sum(A));

% GLDAS Data
GLDAS_RA = transpose(xlsread('GLDAS.xlsx','Ramotswa Aquifer','B13:M13'));
GLDAS_S = transpose(xlsread('GLDAS.xlsx','Soutpansberg Mountains','B13:M13'));
GLDAS_P = transpose(xlsread('GLDAS.xlsx','Phalaborwa','B13:M13'));

% GRACE Data
GRACE_RA = transpose(xlsread('GRACE.xlsx','Ramotswa Aquifer','B13:M13'));
GRACE_S = transpose(xlsread('GRACE.xlsx','Soutpansberg Mountains','B13:M13'));
GRACE_P = transpose(xlsread('GRACE.xlsx','Phalaborwa','B13:M13'));

%Plot datasets
year = (2010:1:2020);
figure;
subplot(3,1,1);
plot(year, GLDAS_RA);
hold on
plot(year, GLDAS_S);
plot(year, GLDAS_P)
hold off
title('GLDAS (mm)');

subplot(3,1,2);
plot(year, GRACE_RA);
hold on
plot(year, GRACE_S);
plot(year, GRACE_P)
hold off
title('GRACE - Water Equivalent Thickness');
legend('Ramotswa Aquifer','Soutpansberg Mountains','Phalaborwa');

subplot(3,1,3);
plot(year, avg_p)
title('Average Precipitation (mm)');



