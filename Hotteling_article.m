function out=Hotteling_article(Baseline,Test,interval,segments)
[numRowst,numColst] = size(Test); %Size of the testing data
[numRowsb,numColsb] = size(Baseline); %Size of the testing data
V=zeros(interval);
P=zeros(interval);
U=zeros(numColsb);
S=zeros(numColsb,interval);
u=zeros(10,1);%upper frequecies 
l=zeros(10,1);%lower frequencies 

%% Segmentation
    for c=1:segments 
        u(1)=interval;
        l(1)=1;
        u(c+1)=interval+u(c);
        l(c+1)=1+u(c);
    end
%% Hotteling
    
TsquaredNew=zeros(c,numColst);
Tsquared=zeros(c,numColsb);
    
    for j=1:c
        Z(:,:,j)=(Baseline(l(j):u(j),:))';
        [N(:,:,j) k(:,:,j)]=size(Z(:,:,j));
        Zmean(:,:,j)= mean(Z(:,:,j));
        Zstd(:,:,j)=std(Z(:,:,j));
%standardized X matrix...
        X(:,:,j)=(Z(:,:,j)-repmat(Zmean(:,:,j),[N(:,:,j),1]))./repmat(Zstd(:,:,j),[N(:,:,j),1]);
        [U(:,:,j),S(:,:,j),V(:,:,j)]=svd(X(:,:,j));
%Scores
        T(:,:,j)=U(:,:,j)*S(:,:,j);
% Loadings
        P(:,:,j)=V(:,:,j);
%Eigenvalues of the covariance matrix of X
        L(:,:,j)=(diag(S(:,:,j)).*diag(S(:,:,j)))/(N(:,:,j)-1);
% pvar - Precentage of variance explained by each PC
        pVar(:,:,j)=100*L(:,:,j)./sum(L(:,:,j));
 %A-number of PCs that explained >90% of variance
        A(:,:,j)=find(cumsum(pVar(:,:,j))>=90,1,'first');
%Hotteling
        for i=1:N(:,:,j)
            for a=1:A(:,:,j)
                Tsquared(j,i)=Tsquared(j,i)+T(i,a,j)^2/L(a,:,j);
            end   
        end
        Tsquared(:,:)= Tsquared; 
%UCL for Hotteling at false alarm rate (Phase1)
        alpha=0.05;
        F(:,:,j)=finv(1-alpha,A(:,:,j),N(:,:,j)-A(:,:,j)-1);
        B(:,:,j)=(A(:,:,j)/(N(:,:,j)-A(:,:,j)-1))*F(:,:,j)/(1+(A(:,:,j)/(N(:,:,j)-A(:,:,j)-1))*F(:,:,j));
        UCL_T2(:,:,j)=(N(:,:,j)-1)^2*B(:,:,j)/N(:,:,j);
        Znew(:,:,j)=(Test(l(j):u(j),:))';
        [Nnew(:,:,j) knew(:,:,j)]=size(Znew(:,:,j));
        Xnew(:,:,j)=(Znew(:,:,j)-repmat(Zmean(:,:,j),[Nnew(:,:,j),1]))./repmat(Zstd(:,:,j),[Nnew(:,:,j) 1]);
%Scores for new observation
        Tnew(:,:,j)=Xnew(:,:,j)*P(:,:,j);
%Prediction
        Xstarnew(:,:,j)=Tnew(:,1,j)*P(:,1,j)';
%Prediction error
        Enew(:,:,j)=Xnew(:,:,j)-Xstarnew(:,:,j);
        for m=1:Nnew(:,:,j)
            for g=1:A(:,:,j)
                TsquaredNew(j,m)=TsquaredNew(j,m)+Tnew(m,g,j)^2/L(g,:,j);
            end
        end
    end

    %% Plot the Hotteling Index 
    for s=1:c; %num of the segment 
    figure
    plot(TsquaredNew(s,:),'DisplayName','T^2','LineWidth',1)
    hold on
    plot(ones(numColst).*UCL_T2(1,1,s),'red')
    end
    ylabel({'Hotelling T^2 Index'});
    xlabel({'time (sec)'});
end
    