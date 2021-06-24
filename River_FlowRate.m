%% Sophia Bakar
% June 2021
% River Gage - Flow Rate Data 
% Sand River, Mutale River, and Olifants (near phalaborwa)

S_Waterpoort = readtable('A7H010_FLOW.csv'); %sand river at waterpoort
S_Pietersburg = readtable('Sand_Pietersburg.csv'); %sand river at pietersburg
M_Kruger = readtable('Mutale_Kruger.csv'); % mutale river at kruger
O_Oxford = readtable('Olifants_Oxford.csv'); %olifants river at oxford


SRW_data = str2double(table2array(S_Waterpoort(2590:6241,3))); % data during time period of interest
SP_data = table2array(S_Pietersburg(1:3652,2));
MK_data = table2array(M_Kruger(1:3652,2));
OO_data = table2array(O_Oxford(1:3652,2));

t1 = datetime(2009,08,01,12,0,0);
t2 = datetime(2019,07,31,12,0,0);
t = t1:t2;
t = t';
clear t1 t2

SRW_New = timetable(t, SRW_data);
SP_New = timetable(t, SP_data);
MK_New = timetable(t, MK_data);
OO_New = timetable(t, OO_data);

SRW_MonthlyAve = retime(SRW_New, 'monthly', 'mean'); 
SP_MonthlyAve = retime(SP_New, 'monthly', 'mean'); 
MK_MonthlyAve = retime(MK_New, 'monthly', 'mean'); 
OO_MonthlyAve = retime(OO_New, 'monthly', 'mean'); 


% Plotting
months = (1:1:120);
figure;
subplot(2,1,1);
plot(months, SRW_MonthlyAve{:,1},'LineWidth',1);
hold on
plot(months, SP_MonthlyAve{:,1});
plot(months, MK_MonthlyAve{:,1});
xticks(0:12:120);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'});
legend('Sand - Waterpoort','Sand - Pietersburg','Mutale - Kruger');
title('River Flow Rate (Sand and Mutale Rivers)');
ylabel('flow rate (m^3/s)')
hold off
subplot(2,1,2);
plot(months, OO_MonthlyAve{:,1});
title('River Flow Rate(Olifants River)');
ylabel('flow rate (m^3/s)')
legend('Olifants - Oxford');
xticks(0:12:120);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'})