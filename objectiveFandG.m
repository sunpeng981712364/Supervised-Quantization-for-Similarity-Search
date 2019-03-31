function [f,g] = objectiveFandG(CODEBOOK)
load('parameterToCStep.mat');%%%%%������
N=size(XTrain,2);
lookup=CODEBOOK'*CODEBOOK;
x_encoding=CODEBOOK*CODE;
subE=calculate(lookup,CODE,e,N);
%%%%%%SQ��Ŀ�꺯����6����ֵ
f = sum(sum((Y-W'*x_encoding).^2))+lamada*sum(sum(W.^2))+gama*sum(sum((x_encoding-P'*XTrain).^2))+miyou*sum(subE.^2);
if nargout > 1
    bn1=CODE(1:256,:);
    bn2=CODE(257:512,:);
    bn3=CODE(513:768,:);
    bn4=CODE(769:1024,:);

    index=zeros(4,N);
    for i=1:N
        index(:,i)=find(CODE(:,i)==1);
    end
    %%%%%%%Ŀ�꺯����6��ʽ�����codebook1��256*256�������ĵ���
    temp21=x_encoding-CODEBOOK(:,index(1,:));
    copy=repmat(subE,[size(temp21,1),1]);%%%%��M�й�
    %%%%SQ��ʽ�ӣ�10����C1�ĵ���
      g(1:256,1:256)=2*W*(W'*x_encoding-Y)*bn1'+2*gama*(x_encoding-P'*XTrain)*bn1'+4*miyou*(copy.*temp21)*bn1';
  
   %%%%%%%Ŀ�꺯����6��ʽ�����codebook2��256*256�������ĵ���   
    temp21=x_encoding-CODEBOOK(:,index(2,:));
     copy=repmat(subE,[size(temp21,1),1]);
         %%%%SQ��ʽ�ӣ�10����C2�ĵ���
     g(1:256,257:512)=2*W*(W'*x_encoding-Y)*bn2'+2*gama*(x_encoding-P'*XTrain)*bn2'+4*miyou*(copy.*temp21)*bn2';
   
    
     %%%%%%%Ŀ�꺯����6��ʽ�����codebook3��256*256�������ĵ���     
    temp21=x_encoding-CODEBOOK(:,index(3,:));
    copy=repmat(subE,[size(temp21,1),1]);
        %%%%SQ��ʽ�ӣ�10����C3�ĵ���
     g(1:256,513:768)=2*W*(W'*x_encoding-Y)*bn3'+2*gama*(x_encoding-P'*XTrain)*bn3'+4*miyou*(copy.*temp21)*bn3';
   
    
      %%%%%%%Ŀ�꺯����6��ʽ�����codebook4��256*256�������ĵ���       
    temp21=x_encoding-CODEBOOK(:,index(4,:));
    copy=repmat(subE,[size(temp21,1),1]);
        %%%%SQ��ʽ�ӣ�10����C4�ĵ���
    g(1:256,769:1024)=2*W*(W'*x_encoding-Y)*bn4'+2*gama*(x_encoding-P'*XTrain)*bn4'+4*miyou*(copy.*temp21)*bn4';

end
end

%%%%%%%%SQ��6��ʽ�������һ�����ֵ
function[subE] =calculate(lookup,CODE,e,N)
subE=zeros(1,N);
for i=1:N
    index=find(CODE(:,i)==1);
    subE(1,i)=(2*(lookup(index(1),index(2))+lookup(index(1),index(3))+lookup(index(1),index(4))+lookup(index(2),index(3))+lookup(index(2),index(4))+lookup(index(3),index(4)))-e);
end
end