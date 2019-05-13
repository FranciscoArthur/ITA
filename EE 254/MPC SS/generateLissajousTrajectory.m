function X = generateLissajousTrajectory(A,B,a,b,tspan)

t = linspace(0,tspan,300);

x = A*sin(a*t);
y = B*sin(b*t);


dx = A * a * sin(a * t);
dy = B * b * sin(b * t);

theta = atan2(dy./dx);

X = [x',y',theta'];

%plot(x,y)

end