clc;clear;
% profile on;
distcomp.feature( 'LocalUseMpiexec', false );%%%%%%���м��㿪��
load('cifar_10_gist.mat');XTrain=traindata';YLabel=traingnd';
%%%%%%%���ݳ�ʼ��
lamada=1;gama=0.01;miyou=0.1;
R=256;%%%%%%
M=4;%%%%%4�����뱾
K=256;%%%ÿ�����뱾��256������
NITS=5;
C=10;%%%һ��10����ǩ
e=0;%%%constant inter-dictionaryelement-product
% %%%%%�����ѡ4000��ѵ������
% sampleidx=randsample(size(XTrain,2),4000);
% XTrain=XTrain(:,sampleidx');
% YLabel=YLabel(:,sampleidx');
%%%%%%����Ԥ����
N=size(XTrain,2);Y=zeros(C,N);W=randn(R,C);
for i=1:N
    Y(YLabel(1,i)+1,i)=1;
end
%%%%%%Pͨ��PCA��ʼ����CODEBOOK��CODEͨ��PQ������ʼ��
[P,CODE,CODEBOOK]=initialize(XTrain,R,K,M);
% load('initial.mat');

for i=1:NITS
    disp(['����������',num2str(i),]);
    qerror(i,1)=objectfunval( XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    W=WStep(CODEBOOK,CODE,lamada,Y,R);
    qerror(i,2)=objectfunval(XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    P= PStep(CODEBOOK,CODE,XTrain);
    qerror(i,3)=objectfunval( XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    e= eStep(CODEBOOK,CODE,M);
    qerror(i,4)=objectfunval( XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    %%%%%ͨ��mat�ļ��Ѳ������ݸ�objectiveF.m����
    save('parameterToCStep.mat', 'W','CODE','XTrain','Y','P','e','miyou','gama','R','K','lamada');
    CODEBOOK= CStep(CODEBOOK);
%     delete('parameterToCStep.mat');
    qerror(i,5)=objectfunval( XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    CODE=BStep(Y,W,CODEBOOK,CODE,P,XTrain,e,miyou,gama,M,K);
    qerror(i,6)=objectfunval( XTrain, CODE, CODEBOOK ,P,Y,W,gama,miyou,lamada,e);
    disp([num2str(qerror(i,1)),'  ',num2str(qerror(i,2)),'  ',num2str(qerror(i,3)),'  ',num2str(qerror(i,4)),'  ',num2str(qerror(i,5)),'  ',num2str(qerror(i,6))]);
end
save('all.mat');
%%%%%�Ӳ��Լ���ѡȡNUM_TEST�����ݼ�������
% NUM_TEST=1000;
% test_idx =randsample(size(testdata,1),NUM_TEST);

testgnd=testgnd+1;
test_tran=P'*testdata';
%%%%%����look-up��
for i=1:NUM_TEST
    aa=repmat(test_tran(:,i),[1,K*M]);
    lookup_table(:,i)=sum((aa-CODEBOOK).^2)';
end
result=lookup_table'*CODE;

% hamming ranking: MAP
[~, distanceRank]=sort(result,2);
[train_gnd,~]=find(Y==1);
MAP = cat_apcal(train_gnd,testgnd,distanceRank');
disp(['MAP is ',num2str(MAP)]);

load laughter;
sound(y,Fs);
% profile viewer;