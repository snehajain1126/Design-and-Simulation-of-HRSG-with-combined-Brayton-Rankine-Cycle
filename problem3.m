a = 1;
b = 0.0008;
c = -120;
n = 1.28;
cp = 1.05;
R = 0.287;
T0 = 300;

P1 = 1;
P2 = 20;

%% solving for T(P)
Z = @(P,T) a + b*P + c/T;
Pspan = [P1 P2];
odefun1 = @(P,T) ( (Z(P,T).*T.^2).*( (n-1)./P - n*b./Z(P,T)  )  )./(n.*(Z(P,T).*T - c));
[P,T] = ode45(odefun1,Pspan,T0);

plot(P,T)
grid on
hold on 

%% solving for entropy change 

% increasing the number of points in P
P_dash = zeros(2*length(P)-1,1);

for i = 1:length(P)-1
    P_dash(2*i-1) = P(i);
    P_dash(2*i) = (P(i+1) + P(i))/2 ;
end

P_dash(end) = P(end);

% increasing the number of points in T
[P2,T_dash] = ode45(odefun1,P_dash,T0);  

deltaS = 0;

for i = 1:length(P_dash)-1
    dT = T_dash(i+1) - T_dash(i);
    dP = P_dash(i+1) - P_dash(i);

    T_avg = (T_dash(i) + T_dash(i+1))/2;
    P_avg = (P_dash(i) + P_dash(i+1))/2;
    Z_avg = Z(P_avg, T_avg);

    deltaS = deltaS + cp*(dT/T_avg) - R*(Z_avg*dP/P_avg);
end

fprintf("The value of entropy change for real gas: %f \n", deltaS)

%% entropy change for ideal gas
deltaS_ideal = 0;
for i = 1:length(P_dash)-1
    dT2 = T_dash(i+1) - T_dash(i);
    dP2 = P_dash(i+1) - P_dash(i);

    T_avg2 = (T_dash(i) + T_dash(i+1))/2;
    P_avg2 = (P_dash(i) + P_dash(i+1))/2;

deltaS_ideal = deltaS_ideal + cp*(dT2/T_avg2) - R*dP2/P_avg2;

end

fprintf("The value of entropy change for ideal gas: %f \n", deltaS_ideal)

fprintf("The deviation from ideal gas: %f \n", abs((deltaS_ideal - deltaS)/deltaS_ideal))