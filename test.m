NUM_TEST=100;
test_idx =randsample(size(testdata,1),NUM_TEST);
test_data=testdata(test_idx',:);
test_gnd=testgnd(test_idx',1)+1;
test_tran=P'*test_data';
%%%%%ππ‘Ïlook-up±Ì
for i=1:NUM_TEST
    aa=repmat(test_tran(:,i),[1,K*M]);
    lookup_table(:,i)=sum((aa-CODEBOOK).^2)';
end
result=lookup_table'*CODE;

% hamming ranking: MAP
[~, distanceRank]=sort(result,2);
[train_gnd,~]=find(Y==1);
MAP = cat_apcal(train_gnd,test_gnd,distanceRank');
disp(['MAP is ',num2str(MAP)]);