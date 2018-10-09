function  capacityOfNBS=NBSAntennaSelected(Nr,Ns,Lr,SNR,H,fullAntenna)
 capacityOfNBS=0;%记录选择天线数为Lr时所有子集中最大的信道容量
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
    for m=Nr:-1:Lr+1
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
    capacityOfNBS=log2(det(eye(Ns)+SNR/Ns*(H_sel'*H_sel))) ; %选择后的信道容量

end

