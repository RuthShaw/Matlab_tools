clc;clear all;close all
filename = 'cockburn_wind_2016-2018_1.nc';
input_time = double(ncread(filename,'time'))+datenum(1858,11,17);
lon = ncread(filename,'XLONG');
lat = ncread(filename,'XLAT');

uwind = ncread(filename,'U10');
vwind = ncread(filename,'V10');

t_beg = find(input_time >= datenum(2017,2,5));
t_beg = t_beg(1);
t_end = find(input_time <= datenum(2017,2,15));
t_end = t_end(end);

h_beg = find(input_time >= datenum(2017,2,8));
h_beg = h_beg(1);
h_end = find(input_time <= datenum(2017,2,11));
h_end = h_end(end);



for i = t_beg:t_end
    figure
    if (i >h_beg&&i<h_end)
            quiver(lon,lat,squeeze(uwind(:,:,i)),squeeze(vwind(:,:,i)),'r')
    else
        quiver(lon,lat,squeeze(uwind(:,:,i)),squeeze(vwind(:,:,i)),'b')
    end
    set(gca,'YLim',[-34,-30],'XLim',[113.5,115.875])
    title(datestr(input_time(i),'yyyy mmm dd HH:MM:SS'))
    frame=getframe(gcf);
    imind=frame2im(frame);
    [imind,cm] = rgb2ind(imind,256);
    
        
    if i==t_beg
        
        imwrite(imind,cm,'wind.gif','gif', 'Loopcount',inf,'DelayTime',1);
    else
        
        imwrite(imind,cm,'wind.gif','gif','WriteMode','append','DelayTime',1);
    end
    
    
    close
end
