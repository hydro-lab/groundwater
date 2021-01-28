%% Sophia Bakar
% Plot Monthly Avg Precipitation Data vs GLDAS Data from NASA
% January 2nd, 2020

% Thiessen Areall Average Method for Precipitation
A = xlsread('WeatherStationWeights.xlsx','B2:B40'); % polygon areas calculated in QGIS
p = xlsread('LimpopoPrecipitationData.xlsx','August','B2:L40'); 
p_nonan = ~isnan(p);
P = A.*p_nonan;
avg_p = sum(P)/sum(A);


% GLDAS Data
GLDAS_RamotswaAquifer = transpose(xlsread('GLDAS.xlsx','Ramotswa Aquifer','B2:M2'));
GLDAS_Soutpansberg = transpose(xlsread('GLDAS.xlsx','Soutpansberg Mountains','B2:M2'));
GLDAS_Phalaborwa = transpose(xlsread('GLDAS.xlsx','Phalaborwa','B2:M2'));

% GRACE Data
GRACE_RamotswaAquifer = transpose(xlsread('GRACE.xlsx','Ramotswa Aquifer','B2:M2'));
GRACE_Soutpansberg = transpose(xlsread('GRACE.xlsx','Soutpansberg Mountains','B2:M2'));
GRACE_Phalaborwa = transpose(xlsread('GRACE.xlsx','Phalaborwa','B2:M2'));

%Plot datasets
tbl = table(avg_p, GLDAS_RamotswaAquifer, GLDAS_Soutpansberg, GLDAS_Phalaborwa, GRACE_RamotswaAquifer, GRACE_Soutpansberg, GRACE_Phalaborwa);
vars = {avg_p, {'GLDAS_RamotswaAquifer', 'GLDAS_Soutpansberg','GLDAS_Phalaborwa'},{'GRACE_RamotswaAquifer','GRACE_Soutpansberg','GRACE_Phalaborwa'}};
stackedplot(tbl, vars)



