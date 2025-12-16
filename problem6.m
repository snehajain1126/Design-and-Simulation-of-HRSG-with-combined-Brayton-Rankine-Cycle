t0 = 0;

t = linspace(0,3200,1000);

Th = @(t) 900 - 300*exp(-0.0008*t);
Tc = @(t) 300 + 40*sin(0.002*t);
eta = @(t) (1 - Tc(t)/Th(t));

Qin = @(t) 20000*(1 +0.3*sin(0.003*t)); 

P = @(t) eta(t)*Qin(t);

W = trapz(t,P(t));
fprintf("The value of Work for one cycle : %f \n", W)

Tc_values = zeros(length(t));
Th_values = zeros(length(t));
Qin_values = zeros(length(t));
S_dot_gen = zeros(length(t));
for i = 1:length(t) 
    Th_values(i) = 900 - 300*exp(-0.0008*t(i));
    Tc_values(i) = 300 + 40*sin(0.002*t(i));
    Qin_values(i) = 20000*(1 +0.3*sin(0.003*t(i)));

    S_dot_gen(i) = Qin_values(i)/Th_values(i) - Qin_values(i)/Tc_values(i) ;
end

plot(t,S_dot_gen)





