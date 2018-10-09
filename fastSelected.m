function  capacityOfSelected=fastSelected(Nr,Ns,Lr,SNR,H,fullAntenna);
if(Lr==Nr)
    capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H'*H))) ;
else
    
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
end