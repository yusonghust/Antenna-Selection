Ns=4; %发射天线
Nr=16;%接收天线
SNR=6;%dB
SNR= 10^(SNR/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
simulation=10; %重复试验次数

 capacityOfAver=[];


for Lr=1:16
    capacityOfSum=0;
      antennaSubset=nchoosek([1:Nr],Lr);%所有可能的天线子集
    
    for sim=1:simulation
        H=sqrt(1/2)*(randn(Nr,Ns)+1j*randn(Nr,Ns));%瑞利信道       
        fullAntenna=[1:Nr];%完整的天线集合
     
%      capacityOfSubsetMax=0;%记录选择天线数为Lr时所有子集中最大的信道容量
%      
%      for k=1:nchoosek(Nr,Lr) %选择天线数为Lr，循环一次产生一个子集的信道容量，共有nchoosek(Nr,Lr)个子集，
%                indexOfChannel=antennaSubset(k,:);%一个子集                        
%                H_sel=H(indexOfChannel,:);%选择出来的信道矩阵
%                capacityOfSubset=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %子集的容量
%           
%                if(capacityOfSubset>capacityOfSubsetMax)%所有子集中最大的信道容量
%                    capacityOfSubsetMax=capacityOfSubset;
%                end
%      end
              
          capacityOfSum=capacityOfSum+ capacityOfSubsetMax;%信道容量累计值  
      
    end    
      capacityOfAver=[capacityOfAver,capacityOfSum/simulation];
      
end


X=[0:16];
plot(X,[0,capacityOfAver]);
xlabel('Lr');
ylabel('capacity(bit/s/Hz)');
grid on;
hold on;