function best = findLimitLissajous(a, b, omega1Multiplier, omega2Multiplier, sampleTime, omegaMax, l, r)

mKick = 1;

best = fminsearch(@(x) findLimitLissajousCost(x, a, b, omega1Multiplier, omega2Multiplier, sampleTime, omegaMax, l, r), mKick);

end

function cost = findLimitLissajousCost(m, a, b, omega1Multiplier, omega2Multiplier, sampleTime, omegaMax, l, r)

if m < 0
    cost = 1000
    return;
end

times = 0:sampleTime:100;

omega1 = m * omega1Multiplier;
omega2 = m * omega2Multiplier;

[~, ur] = computeReferenceFromLissajous(a, b, omega1, omega2, times);

[omegal, omegar] = unicycleToDifferentialDrive(ur(:,1), ur(:,2), l, r);

maximum = max(max(abs(omegal)), max(abs(omegar)));

cost = (maximum - omegaMax)^2

end