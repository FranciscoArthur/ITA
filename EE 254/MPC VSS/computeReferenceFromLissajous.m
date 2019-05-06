function [qr, ur] = computeReferenceFromLissajous(a, b, omega1, omega2, times)

xr = a * cos(omega1 * times);
yr = b * sin(omega2 * times);

dxr = -omega1 * a * sin(omega1 * times);
dyr = omega2 * b * cos(omega2 * times);

thetar = atan2(dyr, dxr);

vr = sqrt(dxr.^2 + dyr.^2);

ddxr = -omega1^2 * a * cos(omega1 * times);
ddyr = -omega2^2 * b * sin(omega2 * times);

dthetar = (dxr .* ddyr - dyr .* ddxr) ./ (dxr.^2 + dyr.^2);

qr = [xr', yr', thetar'];
ur = [vr', dthetar'];

end