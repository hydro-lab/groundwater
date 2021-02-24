
load('LuphepheDam.mat');
hydro_year_start=7;

%            J F  M     A        M           J              J              
month_start=[0 31 31+28 31+28+31 31+28+31+30 31+28+31+30+31 31+28+31+30+31+30 31+28+31+30+31+30+31 31+28+31+30+31+30+31+31 31+28+31+30+31+30+31+31+30 31+28+31+30+31+30+31+31+30+31 31+28+31+30+31+30+31+31+30+31+30];
P=zeros((max(yr)+1-1900),365);
MP=zeros((max(yr)+1-1900),12);
CP=P;
data_quality=zeros((max(yr)+1-1900),1);

for i=1:length(yr)
    if mo(i)>=hydro_year_start
        year=yr(i)+1;
    else
        year=yr(i);
    end
    if isnan(precip(i))==1
        precip(i)=0;
        data_quality(year-1900)=data_quality(year-1900)+1;
    elseif data_quality_flag>1
        data_quality(year-1900)=data_quality(year-1900)+1;
    end
    MP(yr(i)-1900,mo(i))=MP(yr(i)-1900,mo(i))+precip(i);
end

for i=1:length(yr)
    if mo(i)>=hydro_year_start
        year=yr(i)+1;
        day=month_start(mo(i))+da(i)-month_start(hydro_year_start);
    else
        year=yr(i);
        day=365-month_start(hydro_year_start)+month_start(mo(i))+da(i);
    end
    
    P(year-1900,day)=P(year-1900,day)+precip(i);
    if day==1
        CP(year-1900,day)=precip(i);
    else
        CP(year-1900,day)=CP(year-1900,day-1)+precip(i);
    end
end
data_quality=data_quality./365;

s=zeros(12,1);
n=s;
for i=65:length(data_quality)
    if data_quality(i)<0.1
        for j=1:12
            s(j)=s(j)+MP(i,j);
            n(j)=n(j)+1;
        end
    end
end
