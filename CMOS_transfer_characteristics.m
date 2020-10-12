close all;
clear;
clc;
%Given
VTN = 0.4;
VDD = 2.1;
VTP = -VTN;
Kn = 1;
Kp = 1;
Vi_max = VDD;

%Calculate points
Vi_sweep = 0:0.01:Vi_max;
Vo = zeros(size(Vi_sweep));
Vit = (VDD + VTP + sqrt(Kn/Kp)*VTN)/(1+sqrt(Kn/Kp));
Vopt = Vit - VTP;
Vont = Vit - VTN;

% Calculate Vo
for n = 1:size(Vi_sweep,2)
    if Vi_sweep(n) < VTN
        Vo(n) = VDD;
    end
    if(Vi_sweep(n) >= VTN && Vi_sweep(n) <= Vit)
        % Area A
        % NMOS saturation, PMOS nonsaturation
        % Equation 16.35
        syms x;
        eqn = Kn*(Vi_sweep(n)-VTN)^2 == Kp*(2*(VDD-Vi_sweep(n)+VTP)*(VDD-x)-(VDD-x)^2);
        Sa = solve(eqn,x);
        Vo(n) = Sa(2,1);
    end
    if(Vi_sweep(n) > Vit && Vi_sweep(n) < (VDD - abs(VTP)))
        % Area C
        % NMOS nonsaturation, PMOS saturation
        syms x;
        % Equation 16.43
        eqn = Kn*(2*(Vi_sweep(n)-VTN)*x-x^2) == Kp*((VDD-Vi_sweep(n)+VTP)^2);
        Sa = solve(eqn,x);
        Vo(n) = Sa(1,1);
    end
    if(Vi_sweep(n) >= (VDD - abs(VTP)))
        Vo(n) = 0;
    end
end

plot(Vi_sweep, Vo, '-r');
hold on
title('CMOS inverter');
yline(Vopt,'-','VOPt');
yline(Vont,'-','VONt');
xline(Vit,'-','VIt');
xline(VTN,'-','VTN');




