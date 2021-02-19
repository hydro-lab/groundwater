%% Sophia Bakar
% Plot GRACE water equiv. thickness against GLDAS TWS Data and GLDAS Soil
% Moisture Content Data
% January 2nd, 2020
% GLDAS TWS Data
GLDAS_RA = readtable('GLDAS.xlsx','Sheet','2019-2020','Range','C1:C13');
GL_RA = transpose(table2array(GLDAS_RA));
GLDAS_SM = readtable('GLDAS.xlsx','Sheet','2019-2020','Range','B1:B13');
GL_SM = transpose(table2array(GLDAS_SM));
GLDAS_P = readtable('GLDAS.xlsx','Sheet','2019-2020','Range','D1:D13');
GL_P = transpose(table2array(GLDAS_P));

% GRACE Data
GRACE_RA = readtable('GRACE.xlsx','Sheet','2019-2020','Range','C1:C13');
GR_RA = transpose(table2array(GRACE_RA));
GRACE_SM = readtable('GRACE.xlsx','Sheet','2019-2020','Range','B1:B13');
GR_SM = transpose(table2array(GRACE_SM));
GRACE_P = readtable('GRACE.xlsx','Sheet','2019-2020','Range','D1:D13');
GR_P = transpose(table2array(GRACE_P));


%Plot datasets
month = (1:1:12);
figure;
subplot(2,1,1);
plot(month, GL_RA,'LineWidth',1);
hold on
plot(month, GL_SM,'--','LineWidth',2);
plot(month, GL_P,'LineWidth',1)
hold off
title('GLDAS: August 2019 - July 2020');
ylabel('Terrestrial Water Storage (mm)')
legend('Ramotswa Aquifer','Soutpansberg Mountains','Phalaborwa');
xticks(1:1:12);
xticklabels({'August','September','October','November','December','January','February','March','April','May','June','July'})


subplot(2,1,2);
plot(month, GR_RA,'LineWidth',1);
hold on
plot(month, GR_SM,'--','LineWidth',1);
plot(month, GR_P,'LineWidth',1)
hold off
title('GRACE: August 2019 - July 2020');
ylabel('Water Equivalent Thickness (cm)');
legend('Ramotswa Aquifer','Soutpansberg Mountains','Phalaborwa');
xticks(1:1:12);
xticklabels({'August','September','October','November','December','January','February','March','April','May','June','July'})






