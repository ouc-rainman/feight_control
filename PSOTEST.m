

 
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
format long;
%------给定初始化条件----------------------------------------------
c1=1.4962;             %学习因子1
c2=1.4962;             %学习因子2
w=0.4298;              %惯性权重
MaxDT=100;            %最大迭代次数
D=3;                  %搜索空间维数（未知数个数）
N=10;                  %初始化群体个体数目
eps=10^(-3);           %设置精度(在已知最小值时候用)
XMAX = 3;
XMIN = 0;
VMAX = XMAX/4;
VMIN = -VMAX;

global temp00;
global temp01;
global temp02;



temp00 = 0;
temp01 = 0;
temp02 = 0;


%------初始化种群的个体(可以在这里限定位置和速度的范围)------------
for i=1:N
    for j=1:D
        x(i,j)= (XMAX-XMIN)*rand([1,1])+XMIN; %随机初始化位置

        v(i,j)=(VMAX-VMIN)*rand([1,1])+VMIN; %随机初始化速度

        
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
    disp(t);
    for i=1:N
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
        v(i,:) = min(VMAX,v(i,:));
        v(i,:) = max(VMIN,v(i,:));
        judge = x(i,:)+v(i,:);
        aa = (judge>XMAX);
        bb = (judge<XMIN);
        v(i,:) = -1.3* aa.*v(i,:) +v(i);
        v(i,:) = -1.3* bb.*v(i,:) +v(i);
        x(i,:) = x(i,:) + v(i,:);
        
        
        x(i,:) = min(XMAX,x(i,:));
        x(i,:) = max(XMIN,x(i,:));
        disp(x(i,:));
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
 

function result=fitness(x,D)
    global temp00 ;
    global temp01 ;
    global temp02 ;

    temp00 = x(1);
    temp01 = x(2);
    temp02 = x(3);

    sim('sum1',10);
    result = -simout(end,end);
    %temp00,temp01,temp02
end
