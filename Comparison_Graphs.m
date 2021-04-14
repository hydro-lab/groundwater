%% Sophia Bakar
% March 2021
% GLDAS - Terrestrial Water Storage 

RA = readtable('RamotswaAquifer_CLM.csv');
P = readtable('Phalaborwa_CLM.csv');
SM = readtable('SoutpansbergMountains_CLM.csv');

RA_CLM = str2double(table2array(RA(8:4025,2)));
P_CLM = str2double(table2array(P(8:4025,2)));
SM_CLM = str2double(table2array(SM(8:4025,2)));


t1 = datetime(2009,08,01,12,0,0);
t2 = datetime(2020,07,31,12,0,0);
t = t1:t2;
t = t';
clear t1 t2
RA_New = timetable(t, RA_CLM);
RA_MonthlyAve = retime(RA_New, 'monthly', 'mean'); 
P_New = timetable(t, P_CLM);
P_MonthlyAve = retime(P_New, 'monthly', 'mean'); 
SM_New = timetable(t, SM_CLM);
SM_MonthlyAve = retime(SM_New, 'monthly', 'mean'); 
%% Soil Moisture

%% Precip @ Areas of Interest
RA_Precip = 'RA_Precip.xlsx';
P_Precip = 'P_Precip.xlsx';
SM_Precip = 'SM_Precip.xlsx';
sheetnames = {'2009-2010','2010-2011','2011-2012','2012-2013','2013-2014','2014-2015','2015-2016','2016-2017','2017-2018','2018-2019'};
n = length(sheetnames);
RA_P = zeros(n,12);
P_P = zeros(n,12);
SM_P = zeros(n,12);
for i = 1:n
    RA_data = transpose(xlsread(RA_Precip,sheetnames{i}));
    RA_P(i,:) = (sum(RA_data(:,1:12)))/9;
end
for i = 1:n
    for j = 1:12
        RA_c(i,j) = sum(RA_P(i,1:j));
    end
end

for i = 1:n
    P_data = transpose(xlsread(P_Precip,sheetnames{i}));
    P_P(i,:) = (sum(P_data(:,1:12)))/8;
end
for i = 1:n
    for j = 1:12
        P_c(i,j) = sum(P_P(i,1:j));
    end
end
for i = 1:n
    SM_data = transpose(xlsread(SM_Precip,sheetnames{i}));
    SM_P(i,:) = (sum(SM_data(:,1:12)))/5;
end
for i = 1:n
    for j = 1:12
        SM_c(i,j) = sum(SM_P(i,1:j));
    end
end

% there appears to be a problem here:
% RA_c_linear = RA_c(:);
% P_c_linear = P_c(:);
% SM_c_linear = SM_c(:);
% instead, try:
for i = 1:n % by year
    for j = 1:12 % by month
        RA_c_linear((i-1)*12+j) = RA_c(i,j);
    end
end


% GRACE Mascon Solutions

[finfo, outstrct2] = read_nc_file_struct('GRCTellus.JPL.200204_202011.GLO.RL06M.MSCNv02CRI.nc');
we_thickness_CRI = (outstrct2);

P_wet = we_thickness_CRI.lwe_thickness(60:62,131:133,85:191);
SM_wet = we_thickness_CRI.lwe_thickness(58:63,130:136,85:191);
RA_wet = we_thickness_CRI.lwe_thickness(54:66,129:133,85:191);

x(1,:) = (mean(mean(SM_wet))).*10; 
y(1,:) = mean(mean(P_wet)).*10;
z(1,:) = mean(mean(RA_wet)).*10;


%% Plotting
months = (1:1:132);
month = (1:1:120);
figure;
subplot(3,1,1);
yyplot left % added for different y axis
plot(months, RA_MonthlyAve{:,1},'LineWidth',1);
hold on
plot(month, RA_c_linear)
ylim([0 800]) % added to force same range for both y-axes since they are both mm water.
ylabel('Water Level (mm)') % added
yyaxis right % added for second y-axis
plot(z(1,:),'LineWidth',1) % removed color so it inherits color from second axis
ylim([-400 400]) % ensure both y-axes have the same range
ylabel('Equivalent Thickness (mm)')
hold off
title('Ramotswa Aquifer: August 2009 - July 2020');
% ylabel('mm')
xlabel('Year')
legend('GLDAS - Terrestrial Water Storage','Cumulative Precipitation','GRACE - Water Equivalent Thickness');


subplot(3,1,2);
plot(months, P_MonthlyAve{:,1},'LineWidth',1)
hold on
plot(month, P_c_linear)
plot(y(1,:),'LineWidth',1,'Color','y')
hold off
title('Phalaborwa: August 2009 - July 2020');
ylabel('(mm)')
xlabel('Year')

subplot(3,1,3);
plot(months, SM_MonthlyAve{:,1},'LineWidth',1)
hold on
plot(month, SM_c_linear)
plot(x(1,:),'LineWidth',1,'Color','y')
hold off
title('Soutpansberg Mountains: August 2009 - July 2020');
ylabel('(mm)')
xlabel('Year')
