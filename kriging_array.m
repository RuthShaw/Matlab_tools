function kriging_array(array_low,array,i)
%输入低分辨率和高分辨率矩阵 以及与存储有关的i
%% 保存用
AA=double(array);
aa=double(array_low);

map = zeros(30,30);
map_x =zeros(180,180);
[r l] = find(map == 0);
[r_x l_x] = find(map_x == 0);
s=[r l];
s_fix = (s-1).*6+1
s_x=[r_x l_x];

SWH=reshape(aa(:,:),[],1);
a=double(SWH);

SWH_x=reshape(AA,[],1);
theta = [10 10]; lob = [1e-1 1e-1]; upb = [20 20];
[dmodel, perf] = dacefit(s_fix, a, @regpoly0, @corrgauss, theta, lob, upb);
%创建一个40*40的格网，标注范围为0-100，即格网间距为2.5
%S存储了点位坐标值，Y为观测值
%X = gridsamp([1 1;121 57], 121,57);
%X = gridsamp([0 0;100 100], 40);
% X=[83.731 32.36];     %单点预测的实现
%格网点的预测值返回在矩阵YX中，预测点的均方根误差返回在矩阵MSE中
[YX,MSE] = predictor(s_x, dmodel);   
X1 = reshape(s_x(:,1),180,180); X2 = reshape(s_x(:,2),180,180);
YX = reshape(YX, size(X1)); 
B=8;                %编码一个像素用多少二进制位
MAX=2^B-1; %图像有多少灰度级
h = 180; 
w = 180;

aa_test=array2array_pic(array,YX)
ori_=array2array_pic(array,array)

B=8;                %编码一个像素用多少二进制位
MAX=2^B-1; %图像有多少灰度级
h = 180;
w = 180;
[mssim, ssim_map,PSNR,MES,D] = zssim(aa_test,ori_,180,180)
a = [i,111111];
b =[mssim,PSNR,MES,D]
save result.txt a b -ascii -double -append

array_ori_l = array(1:6:180,1:6:180);
SWH=reshape(array_ori_l,[],1);

