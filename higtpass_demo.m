clear
clc

f1=5;%��һ����Ƶ�źŷ���Ƶ��
f2=15;%�ڶ�����Ƶ�źŷ���Ƶ��
f3=30;%��������Ƶ�źŷ���Ƶ��
fs=150;%������
T=2;%ʱ��
B=25;%FIR��ֹƵ��
n=round(T*fs);%���������
t=linspace(0,T,n);
y=cos(2*pi*f1*t)+cos(2*pi*f2*t)+cos(2*pi*f3*t);

figure;
subplot(221)
plot(t,y);
title('ԭʼ�ź�ʱ��');
xlabel('t/s');
ylabel('����');

fft_y=fftshift(fft(y));
f=linspace(-fs/2,fs/2,n);
subplot(222)
plot(f,abs(fft_y));
title('ԭʼ�ź�Ƶ��');
xlabel('f/Hz');
ylabel('����');
axis([ 0 50 0 100]);

b=fir1(80, B/(fs/2),'high'); %��ͨ
y_after_fir=filter(b,1,y);
subplot(223)
plot(t,y_after_fir);
title('�˲����ź�ʱ��');
xlabel('t/s');
ylabel('����');

fft_y1=fftshift(fft(y_after_fir));
f=linspace(-fs/2,fs/2,n);
subplot(224)
plot(f,abs(fft_y1));
title('�˲����ź�Ƶ��');
xlabel('f/Hz');
ylabel('����');
axis([ 0 50 0 100]);

figure;
freqz(b);%�����˲���Ƶ����Ӧ