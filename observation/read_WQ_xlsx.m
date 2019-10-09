%%% write the water monitoring data(xlsx) into struct 
clc; close all; clear all;
load('locations.mat');
datapath = '/Users/.../Data profiles 2016_2017/';
addpath(datapath);
fileList=dir([datapath,'K*.xlsx']);  %扩展名
n=length(fileList);
for j = 1:n
    filename = fileList(j).name;
    [s,names]=xlsfinfo([datapath,filename]);


    for i = 1:size(names,2)

        station.(names{i}).(['week',num2str(j)]).depth = xlsread([datapath,filename],names{i},'A:A');
        tmp = xlsread([datapath,filename],names{i},'B:B');
        year = xlsread([datapath,filename],names{i},'D1:D1');
        [trash,month,trash] = xlsread([datapath,filename],names{i},'C1:C1');
        day = xlsread([datapath,filename],names{i},'B1:B1');
        month = datevec(month,'mmm');
        month = month(2);
        station.(['week',num2str(j)]).(names{i}).time = tmp(2)+datenum(year,month,day,0,0,0);
        station.(['week',num2str(j)]).(names{i}).salt = tmp(6:end);
        station.(['week',num2str(j)]).(names{i}).temp = xlsread([datapath,filename],names{i},'C:C');
    end

end


save('station.mat','station');
