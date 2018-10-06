%% 
% % desciption: merge multiple netcdf files for sepcific domain
%  
% % usage: 
% %    1. filenumber is up to the number of your netcdf file to be processed.
% %    2. all the details of the data is saved as the orginal ones.
% %    3. just consider extend the time dimension, so the other dimensions
% %       of merged files has to be the same.
% %    4. the data of all the merged files without time dimension is assumed to be exactly the same 
%  
% % author:
% %    huang xue zhi, dalian university of technology
% %    Ruth Shaw, Ocean University of China
% % revison history
% %    2018-09-25 first verison. 
% %    2018-10-05 second verison. 
%  
% %%


%% read data
clc;
clear;

datadir = 'F:\Australia\data\input\';
addpath(datadir)

filelist = dir([datadir,'ocean_temp','*.nc']);
filenumber = 29;

%% create the merged netcdf file to store the result.
 
    cid=netcdf.create('ocean_temp_2016_2018.nc','clobber');   
%define global attributes
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'title','BRAN_2015_alpha');
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lat_min','-29 degrees');
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lat_max','-35 degrees');
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lon_min','113 degrees');
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lon_max','116 degrees');
    netcdf.putAtt(cid,netcdf.getConstant('NC_GLOBAL'),'NCO','4.6.2');
  

% load('ncvar.mat')

ncid = netcdf.open([datadir,filelist(1).name], 'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
datainfo = ncinfo([datadir,filelist(1).name]);

% choose one dimension to extend, such as time
dimname_extend = 'Time';
% get time dimension
time_dim = 0;
for i = 1:filenumber
    ncid = netcdf.open([datadir,filelist(i).name], 'NC_NOWRITE');
    [tmp,dimlen] = netcdf.inqDim(ncid,netcdf.inqDimID(ncid,dimname_extend));
    time_dim = time_dim + dimlen;
end

% define the variable dimension
% dim = 1:ndims;
for i = 1 : ndims
    if strcmp(dimname_extend, datainfo.Dimensions(1,i).Name)
%         dim.(datainfo.Dimensions(1,i).Name) = netcdf.defDim(cid,datainfo.Dimensions(1,i).Name,netcdf.getConstant('NC_UNLIMITED'));
        dim.(datainfo.Dimensions(1,i).Name) = netcdf.defDim(cid,datainfo.Dimensions(1,i).Name,time_dim);
    else
        dim.(datainfo.Dimensions(1,i).Name) = netcdf.defDim(cid,datainfo.Dimensions(1,i).Name,datainfo.Dimensions(1,i).Length);
    end
end
% end define the dimension

%% deal with constant varieties
% dimid = netcdf.inqDimID(ncid,dimname_extend);
% nvars = 11;
for i = 1:nvars
    
    var_dim = [];
    for j = 1:size(datainfo.Variables(1,i).Size,2)
        var_dim(j) = dim.(datainfo.Variables(1,i).Dimensions(1,j).Name);
    end
    datatype = datainfo.Variables(1,i).Datatype;
    if strcmp(datatype,'single')
        datatype = 'float';
    end
    varid(i)=netcdf.defVar(cid,datainfo.Variables(1,i).Name,datatype,var_dim);
    if ~isempty(datainfo.Variables(1,i).Attributes)
        attr_cell = struct2cell(datainfo.Variables(1,i).Attributes);
        for j =1 : size(attr_cell,3)
            netcdf.putAtt(cid,varid(i),char(attr_cell(1,1,j)),cell2mat(attr_cell(2,1,j)));
        end
    end
    
    
end

netcdf.endDef(cid);

for i = 1:nvars
    vardim = struct2cell(datainfo.Variables(1,i).Dimensions);
    if sum(ismember(vardim(1,:,:),dimname_extend))

        bool = ismember(vardim(1,:,:),dimname_extend);
        var_value=[];
        for j = 1:filenumber
           ncid = netcdf.open([datadir,filelist(j).name], 'NC_NOWRITE');
           var = netcdf.getVar(ncid,netcdf.inqVarID(ncid,datainfo.Variables(1,i).Name));       
           var_value = cat(find(bool==1),var,var_value);
        end
    else
        
       var_value = netcdf.getVar(ncid,netcdf.inqVarID(ncid,datainfo.Variables(1,i).Name));       
       
    end
    netcdf.putVar(cid,varid(i),var_value);
end


netcdf.close(cid);
