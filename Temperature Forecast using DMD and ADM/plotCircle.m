function plotCircle(xCenter,yCenter,radius)
theta = 0 : 0.01 : 2*pi;

x = radius * cos(theta) + xCenter;
y = radius * sin(theta) + yCenter;
plot(x, y);
axis square;
Xmin = xCenter - radius*2; Xmax = xCenter + radius*2; Ymin = yCenter - radius*2; Ymax = yCenter + radius*2;
 xlim([Xmin Xmax]);
 ylim([Ymin Ymax]);
grid on;
axis equal;