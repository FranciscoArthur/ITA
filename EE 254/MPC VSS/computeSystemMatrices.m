function [Phi,G] = computeSystemMatrices(qr, ur, M, T)

N = size(qr, 1);

q = size(qr, 2);
p = size(ur, 2);

for i=1:N
    A{i} = [1, ur(i,2)*T, 0; -ur(i,2)*T, 1, ur(i,1)*T; 0, 0, 1];
    B{i} = [-T, 0; 0, 0; 0, -T];
end

for i=1:N
    for j=i:N
        P{i,j} = computeProductory(A, i, j);
    end
end

Phi = P{1,1};
for i=2:N
    Phi = [Phi; P{1,i}];
end

G = zeros(q * N, 0);
for i=1:M
    column = computeGColumn(P, B, i);
    G = [G, column];
end

end

function P = computeProductory(A, initIndex, endIndex)

n = size(A, 1);
P = eye(n);
for i=initIndex:endIndex
    P = P * A{i};
end

end

function column = computeGColumn(P, B, index)

N = length(B);
q = size(B{1}, 1);
p = size(B{1}, 2);

Z = zeros(q,p);

column = repmat(Z, index - 1, 1);
column = [column; B{index}];

for i=(index+1):N
    column = [column; P{index+1,i}*B{index}];
end

end