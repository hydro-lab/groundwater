%% Sophia Bakar
% Plot cumulative avg precip
% January 2nd, 2020
 
% Thiessen Areall Average Method for Precipitation
[~, ~, raw] = xlsread('C:\Users\bakar\Documents\MATLAB\Limpopo Project\WeatherStationWeights.xlsx','Sheet1','B2:B32');
TotalAreasqkm = reshape([raw{:}],size(raw));
WeatherStationWeights = table;
WeatherStationWeights.TotalAreasqkm = TotalAreasqkm(:,1);
clearvars TotalAreasqkm raw;
a = WeatherStationWeights;
A = table2array(a);
p1 = readtable('PrecipData.xlsx','Sheet','2009-2010','Range','B1:AF13');
p1_a = table2array(p1);
p1_t = transpose(p1_a);
P1 = A.*p1_t;
avg_p1 = sum(P1)/sum(A);

p2 = readtable('PrecipData.xlsx','Sheet','2010-2011','Range','B1:AF13');
p2_a = table2array(p2);
p2_t = transpose(p2_a);
P2 = A.*p2_t;
avg_p2 = sum(P2)/sum(A);

p3 = readtable('PrecipData.xlsx','Sheet','2011-2012','Range','B1:AF13');
p3_a = table2array(p2);
p3_t = transpose(p3_a);
P3 = A.*p3_t;
avg_p3 = sum(P3)/sum(A);

p4 = readtable('PrecipData.xlsx','Sheet','2012-2013','Range','B1:AF13');
p4_a = table2array(p4);
p4_t = transpose(p4_a);
P4 = A.*p4_t;
avg_p4 = sum(P4)/sum(A);

p5 = readtable('PrecipData.xlsx','Sheet','2013-2014','Range','B1:AF13');
p5_a = table2array(p5);
p5_t = transpose(p5_a);
P5 = A.*p5_t;
avg_p5 = sum(P5)/sum(A);

p6 = readtable('PrecipData.xlsx','Sheet','2014-2015','Range','B1:AF13');
p6_a = table2array(p6);
p6_t = transpose(p6_a);
P6 = A.*p6_t;
avg_p6 = sum(P6)/sum(A);

p7 = readtable('PrecipData.xlsx','Sheet','2015-2016','Range','B1:AF13');
p7_a = table2array(p7);
p7_t = transpose(p7_a);
P7 = A.*p7_t;
avg_p7 = sum(P7)/sum(A);

p8 = readtable('PrecipData.xlsx','Sheet','2016-2017','Range','B1:AF13');
p8_a = table2array(p8);
p8_t = transpose(p8_a);
P8 = A.*p8_t;
avg_p8 = sum(P8)/sum(A);

p9 = readtable('PrecipData.xlsx','Sheet','2017-2018','Range','B1:AF13');
p9_a = table2array(p9);
p9_t = transpose(p9_a);
P9 = A.*p9_t;
avg_p9 = sum(P9)/sum(A);

p10 = readtable('PrecipData.xlsx','Sheet','2018-2019','Range','B1:AF13');
p10_a = table2array(p10);
p10_t = transpose(p10_a);
P10 = A.*p10_t;
avg_p10 = sum(P10)/sum(A);


%Plot datasets
months =(1:1:12);
plot(months,avg_p1);
hold on
plot(months,avg_p2);
plot(months,avg_p3);
plot(months,avg_p4);
plot(months,avg_p5);
plot(months,avg_p6);
plot(months,avg_p7);
plot(months,avg_p8);
plot(months,avg_p9);
plot(months,avg_p10);
hold off
title('Average Monthly Precipitation (mm)')
xticks(1:1:12);
xticklabels({'August','September','October','November','December','January','February','March','April','May','June','July'})
legend('2009-2010','2010-2011','2011-2012','2012-2013','2013-2014','2014-2015','2015-2016','2016-2017','2017-2018','2018-2019')
ylim([0 200]);
xlim([0.5 12.5])


