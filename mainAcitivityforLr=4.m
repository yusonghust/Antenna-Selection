close all;
clear all;
format long;

Ns=4; %发射天线
Nr=16;%接收天线
Lr=4;
%SNROfdB=30;%dB
%SNR= 10^(SNROfdB/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
simulation=1000; %重复试验次数
 

capacityOfFastAver=[];
capacityOfRandomAver=[];
capacityOfOptimalAver=[];
capacityOfGorokohovAver=[];
capacityOfNBSAver=[];

for SNROfdB=0:20
    SNR= 10^(SNROfdB/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
    capacityOfFastSum=0;
    capacityOfRandomSum=0;
    capacityOfOptimalSum=0;
    capacityOfGorokohovSum=0;
    capacityOfNBSSum=0;
    
    antennaSubset=nchoosek([1:Nr],Lr);%所有可能的天线子集
    
    for sim=1:simulation
        H=sqrt(1/2)*(randn(Nr,Ns)+1j*randn(Nr,Ns));%瑞利信道
        fullAntenna=[1:Nr];%完整的天线集合
        
        %% fastAntennaSelected
        capacityOfFastSelected=fastSelected(Nr,Ns,Lr,SNR,H,fullAntenna); %选择Lr副天线后的信道容量
        capacityOfFastSum=capacityOfFastSum+capacityOfFastSelected;%信道容量累计值
        
        
        %% randomAntennaSelected 的
        capacityOfRandomSelected=randomSelected(Nr,Ns,Lr,SNR,H,fullAntenna); %选择Lr副天线后的信道容量
        capacityOfRandomSum=capacityOfRandomSum+capacityOfRandomSelected;%信道容量累计值
        
        
        %% optimalAntennaSelected
        capacityOfOptimalSelected=optimalSelected(Nr,Ns,Lr,SNR,H,antennaSubset);%选择Lr副天线后的信道容量
        capacityOfOptimalSum=capacityOfOptimalSum+capacityOfOptimalSelected;%信道容量累计值
        
        %% gorokohovAntennaSelected
        capacityOfGorokohovSelected=gorokohovSelected(Nr,Ns,Lr,SNR,H,fullAntenna);%选择Lr副天线后的信道容量
        capacityOfGorokohovSum=capacityOfGorokohovSum+capacityOfGorokohovSelected;%信道容量累计值
        
        %%NBSAntennnaSelected
        capacityOfNBSSelected=NBSAntennaSelected(Nr,Ns,Lr,SNR,H,fullAntenna);%选择Lr副天线后的信道容量
        capacityOfNBSSum=capacityOfNBSSum+capacityOfNBSSelected;%信道容量累计值
        
        
    end
    capacityOfFastAver=[capacityOfFastAver,capacityOfFastSum/simulation];
    capacityOfRandomAver=[capacityOfRandomAver,capacityOfRandomSum/simulation];
    capacityOfOptimalAver=[capacityOfOptimalAver,capacityOfOptimalSum/simulation];
    capacityOfGorokohovAver=[capacityOfGorokohovAver,capacityOfGorokohovSum/simulation];
    capacityOfNBSAver=[capacityOfNBSAver,capacityOfNBSSum/simulation];
    
    
end
X=[0:20];
plot(X,capacityOfOptimalAver,'c',X,capacityOfFastAver,'k-o',X,capacityOfGorokohovAver,'b-+',X,capacityOfRandomAver,'r',X,capacityOfNBSAver,'b');
legend('optimalSelected','fastSelected','gorokohovSelected','randomSelected','NBSSelected');
xlabel('SNROfdB');
ylabel('capacity(bit/s/Hz)');
grid on;
