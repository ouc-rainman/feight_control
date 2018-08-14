

 
%------基本粒子群优化算法（Particle Swarm Optimization）-----------
%------名称：基本粒子群优化算法（PSO）
%------作用：求解优化问题
%------说明：全局性，并行性，高效的群体智能算法
%------作者：孙明杰（dreamsun2001@126.com）
%------单位：中国矿业大学理学院计算数学硕2005
%------时间：2006年8月17日 
%------------------------------------------------------------------
%------初始格式化--------------------------------------------------
clear all;
clc;
%parpool('local',2);
format short;
%------给定初始化条件----------------------------------------------
c1=2.4962;             %学习因子1
c2=1.4962;             %学习因子2
w=0.7298;              %惯性权重
MaxDT=5;            %最大迭代次数
D=9;                  %搜索空间维数（未知数个数）
N=600;                  %初始化群体个体数目
eps=2;           %设置精度(在已知最小值时候用)
XMAX = [10,20,10,  10,20,10,  10,20,10];
XMIN = [0,0,0,  0,0,0,  0,0,0];
VMAX = XMAX/5;
VMIN = -VMAX;

global temp00;
global temp01;
global temp02;
global temp03;
global temp04;
global temp05;
global temp06;
global temp07;
global temp08;
global History;


temp00 = 0;
temp01 = 0;
temp02 = 0;
temp03 = 0;
temp04 = 0;
temp05 = 0;
temp06 = 0;
temp07 = 0;
temp08 = 0;

%------初始化种群的个体(可以在这里限定位置和速度的范围)------------
History = load('History');
History = History.('History');
c2 = c2+N*0.02;
for i=1:N
    for j=1:D
        x(i,j)= (XMAX(j)-XMIN(j))*rand([1,1])+XMIN(j); %随机初始化位置
        x(i,:) = roundn(x(i,:),-eps);
        v(i,j)=(VMAX(j)-VMIN(j))*rand([1,1])+VMIN(j); %随机初始化速度
    end
end
%------先计算各个粒子的适应度，并初始化Pi和Pg----------------------
for i=1:N
    p(i)=fitness(x(i,:),D);
    y(i,:)=x(i,:);
end
pg=x(1,:);             %Pg为全局最优

%------进入主要循环，按照公式依次迭代，直到满足精度要求------------
for t=1:MaxDT
    c2 = c2+0.01;
    c1 = c1-0.01;
    disp(t);
    for i=1:N
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
        v(i,:) = min(VMAX,v(i,:));
        v(i,:) = max(VMIN,v(i,:));
        judge = x(i,:)+v(i,:);
        aa = (judge>XMAX);
        bb = (judge<XMIN);
        v(i,:) = -2* aa.*v(i,:) +v(i);
        v(i,:) = -2* bb.*v(i,:) +v(i);
        x(i,:) = x(i,:) + v(i,:);
        x(i,:) = roundn(x(i,:),-eps);
        
        x(i,:) = min(XMAX,x(i,:));
        x(i,:) = max(XMIN,x(i,:));
        %disp(x(i,:));
        disp(i);
        if fitness(x(i,:),D) > p(i)
            p(i)=fitness(x(i,:),D);
            y(i,:)=x(i,:);
        end
        if p(i) > fitness(pg,D)
            pg=y(i,:);
        end
    end
    Pbest(t)=fitness(pg,D);
    %Pbest(t)
    %temp00
end
%------最后给出计算结果
disp('*************************************************************')
disp('函数的全局最优位置为：')
Solution=pg'
disp('最后得到的优化极值为：')
Result=fitness(pg,D)
disp('*************************************************************')
%------算法结束---DreamSun GL & HF-----------------------------------
 save History History

function result=fitness(x,D)
    global temp00 ;
    global temp01 ;
    global temp02 ;
    global temp03;
    global temp04;
    global temp05;
    global temp06;
    global temp07;
    global temp08;
    global History;
    temp00 = x(1);
    temp01 = x(2);
    temp02 = x(3);
    temp03 = x(4);
    temp04 = x(5);
    temp05 = x(6);
    temp06 = x(7);
    temp07 = x(8);
    temp08 = x(9);
    ss = num_to_str(x*100);
    if isfield(History,ss)
       result = History.(ss);
    else
        sim('sum1',10);
        result = -simout(end,end);
    end
    History.(ss) = result;
    %temp00,temp01,temp02
end


function ss = num_to_str(a)
    len = length(a);
    ss = 's';
    for i = 1:len
        ss = [ss,'_'];
        ss = [ss,num2str(a(i))];
    end
end