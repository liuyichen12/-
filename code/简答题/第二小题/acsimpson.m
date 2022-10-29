 function [s,fcount]=acsimpson(f,a,b,tol)
 
%此方法为自适应simpson方法求解定积分
%f为函数，a，b分别为积分区间，tol为精度
%q为积分值，fcount为计算函数值次数

%一下为准备输入数据
f = fcnchk(f,'vectorized');       %定义内联函数
h=b-a;             %步长
qu=[a a+h/2 b];    %三个节点
qu(qu==0)=2^-1024; %避免计算函数值出现NAN的情况
y=feval(f,qu);     %计算函数节点处的值
s=y*[1 4 1]'*h/6;  %Simpson积分
fcount=0;          %定义初始计数器
tol=tol*15;        %调整精度

[s,fcount]=subsim(f,s,qu,y,fcount,tol); %递归函数
fcount=fcount+3;   %计数器加上准备输入数据的三次计算
end

%以下为递归函数
function [s,fcount]=subsim(f,s,qu,y,fcount,tol)
%以下为对qu二分，分别对两个小区间求出Simpson积分
h=(qu(end)-qu(1))/2;
quadd=[qu(1)+h/2 qu(2)+h/2];
quadd(quadd==0)=2^-1024; %避免计算函数值出现NAN的情况
yadd=feval(f,quadd);
subs=[y(1) yadd(1) y(2) yadd(2) y(3)].*[1 4 1 4 1]*h/6;
s1=sum(subs(1:3));    %左半区间
s2=sum(subs(3:end));  %右半区间
stemp=s1+s2;
fcount=fcount+2;          %每次递归一次，函数值运算次数增加2次
if fcount>10000
      warning('MATLAB:acsimpson:MaxFcnCount', ...
            '函数在某区间可能震荡严重')
     return
end
if abs(stemp-s)<tol
    s=16/15*(s1+s2)-s/15; %若满足精度，采用一次Romberg积分,返回函数值
else                      %若不满足，则继续二分
    tol=tol/2;
    [s1,fcount]=subsim(f,s1,[qu(1) qu(1)+h/2 qu(2)],[y(1) yadd(1) y(2)],fcount,tol);
    [s2,fcount]=subsim(f,s2,[qu(2) qu(2)+h/2 qu(end)],[y(2) yadd(2) y(3)],fcount,tol);
    s=s1+s2;              %将每个小区间的Romberg积分值相加            
    
end

end

