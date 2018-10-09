close all;
clear all;
format long; 

Ns=4; %发射天线
Nr=16;%接收天线
SNR=6;%dB
SNR= 10^(SNR/10); %dB转化SNR（信噪比，单位为dB)=10 lg（S/N)换算一下：S/N=10^(SNR/10）
simulation=100; %重复试验次数

 capacityOfAver=[];


for Lr=1:16
    capacityOfSum=0;
    
    for sim=1:simulation
        H=sqrt(1/2)*(randn(Nr,Ns)+1j*randn(Nr,Ns));%瑞利信道       
        fullAntenna=[1:Nr];%完整的天线集合
        
        B=eye(Ns,Ns);%初始化B   
        Alpha=[];
        H_sel=[];%选择出来的信道矩阵       
      
        for j=1:Nr   %初始化Alpha
            f=H(j,:);
            h=f';
            alpha=h'*h;%标量
            Alpha=[Alpha alpha]; %记录每一次的alpha
        end
        
        for n=1:Lr    %循环一次选择出一副天线
            [maxOfAlpha,index]=max(Alpha);  %选择序号J对应的天线
           
            fullAntenna(index)=[]; %去掉已被选择的天线                
            H_sel=[H_sel;H(index,:)];%已选择天线的信道
            
             if (n<Lr)
                f=H(index,:);
                h=f';
                alpha=Alpha(index);              
                a=(B*h)/sqrt((Ns/SNR)+alpha);
                B=B-a*a';                     %B更新
               
                Alpha(index)=[];%去掉已被选择天线对应的alpha
                       
                 for k=1:length( fullAntenna)
                    Alpha(k)=Alpha(k)-(abs(a'*h))^2;   %alpha更新
                 end      
                 
             end
            
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
hold on;