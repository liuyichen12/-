y_0 = interp1(x,y,xx,'spline');  %球面线性插值  
plot(x,y,'o',xx,y_0,'r')  
% title('球面插值')  
hold on

y_1 = interp1(x1,y1,xx,'spline');  %球面线性插值  
plot(x1,y1,'o',xx,y_1,'r')  
% title('球面插值')  
hold on

y2=fliplr(y1);
y_2 = interp1(x1,y2,xx,'spline');  %球面线性插值  
plot(x1,y2,'o',xx,y_2,'r')  
title('球面插值')  
grid on