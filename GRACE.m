%% Sophia Bakar
% March 2021
% GRACE Mascon Solutions

[finfo, outstrct2] = read_nc_file_struct('GRCTellus.JPL.200204_202011.GLO.RL06M.MSCNv02CRI.nc');
we_thickness_CRI = (outstrct2); % creates data structure from netcdf file

P_wet = we_thickness_CRI.lwe_thickness(60:62,131:133,85:191); % water equivalent thickness data at Phalaborwa (x,y,z) where x corresponds to latitude, y corresponds to longitude, and z corresponds to the time period
SM_wet = we_thickness_CRI.lwe_thickness(58:63,130:136,85:191);
RA_wet = we_thickness_CRI.lwe_thickness(54:66,129:133,85:191);

x(1,:) = (mean(mean(SM_wet))).*10; % 3-dimensional average, converted from cm to mm
y(1,:) = mean(mean(P_wet)).*10;
z(1,:) = mean(mean(RA_wet)).*10;


plot(z(1,:),'LineWidth',1)
hold on
plot(y(1,:),'--','LineWidth',2)
plot(x(1,:),'LineWidth',1)
hold off
xticks(0:12:120)
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2018','2019'});
ylabel('Water Equivalent Thickness (mm)')
xlabel('Year')
legend('Ramotswa Aquifer','Phalaborwa','Soutpansberg Mountains')



