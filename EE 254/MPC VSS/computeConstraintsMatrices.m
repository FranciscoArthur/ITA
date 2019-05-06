function [Aqp, bqp] = computeConstraintsMatrices(S, b, ur, M)

[Sb, bb] = computeFeedbackConstraintsMatrices(S, b, ur(1,:));
Aqp = Sb;
bqp = bb;
for k=2:M
    [Sb, bb] = computeFeedbackConstraintsMatrices(S, b, ur(k,:));
    Aqp = blkdiag(Aqp, Sb);
    bqp = [bqp; bb];
end

end

function [Sb, bb] = computeFeedbackConstraintsMatrices(S, b, ur)

Sb = S;
bb = b - S*ur';

end