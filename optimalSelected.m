function  capacityOfSubsetMax=optimalSelected(Nr,Ns,Lr,SNR,H,antennaSubset)

    
    capacityOfSubsetMax=0;%记录选择天线数为Lr时所有子集中最大的信道容量
    
    for k=1:nchoosek(Nr,Lr) %选择天线数为Lr，循环一次产生一个子集的信道容量，共有nchoosek(Nr,Lr)个子集，
        indexOfChannel=antennaSubset(k,:);%一个子集
        H_sel=H(indexOfChannel,:);%选择出来的信道矩阵
        capacityOfSubset=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %子集的容量
        
        if(capacityOfSubset>capacityOfSubsetMax)%所有子集中最大的信道容量
            capacityOfSubsetMax=capacityOfSubset;
        end
    end
