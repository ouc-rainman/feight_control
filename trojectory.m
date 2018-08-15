clear all;
clc;
global t;
t=0:0.01:3*pi;

global x;
x = cos(t);
global y;
y = sin(t);
global c;
c = linspace(1,10,length(x));
scatter3(x,y,t,[],c,'.');
hold on;
global N;
N = length(x);

map = compress(1,N,0.005);
index = find(map>0);

xx = [];
yy = [];
tt = [];

for i = 1:length(index)
    xx = [xx,x(index(i))];
    yy = [yy,y(index(i))];
    tt = [tt,t(index(i))];
end

scatter3(xx,yy,tt,'b','*');
totalx = [];
totaly = [];
totalz = [];

disEps = 0.1;

for i = 2:length(index)
    siminx = [0,xx(i)-xx(i-1)];
    siminy = [0,yy(i)-yy(i-1)];
    siminz = [0,tt(i)-tt(i-1)];
    sim('sum1',10);
    for j = 1:length(simoutx)
        
        if (abs( simoutx(j)- xx(i)+xx(i-1) ) < 0.001) && (abs( simouty(j)- yy(i)+yy(i-1) ) < 0.001) && (abs( simoutz(j)- tt(i)+tt(i-1) ) < 0.001)
            break;
        end
        totalx = [totalx,simoutx(j)+xx(i-1)];
        totaly = [totaly,simouty(j)+yy(i-1)];
        totalz = [totalz,simoutz(j)+tt(i-1)];    
    end
    set(gca,'XLim',[-3 3]);
    set(gca,'YLim',[-1.5 1.5]);
    set(gca,'ZLim',[0 10]);
    
    scatter3(totalx,totaly,totalz,'r');
    
    drawnow;
end


scatter3(totalx,totaly,totalz,'r','.');



function result = compress(ss, ee, eps)
    global x;
    global y;
    global t;
    global N;
    
    if ss == ee-1
        return;
    end
    
    result = zeros(1,N);
    result(ss) = 1;
    result(ee) = 1;
    maxx = 0;
    maxi = ss;
    for i = ss+1:ee-1
        nn = calcuDis([x(ss),y(ss),t(ss)],[x(ee),y(ee),t(ee)],[x(i),y(i),t(i)]);
        if nn > maxx
            maxx = nn;
            maxi = i;
        end
    end
    if maxx <= eps
        return;
    end
    result(maxi) = 1;
    result1 = zeros(1,N);
    result2 = zeros(1,N);
    if maxi > ss+1
        result1 = compress(ss,maxi,eps);
    end
    if ee > maxi+1
        result2 = compress(maxi,ee,eps);
    end
    
    result = result1 + result2 + result;
end

function result = calcuDis(x,y,z)
    xy = sqrt( ( y(1)-x(1) )^2 + ( y(2)-x(2) )^2 + ( y(3)-x(3) )^2  );
    xz = sqrt( ( z(1)-x(1) )^2 + ( z(2)-x(2) )^2 + ( z(3)-x(3) )^2  );
    yz = sqrt( ( y(1)-z(1) )^2 + ( y(2)-z(2) )^2 + ( y(3)-z(3) )^2  );
    
    coz = (xz^2 + xy^2 - yz^2) / (2 * xz * xy);
    siz = sqrt( 1 - coz^2 );
    result = xz * siz;
    
end