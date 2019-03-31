function[CODE]=BStep(Y,W,CODEBOOK,CODE,P,XTrain,e,miyou,gama,M,K)
N=size(XTrain,2);
look_up=CODEBOOK'*CODEBOOK;


parfor i=1:N%%%%%%%分解成N个子问题分别求解
    codeNIndex=find(CODE(:,i)==1);
    for m=1:M%%%%%每次固定C2C3C4密码本，计算C1中K个向量与其他密码本的组合，这里运用了向量化操作K个一块求。
        list=(256*m-255):256*m;
        CODEBOOK_m=CODEBOOK(:,list);
        switch m
            case 1
                aaaa=CODEBOOK(:,codeNIndex(2,1))+CODEBOOK(:,codeNIndex(3,1))+CODEBOOK(:,codeNIndex(4,1));
            case 2
                aaaa=CODEBOOK(:,codeNIndex(1,1))+CODEBOOK(:,codeNIndex(3,1))+CODEBOOK(:,codeNIndex(4,1));
            case 3
                aaaa=CODEBOOK(:,codeNIndex(1,1))+CODEBOOK(:,codeNIndex(2,1))+CODEBOOK(:,codeNIndex(4,1));
            case 4
                aaaa=CODEBOOK(:,codeNIndex(1,1))+CODEBOOK(:,codeNIndex(2,1))+CODEBOOK(:,codeNIndex(3,1));
        end
        aaab=bsxfun(@plus,CODEBOOK_m,aaaa);%%%Cbn
        aaac= bsxfun(@minus,Y(:,i), W'*aaab);
        K_first=sum(aaac.^2);%%%SQ中（11）式子第一项
        aaad= bsxfun(@minus,aaab,P'*XTrain(:,i));
        K_second=gama*sum(aaad.^2);%%%SQ中（11）式子第二项
        switch m
            case 1
                K_third=2*(look_up(codeNIndex(2,1),list)+look_up(codeNIndex(3,1),list)+look_up(codeNIndex(4,1),list)+look_up(codeNIndex(2,1),codeNIndex(3,1))+look_up(codeNIndex(2,1),codeNIndex(4,1))+look_up(codeNIndex(3,1),codeNIndex(4,1)));
            case 2
                K_third=2*(look_up(codeNIndex(1,1),list)+look_up(codeNIndex(3,1),list)+look_up(codeNIndex(4,1),list)+look_up(codeNIndex(1,1),codeNIndex(3,1))+look_up(codeNIndex(1,1),codeNIndex(4,1))+look_up(codeNIndex(3,1),codeNIndex(4,1)));
            case 3
                K_third=2*(look_up(codeNIndex(1,1),list)+look_up(codeNIndex(2,1),list)+look_up(codeNIndex(4,1),list)+look_up(codeNIndex(1,1),codeNIndex(2,1))+look_up(codeNIndex(1,1),codeNIndex(4,1))+look_up(codeNIndex(2,1),codeNIndex(4,1)));
            case 4
                K_third=2*(look_up(codeNIndex(2,1),list)+look_up(codeNIndex(3,1),list)+look_up(codeNIndex(1,1),list)+look_up(codeNIndex(2,1),codeNIndex(3,1))+look_up(codeNIndex(2,1),codeNIndex(1,1))+look_up(codeNIndex(3,1),codeNIndex(1,1)));
        end
        K_third=miyou*((K_third-e).^2);%%%SQ中（11）式子第三项
        SUM=K_first+K_second+K_third;%%%%SQ(11)式子
        [minB,I]=min(SUM);%%%%找到该密码本K个向量中，使（11）式子最小的codevector
%         disp([num2str(i),'    ','minB is ',num2str(minB)]);
        codeNIndex(m,1)=I+(m-1)*K;
    end
    %%%%保存对向量的编码
    newcode=zeros(K*M,1);
    newcode(codeNIndex',1)=1;
    CODE(:,i)=newcode;
end

end

