clc; clear all; close all;

%% Loading data
load data/political_blogs;
A2=A; %keeping a copy


%ignoring self loops
for i = 1:size(A,1)
    if(A(i,i)>0)
        A(i,i)=0;
    end
end

% degree without self loops
dv = A*ones(size(A,1),1);
Ne = sum(dv)/2;

% computing modularity matrix B
B = zeros(size(A));
for row = 1:size(A,1)
    for col = 1:size(A,1)
        B(row,col)=A(row,col)-((dv(row)*dv(col))/(2*Ne));
    end
end


%% Spectral modularity maximization 
[V,D] = eig(B);
[d_,ind] = sort(diag(D),'descend');
D = D(ind,ind);
V = V(:,ind);
predicted = V(:,1)>0;


%% computing accuracy against ground truth
accuracy = ((length(find(predicted==nodes)))/length(nodes))*100


%% bisecting the graph using spectral algorithm for solving relaxed ratio-cut minimization problem
L = diag(A*ones(size(A,1),1))-A;
[VL,DL] = eig(L);
predicted_L = VL(:,2)>0; 
accuracy_L = ((length(find(predicted_L==nodes)))/length(nodes))*100

% visualization
K=graph(A);
pp=plot(K,'Layout','force3');
