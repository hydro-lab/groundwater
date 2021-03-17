%% Cumulative Precipitation
% Sophia Bakar

% Thiessen Areall Average Method
[~, ~, raw] = xlsread('C:\Users\bakar\Documents\MATLAB\Limpopo Project\WeatherStationWeights.xlsx','Sheet1','B2:B32');
TotalAreasqkm = reshape([raw{:}],size(raw));
WeatherStationWeights = table;
WeatherStationWeights.TotalAreasqkm = TotalAreasqkm(:,1);
clearvars TotalAreasqkm raw;
a = WeatherStationWeights;
A = table2array(a);

precip = 'PrecipData.xlsx';
sheetnames = {'2009-2010','2010-2011','2011-2012','2012-2013','2013-2014','2014-2015','2015-2016','2016-2017','2017-2018','2018-2019'};
n = length(sheetnames);
P = zeros(n,12);
for i = 1:n
    data = transpose(xlsread(precip,sheetnames{i}));
    P(i,:) = (A'*(data(:,1:12)))./sum(A);
end
for i = 1:n
    for j = 1:12
        c(i,j) = sum(P(i,1:j));
    end
end

months =(1:1:12);
plot(months,c)
title('Cumulative Monthly Precipitation')
ylabel('Precipitation (mm)')
xlabel('Month')
xticks(1:1:12);
xticklabels({'August','September','October','November','December','January','February','March','April','May','June','July'})
legend('2009-2010','2010-2011','2011-2012','2012-2013','2013-2014','2014-2015','2015-2016','2016-2017','2017-2018','2018-2019')
ylim([0 750]);
xlim([0.5 12.5])
