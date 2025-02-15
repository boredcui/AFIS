%% DEMO FILE
clc;clear;close all
% Include dependencies
addpath('./data/');
addpath('./res');

%% Load the data and select features for classification
load('MSRCV1.mat');



%% 定义 alpha 参数范围
T=40;
[selected, genAccuracy,genStd,bestAccuracy,bestStd,time,A,genSelected] = AFIS(X, Y, T);
% 设置保存结果的目录
saveDir = './res/';



%% 绘制曲线图1：参数 vs. 迭代次数
figure;
plot(1:80, genAccuracy, 'LineWidth', 2); % 加粗曲线
xlabel('T', 'FontSize', 14); % 改变横坐标标签字体大小
ylabel('Classification Accuracy', 'FontSize', 14); % 改变纵坐标标签字体大小
set(gca, 'FontSize', 11); % 改变坐标轴数字的字体大小
grid off;
%%





