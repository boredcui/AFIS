function [selected, genAccuracy,genStd,bestAccuracy,bestStd,time,A,genSelected] = AFIS(X, Y, T)

%% Include dependencies
addpath('./lib'); % dependencies
addpath('./methods'); % FS methods
addpath(genpath('./lib/drtoolbox'));

sz = size(X);
for i = 1:sz(1)
    X{i} = normalizemeanstd(X{i});
%     X{i} = normalize(X{i}, 'range', [0 1]);
end
v = sz(1);

numF = T;

% mrmr
for i = 1:v
    % mrmr
    R_sz = size(X{i});
    R_numF(i) = R_sz(2);
    if (R_numF(i) < numF)
        index_mrmr{i} = mRMR(X{i}, Y, R_numF(i));
    else
        index_mrmr{i} = mRMR(X{i}, Y, numF);
    end
    fel_mrmr{i} = X{i}(:,index_mrmr{i}(:,1:end));
    % acc_mrmr(i) = SVM(fel_mrmr{i},Y);
end

init_index = [];
init_fea = [];
for i = 1:v
    init_index = [init_index,index_mrmr{i}(:,1:1)];
    init_fea = [init_fea,fel_mrmr{i}(:,1:1)];
end

[init_acc,init_std] = SVM(init_fea,Y);
acc = init_acc;
selected = init_fea;
genAccuracy(1) = init_acc;
genStd(1) = init_std;

%% 
tic; % start timer

for k = 2:T
    for i = 1:v% 视图层
        if (k > R_numF(i))
            continue;
        end
        [temp_acc,temp_std,Acc] = SVM([selected,fel_mrmr{i}(:,k:k)],Y);
        if (temp_acc > acc)
            temp_fea = [selected,fel_mrmr{i}(:,k:k)];
            acc = temp_acc;
            std = temp_std;
            flag(i,k) = 1;
        else
            flag(i,k) = 0;
        end
    end
    genAccuracy(k) = acc;
    genStd(k) = std;
    selected = temp_fea;
    gensz = size(selected);
    genSelected(k) = gensz(2);
    if (k==40)
        A = Acc;
        time = toc; % stop timer and calculate elapsed time
    end
end


% 返回最终的结果
bestAccuracy = max(genAccuracy); % 计算当前代的最优适应度
bestAccuracyIndex = find(genAccuracy == bestAccuracy, 1);
bestStd = genStd(bestAccuracyIndex);
