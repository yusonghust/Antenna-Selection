function  capacityOfSelected=randomSelected(Nr,Ns,Lr,SNR,H,fullAntenna);
if(Lr==Nr)
    capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H'*H))) ;
else
    H_sel=[];
    for n=1:Lr    %循环一次选择出一副天线
        randomIndex=randint(1,1,[1,length( fullAntenna)]);
        H_sel=[H_sel;H(randomIndex,:)];%已选择天线的信道
        fullAntenna(randomIndex)=[]; %去掉已被选择的天线
    end
    
    capacityOfSelected=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %选择后的信道容量
end