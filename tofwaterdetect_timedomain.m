clc
clear
close all

global win_size step_size figure_row figure_column 
global std_limit_value water_cnt_limit water_cnt 
global b2 a2 %�˲������ݺ�����ϵ��
% ϵͳ����
win_size = 30;        % ԭʼ�źŽ���fft�Ĵ��ڴ�С
step_size = 30        % ��������
figure_row = 3        % ��ͼ��row numble
figure_column = 1     % ��ͼ��column numble
std_limit_value = 8  % �ж��Ƿ�Ϊˮ���ϵı�׼����ֵ
water_cnt_limit = 3   % �ж��Ƿ�Ϊˮ���ϵ�����������ֵ
water_cnt = 0 ;       % �жϿ��ܳ�����ˮ���ϵĴ���

%�˲�������
Fs = 33
fp1=7;fs1=16;
Fs2=Fs/2;
% ������Ҫ����һ�����⣬Ϊ����Ҫ��ͨ����������Բ���Ƶ�ʵ�һ��Fs2�أ�
% ���Ƕ�֪��һ�仰������ʱ�������Ƶ�����ء�Ƶ���������Ҫ��������Ϊ2 �� 2\pi2�н������ء�
% Ҳ����ζ�ţ�������ɢʱ�丵��Ҷ�任DTFT����Ƶ������2 �� 2\pi2��Ϊ���ڵġ�
% ����ο���ƪ����ʱ�������Ƶ�����ء���ˣ����ǵ��˲���ʵ����������
Wp=fp1/Fs2; Ws=fs1/Fs2;
Rp=1; Rs=30;
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b2,a2]=butter(n,Wn,'high','s');
%y=filter(b2,a2,dpfs_mat_select');%����filter�˲�֮��õ�������y���Ǿ�����ͨ�˲�����ź�����

%���ݵ��봦��
dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',1)
title('�Ը��Զ�����log')

dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',2)
title('�Ը�ˮ��log1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %����mat����
dpfs_mat_select=dpfs_mat_load.origindata;  %ѡ��mat
myFun(dpfs_mat_select',3)
title('�Ը�ˮ��log2')


%���ݴ�������
function myFun(inputdata,figure_num)
    
    global win_size step_size figure_row figure_column 
    global std_limit_value water_cnt_limit water_cnt 
    global b2 a2 %�˲������ݺ�����ϵ��

    length = size(inputdata);
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

    % for i = 2:length
    %     if (inputdata(i) < (-60)||inputdata(i)>-13)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 
    subplot(figure_row,figure_column,figure_num)
    for i = win_size+1:step_size:length-win_size
        inputdata_filter_ = filter(b2,a2,inputdata(i-win_size:i));%����filter�˲�֮��õ�������y���Ǿ�����ͨ�˲�����ź�����
        
%         k = i-win_size
%         for a=1:win_size+1
%             filter_data(k) = inputdata_filter_(a)
%             k = k+1
%         end
        
        deviation = std(inputdata_filter_,'omitnan')
        result(i) = deviation
        if(deviation > std_limit_value)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0
        end

        if water_cnt>water_cnt_limit            
            water_flag(i)=1*(-80);                     
         else
            water_flag(i)=0;         
         end        
    end

    plot(inputdata)
    hold on
    plot(result)
    hold on
    plot(water_flag)
    hold on
end