function [Qbar, Rbar] = computeWeightsMatrices(Q, R, N, M)

Qbar = Q;
for i=2:N
    Qbar = blkdiag(Qbar, Q);
end

Rbar = R;
for i=2:M
    Rbar = blkdiag(Rbar, R);
end

end