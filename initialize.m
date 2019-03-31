function[P,CODE,CODEBOOK]=initialize(XTrain,R,K,M)
[D,N]=size(XTrain);

[COEFF]=pca(XTrain');%%% PCA参数要求N*P
P=COEFF(:,1:R);
 load('ini.mat');
% X=P'*XTrain;
% CODEBOOK=[];code=[];
% parfor i=1:M
%     [idx,C] = kmeans(X(i*64-63:64*i,:)',K);%%%% 输入数据要求N*D
%     idx=idx';C=C';
%     switch i
%         case 1
%             C=[C;zeros(64,256);zeros(64,256);zeros(64,256)];
%         case 2
%             C=[zeros(64,256);C;zeros(64,256);zeros(64,256)];
%         case 3
%             C=[zeros(64,256);zeros(64,256);C;zeros(64,256)];
%         case 4
%             C=[zeros(64,256);zeros(64,256);zeros(64,256);C];
%     end
%     CODEBOOK=[CODEBOOK,C];
%     code=[code;idx];
% end
% code(2,:)=code(2,:)+256; code(3,:)=code(3,:)+512;code(4,:)=code(4,:)+256*3;
% for i=1:N
%     temp=zeros(K*M,1);
%     temp(code(:,i)',1)=1;
%     CODE(:,i)=temp;
% end
%  save('ini.mat','CODEBOOK','CODE','P');
end