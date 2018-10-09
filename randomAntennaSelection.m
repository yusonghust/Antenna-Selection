close all;
clear all;
format long; 

Ns=4; %发射天线
Nr=16;%接收天线
SNROfdB=6;%dB
SNR= 10^(SNROfdB/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
simulation=100; %重复试验次数

 capacityOfAver=[];


for Lr=1:16
    capacityOfSum=0;
    
    for sim=1:simulation
        H=sqrt(1/2)*(randn(Nr,Ns)+1j*randn(Nr,Ns));%瑞利信道       
        fullAntenna=[1:Nr];%完整的天线集合
           H_sel=[];%选择出来的信道矩阵   
 

 for n=1:Lr    %循环一次选择出一副天线     
  randomIndex=randint(1,1,[1,length( fullAntenna)]);
  H_sel=[H_sel;H(randomIndex,:)];%已选择天线的信道
  fullAntenna(randomIndex)=[]; %去掉已被选择的天线     
 end

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