%This algorithm is for imputing missing values in microarray gene expression data
%functions-
1) data_preprocessing.m - for normalizing data
2) data_reverseprocess.m - converting back normalized data to original values
3) denoiseTV.m - TV denoising function used in algorithm

%Matrix completion codes-
1) DCT_Stage1.m - Code for imputing missing values using only Stage-1 i.e DCT based sparsity
2) TV_DCTcode1.m - Code for imputing missing values in incomplete matrix using TV-DCT algorithm
3) TV_DCTcode2.m - Code for introducing missing values randomly and then imputing missing values
                   and calculating NRMSE

%% NOTE: please install spgl solver and keep it in your path in matlab for this algorithm to work

Please cite our work if you use our codes for matrix imputation
1) Farswan, A. and Gupta, A., 2019, May. TV-DCT: Method to Impute Gene Expression Data Using DCT Based Sparsity and Total Variation Denoising. In ICASSP 2019-2019 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP) (pp. 1244-1248). IEEE. 
2) Gehlot, S., Farswan, A., Gupta, A. and Gupta, R., 2019, April. CT-NNBI: Method to Impute Gene Expression Data using DCT Based Sparsity and Nuclear Norm Constraint with Split Bregman Iteration. In 2019 IEEE 16th International Symposium on Biomedical Imaging (ISBI 2019) (pp. 1315-1318). IEEE.
