function q = long_division(a,N)

n = length(a);
den = [1 a];
num = [1 zeros(1,n)];
for i = 1:N
    q(i) = num(1)/den(1);
    r = num - q(i)*den;
    num = [r(2:end) 0];
end
q = q(2:end);

