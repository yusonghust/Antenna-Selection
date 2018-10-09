close all;
clear all;
format long;

Ns=4; %发射天线
Nr=16;%接收天线
SNR=6;%dB
SNR= 10^(SNR/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
simulation=1000; %重复试验次数

capacityOfAver=[];


for Lr=1:16
    capacityOfSum=0;
    
    for sim=1:simulation
        H=sqrt(1/2)*(randn(Nr,Ns)+1j*randn(Nr,Ns));%瑞利信道
        fullAntenna=[1:Nr];%完整的天线集合
        
        B=inv(eye(Ns,Ns)+SNR/Ns*(H'*H));%初始化B
        
        
        for n=1:(Nr-Lr)   %渐消法，循环一次舍弃一副天线，留下的是需要的天线
            Alpha=[];
            for j=1:length(fullAntenna)   %初始化Alpha
                f=H(j,:);
                h=f';
                alpha=h'*B*h;%标量
                Alpha=[Alpha alpha]; %记录每一次的alpha
            end
            [minOfAlpha,index]=min(Alpha);  %选择序号J对应的天线
            fullAntenna(index)=[]; %舍弃该天线
            
            if (n<Nr-Lr)
                f=H(index,:);
                h=f';
                alpha=Alpha(index);
                a=B*h;
                B=B+a*a'/(Ns/SNR-alpha);
            end
        end
        H_sel=H(fullAntenna,:);
        
        capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %选择后的信道容量
        
        capacityOfSum=capacityOfSum+capacityOfSelected;%信道容量累计值
        
    end
    capacityOfAver=[capacityOfAver,capacityOfSum/simulation];
    
end
X=[0:16];
plot(X,[0,capacityOfAver]);
xlabel('Lr');
ylabel('capacity(bit/s/Hz)');
grid on;
hold on;