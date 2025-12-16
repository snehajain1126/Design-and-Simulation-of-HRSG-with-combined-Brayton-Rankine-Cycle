%% solving for TB
TA = 300;
PA = 1;
PB = 10;
m  = 1.25;

TB = TA*(PB/PA)^((m-1)/m);
fprintf("The value of TB : %f \n", TB)

%% computing delta u, heat and work

u = @(T) 500 + 0.8*T +1.5*(10^-3)*T^2 ;

delta_u = u(TB) - u(TA);


Work = R*(TB - TA)/(1-m);
Heat = delta_u - Work; 
fprintf("The value of delta u : %f \n", delta_u)
fprintf("The value of heat : %f \n", Heat)
fprintf("The value of work : %f \n", Work)
%% calculation of numerical work

c = (R^m)*(TA^m)*(PA^(1 - m)) ;

P_mesh = linspace(PA,PB,1000);
y = @(P_mesh) -(1/m)* (c./P_mesh).^(1/m) ;
W_num = trapz(P_mesh,y(P_mesh));

fprintf("The value of Numerical Work : %f \n", W_num)







