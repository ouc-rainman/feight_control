

 
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
%parpool('local',2);
format short;
%------������ʼ������----------------------------------------------
c1=2.4962;             %ѧϰ����1
c2=1.4962;             %ѧϰ����2
w=0.7298;              %����Ȩ��
MaxDT=5;            %����������
D=9;                  %�����ռ�ά����δ֪��������
N=600;                  %��ʼ��Ⱥ�������Ŀ
eps=2;           %���þ���(����֪��Сֵʱ����)
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

%------��ʼ����Ⱥ�ĸ���(�����������޶�λ�ú��ٶȵķ�Χ)------------
History = load('History');
History = History.('History');
c2 = c2+N*0.02;
for i=1:N
    for j=1:D
        x(i,j)= (XMAX(j)-XMIN(j))*rand([1,1])+XMIN(j); %�����ʼ��λ��
        x(i,:) = roundn(x(i,:),-eps);
        v(i,j)=(VMAX(j)-VMIN(j))*rand([1,1])+VMIN(j); %�����ʼ���ٶ�
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
%------������������
disp('*************************************************************')
disp('������ȫ������λ��Ϊ��')
Solution=pg'
disp('���õ����Ż���ֵΪ��')
Result=fitness(pg,D)
disp('*************************************************************')
%------�㷨����---DreamSun GL & HF-----------------------------------
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