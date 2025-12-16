T1 = 350;
T2 = 900;
T0 = 298;

%% part 1
cp_by_T = (1200 +0.4.*T - 1.2*(10e-4).*T.^2)./T;
T = linspace(T1,T2,10000);
I = trapz(T,cp_by_T);

fprintf("The value of delta s : %f \n",I);

%% part 2

fprintf("Exergy destroyed when Irreversibility is 2%% in kJ : %f \n", 0.02*T0*I/1000)
fprintf("Exergy destroyed when Irreversibility is 10%% in kJ : %f \n", 0.10*T0*I/1000)

%% part 3
Irr = linspace(0.02,0.1,100);
Xdest = T0 .* Irr .* I; 

plot(Irr*100,Xdest/1000)
