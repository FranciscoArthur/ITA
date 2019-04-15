% Ex5_20.m
tspan = [0: 0.01: 20];
y0 = [0.2; 1.0; 0.0; 0.0];
[t,y] = ode23(@(temp,y) dfunc5_15(temp,y), tspan, y0);
subplot (211)
plot (t,y (:, 1));
xlabel ('t');
ylabel ('x1 (t)');
subplot (212)
plot (t,y (:, 3));
xlabel ('t');
ylabel ('x2 (t)');


%dfunc5_15.m
function f = dfunc5_15(t,y)
f = zeros(4, 1);
f(1) = y(2);
f(2) = cos(3*t) - 4*y(2) + y(4) - 5*y(1) + 2*y(3);
f(3) = y(4);
f(4) = cos(3*t) + 0.5*y(2) - y(4) + y(1) - 1.5*y(3);
end