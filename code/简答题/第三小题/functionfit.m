
%请通过压缩包中数据表格‘sin2.mat’导入拟合数据点位置x,y，以下代码分别采用matlab中的'sin2'fittype与polyfit分别进行拟合，并对其拟合误差进行计算
%其函数形式为：a1*sin(b1*x+c1) + a2*sin(b2*x+c2)
[xData, yData] = prepareCurveData(x,y);

% 设置拟合类型以及约束条件设置
ft = fittype( 'sin2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%非线性拟合的一些约束设置
opts.Display = 'Off';
opts.Lower = [-Inf 0 -Inf -Inf 0 -Inf];%设置六个参数的下界
opts.StartPoint = [0.974471505083028 3.16982149894868 -2.98459983650713 0.474920845302555 1.58491074947434 1.26273229414844];%非线性拟合的参数估计值

%使用系数的边界约束条件计算拟合结果.
[res, g] = fit( xData, yData, ft, opts );%fit函数返回两个值，res表示拟合结果的分析，g中包含对拟合准确度的分析

% 画出函数图像与原拟合数据点
subplot(1,2,1)
h = plot( res, xData, yData );
legend( h, '原数据点', '拟合曲线' );

xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on
res
g


%使用多项式线性最小二乘拟合，本题可用五次多项式
a=polyfit(x,y,5);
x_1=linspace(-1,1);
y_1=a(1)*(x_1.^5)+a(2)*(x_1.^4)+a(3)*(x_1.^3)+a(4)*(x_1.^2)+a(5)*x_1+a(6);
y_2=a(1)*(x.^5)+a(2)*(x.^4)+a(3)*(x.^3)+a(4)*(x.^2)+a(5)*x+a(6);
subplot(1,2,2)
plot(x_1,y_1)
hold on 
plot(x,y,'.')
legend('线性多项式拟合曲线','数据点')
grid on
sse2=sum((y_2-y).^2)%多项式拟合的sse