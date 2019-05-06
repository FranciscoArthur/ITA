function [omegal, omegar] = unicycleToDifferentialDrive(v, omega, l, r)

omegar = (v + omega * l / 2) / r;
omegal = (v - omega * l / 2) / r;