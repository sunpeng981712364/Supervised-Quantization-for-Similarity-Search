function [f,g] = objectiveFandG(CODEBOOK)
load('parameterToCStep.mat');%%%%%传参数
N=size(XTrain,2);
lookup=CODEBOOK'*CODEBOOK;
x_encoding=CODEBOOK*CODE;
subE=calculate(lookup,CODE,e,N);
%%%%%%SQ中目标函数（6）的值
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
    %%%%%%%目标函数（6）式相对于codebook1的256*256个变量的导数
    temp21=x_encoding-CODEBOOK(:,index(1,:));
    copy=repmat(subE,[size(temp21,1),1]);%%%%与M有关
    %%%%SQ中式子（10）对C1的导数
      g(1:256,1:256)=2*W*(W'*x_encoding-Y)*bn1'+2*gama*(x_encoding-P'*XTrain)*bn1'+4*miyou*(copy.*temp21)*bn1';
  
   %%%%%%%目标函数（6）式相对于codebook2的256*256个变量的导数   
    temp21=x_encoding-CODEBOOK(:,index(2,:));
     copy=repmat(subE,[size(temp21,1),1]);
         %%%%SQ中式子（10）对C2的导数
     g(1:256,257:512)=2*W*(W'*x_encoding-Y)*bn2'+2*gama*(x_encoding-P'*XTrain)*bn2'+4*miyou*(copy.*temp21)*bn2';
   
    
     %%%%%%%目标函数（6）式相对于codebook3的256*256个变量的导数     
    temp21=x_encoding-CODEBOOK(:,index(3,:));
    copy=repmat(subE,[size(temp21,1),1]);
        %%%%SQ中式子（10）对C3的导数
     g(1:256,513:768)=2*W*(W'*x_encoding-Y)*bn3'+2*gama*(x_encoding-P'*XTrain)*bn3'+4*miyou*(copy.*temp21)*bn3';
   
    
      %%%%%%%目标函数（6）式相对于codebook4的256*256个变量的导数       
    temp21=x_encoding-CODEBOOK(:,index(4,:));
    copy=repmat(subE,[size(temp21,1),1]);
        %%%%SQ中式子（10）对C4的导数
    g(1:256,769:1024)=2*W*(W'*x_encoding-Y)*bn4'+2*gama*(x_encoding-P'*XTrain)*bn4'+4*miyou*(copy.*temp21)*bn4';

end
end

%%%%%%%%SQ（6）式子中最后一项（）中值
function[subE] =calculate(lookup,CODE,e,N)
subE=zeros(1,N);
for i=1:N
    index=find(CODE(:,i)==1);
    subE(1,i)=(2*(lookup(index(1),index(2))+lookup(index(1),index(3))+lookup(index(1),index(4))+lookup(index(2),index(3))+lookup(index(2),index(4))+lookup(index(3),index(4)))-e);
end
end