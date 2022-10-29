 function [s,fcount]=acsimpson(f,a,b,tol)
 
%�˷���Ϊ����Ӧsimpson������ⶨ����
%fΪ������a��b�ֱ�Ϊ�������䣬tolΪ����
%qΪ����ֵ��fcountΪ���㺯��ֵ����

%һ��Ϊ׼����������
f = fcnchk(f,'vectorized');       %������������
h=b-a;             %����
qu=[a a+h/2 b];    %�����ڵ�
qu(qu==0)=2^-1024; %������㺯��ֵ����NAN�����
y=feval(f,qu);     %���㺯���ڵ㴦��ֵ
s=y*[1 4 1]'*h/6;  %Simpson����
fcount=0;          %�����ʼ������
tol=tol*15;        %��������

[s,fcount]=subsim(f,s,qu,y,fcount,tol); %�ݹ麯��
fcount=fcount+3;   %����������׼���������ݵ����μ���
end

%����Ϊ�ݹ麯��
function [s,fcount]=subsim(f,s,qu,y,fcount,tol)
%����Ϊ��qu���֣��ֱ������С�������Simpson����
h=(qu(end)-qu(1))/2;
quadd=[qu(1)+h/2 qu(2)+h/2];
quadd(quadd==0)=2^-1024; %������㺯��ֵ����NAN�����
yadd=feval(f,quadd);
subs=[y(1) yadd(1) y(2) yadd(2) y(3)].*[1 4 1 4 1]*h/6;
s1=sum(subs(1:3));    %�������
s2=sum(subs(3:end));  %�Ұ�����
stemp=s1+s2;
fcount=fcount+2;          %ÿ�εݹ�һ�Σ�����ֵ�����������2��
if fcount>10000
      warning('MATLAB:acsimpson:MaxFcnCount', ...
            '������ĳ�������������')
     return
end
if abs(stemp-s)<tol
    s=16/15*(s1+s2)-s/15; %�����㾫�ȣ�����һ��Romberg����,���غ���ֵ
else                      %�������㣬���������
    tol=tol/2;
    [s1,fcount]=subsim(f,s1,[qu(1) qu(1)+h/2 qu(2)],[y(1) yadd(1) y(2)],fcount,tol);
    [s2,fcount]=subsim(f,s2,[qu(2) qu(2)+h/2 qu(end)],[y(2) yadd(2) y(3)],fcount,tol);
    s=s1+s2;              %��ÿ��С�����Romberg����ֵ���            
    
end

end

