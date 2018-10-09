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
        selAntenna=fullAntenna;
        alpha=zeros(Nr,Ns);%相关程度矩阵
        x=0;%k行与l行的相关程度
        del=[];%待删除的天线
    for k=1:Nr
        for l=1:Nr
            if k<=l
                alpha(k,l)=-1;  %不需要计算或者已经被淘汰的相关程度记为-1
            else
                hk=H(k,:);
                hl=H(l,:);
                x=abs(dot(hk,hl));
                alpha(k,l)=x;
            end
        end
    end
    for m=Nr:-1:Lr
        [p q]=find(max(max(alpha)));
        Xk=norm(H(p,:));
        Xl=norm(H(q,:));
        if Xk>=Xl
            alpha(q,:)=-1;
            alpha(:,q)=-1;
            del=[del,q];
        else
            alpha(p,:)=-1;
            alpha(:,p)=-1;
            del=[del,p];
        end
    end
    for n=1:length(del)
         x=del(n)
         selAntenna=[selAntenna(1:x-1),selAntenna(x+1:end)];%删除编号为x的天线
    end
    H_sel=H(selAntenna,:);
        
        capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %选择后的信道容量
        
        capacityOfSum=capacityOfSum+capacityOfSelected;%信道容量累计值 
    end
    capacityOfAver=[capacityOfAver,capacityOfSum/simulation];
    
           
       
            
                
    
                
                 
                
       
        
    
end
figure;
X=[0:16];
plot(X,[0,capacityOfAver]);
xlabel('Lr');
ylabel('capacity(bit/s/Hz)');
grid on;
hold on;
