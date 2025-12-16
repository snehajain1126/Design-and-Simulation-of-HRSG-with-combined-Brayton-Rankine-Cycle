A = 10^5;
E = 45;
c = 1.8;
R = 8.314*10^(-3);

%% part 1
odefun = @(t,T) (A*exp(-E/(R*T)) + 2000*exp(-0.001*t))/c ;

tspan = linspace(0,5,500);
T0 = 300;

[t,T_no_noise] = ode45(odefun, tspan, T0);

T_noise = T_no_noise .* (1 + 0.01*randn(size(T_no_noise)));

grid on
hold on 

figure(1)
plot(t,T_noise,'r.','LineWidth',5)
plot(t,T_no_noise,'k','LineWidth',1)

hold off
grid off
%% part 2

model = @(p,t) temperature_model(p,t,T0,c,R);

function T = temperature_model(p,t,T0,c,R)
    A = p(1);
    E = p(2);

    odefun = @(t,T) (A*exp(-E./(R*T)) + 2000*exp(-0.001*t))/c;

    [l,T] = ode45(odefun, t, T0);
end

T_data = T_noise;
p0 = [5*10^4 30];   % initial guess 

p_estimate = lsqcurvefit(model, p0, t, T_data);

A_estimate = p_estimate(1);
E_estimate = p_estimate(2);

fprintf("Estimated A = %f \n",A_estimate)
fprintf("Estimated E = %f \n",E_estimate)

T_fit = model(p_estimate,t);


figure(2)

plot(t,T_data,".","LineWidth",5)

figure(3)
plot(t,T_fit,"LineWidth",2)