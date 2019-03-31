function [P]= PStep(CODEBOOK,CODE,XTrain)
X_ba=CODEBOOK*CODE;
I=size(XTrain,1);
P=(eye(I)/(XTrain*XTrain'))*XTrain*X_ba';%%%SQ中的式子（8）
end
