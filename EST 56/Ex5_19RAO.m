% Ex 514.m
for i = 1: 101
w_w1 (i) = 5 * (i - 1) / 100; % 0 to 5
x1 (i) = (2-w_w1(i)^2) / ( (3-w_w1(i)^2) * (1-w_w1(i)^2) );
x2 (i) = 1 / ( (3-w_w1(i)^2) * (1-w_w1(i)^2) );
end
subplot (211);
plot (w_w1, x1);
xlabel ('w/w_1');
ylabel ('X_1*K/F_1_0');
grid on;
subplot (212);
plot (w_w1, x2);
xlabel ('w/w_1');
ylabel ('X_2*K/F_1_0');
grid on