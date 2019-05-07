function deriveRobotDynamicEquations()

syms w1 w2 w3 w4 r l N m Icm xcm ycm real

% alpha = deg2rad([33; 147; 225; 315]); % Skuba
alpha = deg2rad([45; 135; 225; 315]); % ITAndroids
beta = [0; 0; 0; 0];

col1 = -sin(alpha + beta);
col2 = cos(alpha + beta);
col3 = l * cos(beta);

M = [col1, col2, col3];

Mpinv = (M' * M)^-1 * M';
vr = r * Mpinv * [w1; w2; w3; w4];
 cm = [xcm; ycm; 0];
%cm = [0; 0; 0];
vcm = [vr(1); vr(2); 0] + cross([0; 0; vr(3)], cm);
w = vr(3);

T = (1/2) * m * (vcm' * vcm) + (1/2) * Icm * (w' * w);

V = 0;

L = T - V;

dLdw1 = expand(simplify(diff(L, w1)))
dLdw2 = expand(simplify(diff(L, w2)))
dLdw3 = expand(simplify(diff(L, w3)))
dLdw4 = expand(simplify(diff(L, w4)))

dLdw = [dLdw1; dLdw2; dLdw3; dLdw4];
H1 = subs(dLdw, [w1 w2 w3 w4], [1 0 0 0]);
H2 = subs(dLdw, [w1 w2 w3 w4], [0 1 0 0]);
H3 = subs(dLdw, [w1 w2 w3 w4], [0 0 1 0]);
H4 = subs(dLdw, [w1 w2 w3 w4], [0 0 0 1]);

H = [H1, H2, H3, H4]

Id = subs(dLdw1, [w1 w2 w3 w4], [1 0 0 0])
% Iwc = subs(dLdw1, [w1 w2 w3 w4], [0 1 0 0])
% Isc = subs(dLdw1, [w1 w2 w3 w4], [0 0 1 0])

end