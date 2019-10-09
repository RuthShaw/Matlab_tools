%%% write the water monitoring data(xlsx) into struct 
clc; close all; clear all;
load('locations.mat');
datapath = '/Users/.../Data profiles 2016_2017/';
addpath(datapath);
filename = 'KIC01_physical data.xlsx';
[s,names]=xlsfinfo([datapath,filename]);


for i = 1:size(names,2)
    
    station.(names{i}).depth = xlsread([datapath,filename],names{i},'A:A');
    tmp = xlsread([datapath,filename],names{i},'B:B');
    year = xlsread([datapath,filename],names{i},'D1:D1');
    [trash,month,trash] = xlsread([datapath,filename],names{i},'C1:C1');
    day = xlsread([datapath,filename],names{i},'B1:B1');
    month = datevec(month,'mmm');
    month = month(2)
    station.(names{i}).time = tmp(2)+datenum(year,month,day,0,0,0);
    station.(names{i}).salt = tmp(6:end);
    station.(names{i}).temp = xlsread([datapath,filename],names{i},'C:C');
end
