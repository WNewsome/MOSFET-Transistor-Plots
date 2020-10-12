close all;
clear;
clc;
%Given
VTN = 0.4;
VDD = 2.1;
Kn = 1;
RD = 5000;
Vi_max = VDD;

%Calculate points
Vi_sweep = 0:0.01:Vi_max;
Vo = zeros(size(Vi_sweep));

% Calculate Vo
for n = 1:size(Vi_sweep,2)
    if Vi_sweep(n) < VTN
        % NMOSS Cut Off
        Vo(n) = VDD;
    end
    if Vi_sweep(n) >= (VTN)
        % Equation 16.7
        % NMOS in Saturation
        Vo(n) = VDD - Kn*RD*(Vi_sweep(n)-VTN)^2;
    end
    % Equation 16.9
    syms x;
    eqn = Kn*RD*(x-VTN)^2+(x-VTN)-VDD==0;
    Sa = solve(eqn,x);
    Vit = Sa(2,1);
    if Vi_sweep(n) >= (VTN) && Vi_sweep(n) >= Vit
        syms x;
        eqn = VDD - Kn*RD*(2*(Vi_sweep(n)-VTN)*x-x^2) == 0;
        Sa = solve(eqn,x);
        Vo(n) = Sa(1,1);
    end
end
plot(Vi_sweep, Vo, '-r');