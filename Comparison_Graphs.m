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

for i = 1:n % by year
    for j = 1:12 % by month
        RA_c_linear((i-1)*12+j) = RA_c(i,j);
    end
end
for i = 1:n % by year
    for j = 1:12 % by month
       SM_c_linear((i-1)*12+j) = SM_c(i,j);
    end
end
for i = 1:n % by year
    for j = 1:12 % by month
        P_c_linear((i-1)*12+j) = P_c(i,j);
    end
end

%% GRACE Mascon Solutions

x = xlsread('GRACE_WET.xlsx','Phalaborwa'); %phalaborwa water equiv. thickness
y = xlsread('GRACE_WET.xlsx','Ramotswa Aquifer'); % ramotswa aquifer water equiv. thickness
z = xlsread('GRACE_WET.xlsx','Soutpansberg Mountains'); %soutpansberg mountains water equiv. thickness

x(x==0) = NaN;
y(y==0) = NaN;
z(z==0)= NaN;

%% Plotting
months = (1:1:132);
month = (1:1:120);
figure;
subplot(3,1,1);
yyaxis left
plot(months, RA_MonthlyAve{:,1},'LineWidth',1);
hold on
plot(month, RA_c_linear)
ylim([0 800]);
ylabel('Water Level (mm)');
yyaxis right
plot(z(1,:),'LineWidth',1)
ylim([-400 400]);
ylabel('Equivalent Thickness (mm)')
hold off
title('Ramotswa Aquifer: August 2009 - July 2020');
ylabel('mm')
xlabel('Year')
legend('GLDAS - Terrestrial Water Storage','Cumulative Precipitation','GRACE - Water Equivalent Thickness');
xticks(1:12:144);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'})

subplot(3,1,2);
yyaxis left
plot(months, P_MonthlyAve{:,1},'LineWidth',1)
hold on
plot(month, P_c_linear)
ylim([0 1200]);
ylabel('Water Level (mm)');
yyaxis right
plot(y(1,:),'LineWidth',1)
ylim([-600 600]);
ylabel('Equivalent Thickness');
hold off
title('Phalaborwa: August 2009 - July 2020');
ylabel('(mm)')
xlabel('Year')
xticks(1:12:144);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'})

subplot(3,1,3);
yyaxis left
plot(months, SM_MonthlyAve{:,1},'LineWidth',1)
hold on
plot(month, SM_c_linear)
ylim([0 1000])
ylabel('Water Level (mm)');
yyaxis right
plot(x(1,:),'LineWidth',1)
ylim([-500 500]);
ylabel('Equivalent Thickness');
hold off
title('Soutpansberg Mountains: August 2009 - July 2020');
ylabel('(mm)')
xlabel('Year')
xticks(1:12:144);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020'})
