%clc;
%clear all;
%close all;
load data.mat; % load data matrix where rows are samples and columns are genes
X_in = data;
[row,col]=size(X_in);
nr = row*col;
X_input = data_preprocessing(X_in); %log-transform data if the range is too high
for itr=1:1:max_iterations % Result is averaged over "max_iterations" iterations
    val_itr = zeros(1,9);
    val_itr2 = zeros(1,9);
    for j = 1:1:9     
        obs = j; % Percentage observed [0...1]     
        [Omega] = subsampling_code(X_input, obs);
        X_observed = X_input.*Omega;  
        [row,col]=size(X_observed);
        %Stage 1: using compressive sensing to fill the incomplete matrix
        for i=1:col
            fprintf('col=%d\n', i);
            Xvec = X_observed(:,i);
            [phi, y]=getphi(Xvec);
            D=dctmtx(row);
            H=phi*D';
            opts = spgSetParms('verbosity',0);   
            sigma = 0.000000001;
            tau = pi;
            x_rec = spg_bpdn(H, y,sigma, opts);
            X_reconstructed(:,i) = D'*x_rec;
        end
        
        %calculating NRMSE after stage 1 after taking antilog of reconstructed matrix
        temp = norm(X_in - data_reverseprocess(X_reconstructed),'fro');  
        val_itr(j) = temp1/norm(X_in,'fro');
        
        %Stage-2: Denoising using Nuclear Norm minimization
        X=X_reconstructed;
        Xobs = zeros(row,col);
        Xobs(idx)=X_input(idx);
        [row,col]=size(X);
        M1=zeros(row,col);
        M1((Xobs ~= 0))=1;  
        for c=1:col
            pivot=X(:,c);
            z=Xobs(Xobs(:,c)~=0,c);
            pivot(abs(pivot-mean(z))>=0.2*std(z))=0;
            X(:,c)=pivot;
        end
        X(M1==1)=Xobs(M1==1);
        M=zeros(row,col);
        M((X ~= 0))=1;
        Y=M.*X;
        
        %% parameters initialization
        lambda_2=0.01;
        lambda_4 = .00001;
        rho=1.1;
        W1=rand(row,col);
        B1=W1;
        max_iter=40;
        X= Y + ~Y.*rand(row,col);
        for iter=1:max_iter  
            fprintf('iteration=%d\n', iter); 
            svtmat=(X+B1);
            [U, S, V]=svd(svtmat);
            S=wthresh(S,'s',(lambda_2/lambda_4)); 
            W1=U*S*V';
            X= Y + ~Y.*W1;
            B1=X+B1-W1;
        end
        X_reconstructed2 = X;
        
        %Calculate NRMSE after Stage-2
        temp2 = norm(X_in - data_reverseprocess(X_reconstructed2),'fro');
        val_itr2(j) = temp2/norm(X_in,'fro');
    end
    nrmse1(itr,:) = val_itr;
    nrmse2(itr,:) = val_itr2;
end

avg_nrmse1 = mean(nrmse1);
avg_nrmse2 = mean(nrmse2);

%Generate semilogy plot
x=10:10:90;
semilogy(x,avg_nrmse1,x,nrmse2)

