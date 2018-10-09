function  capacityOfSelected=gorokohovSelected(Nr,Ns,Lr,SNR,H,fullAntenna);
if(Lr==Nr)
    capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H'*H))) ;
else
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
end