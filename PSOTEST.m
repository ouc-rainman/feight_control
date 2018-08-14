

 
%------��������Ⱥ�Ż��㷨��Particle Swarm Optimization��-----------
%------���ƣ���������Ⱥ�Ż��㷨��PSO��
%------���ã�����Ż�����
%------˵����ȫ���ԣ������ԣ���Ч��Ⱥ�������㷨
%------���ߣ������ܣ�dreamsun2001@126.com��
%------��λ���й���ҵ��ѧ��ѧԺ������ѧ˶2005
%------ʱ�䣺2006��8��17�� 
%------------------------------------------------------------------
%------��ʼ��ʽ��--------------------------------------------------
clear all;
clc;
format long;
%------������ʼ������----------------------------------------------
c1=1.4962;             %ѧϰ����1
c2=1.4962;             %ѧϰ����2
w=0.4298;              %����Ȩ��
MaxDT=100;            %����������
D=3;                  %�����ռ�ά����δ֪��������
N=10;                  %��ʼ��Ⱥ�������Ŀ
eps=10^(-3);           %���þ���(����֪��Сֵʱ����)
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


%------��ʼ����Ⱥ�ĸ���(�����������޶�λ�ú��ٶȵķ�Χ)------------
for i=1:N
    for j=1:D
        x(i,j)= (XMAX-XMIN)*rand([1,1])+XMIN; %�����ʼ��λ��

        v(i,j)=(VMAX-VMIN)*rand([1,1])+VMIN; %�����ʼ���ٶ�

        
    end
end
%------�ȼ���������ӵ���Ӧ�ȣ�����ʼ��Pi��Pg----------------------
for i=1:N
    p(i)=fitness(x(i,:),D);
    y(i,:)=x(i,:);
end
pg=x(1,:);             %PgΪȫ������

%------������Ҫѭ�������չ�ʽ���ε�����ֱ�����㾫��Ҫ��------------
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
%------������������
disp('*************************************************************')
disp('������ȫ������λ��Ϊ��')
Solution=pg'
disp('���õ����Ż���ֵΪ��')
Result=fitness(pg,D)
disp('*************************************************************')
%------�㷨����---DreamSun GL & HF-----------------------------------
 

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
