clc
clear

% given information
c  = 2.5;          
Tb = 300;          
T0 = 300;          
tf = 2000;         
Q_total = 5*10^5;        

N = 100;  % time intervals
del_t = tf/N;

q0 = (Q_total/tf)*ones(N,1);   % uniform heat vector

%% solving for optimization
q_optimum = fmincon(@entropy_objective, q0,[], [], [], [],zeros(N,1), [],@energy_constraint);

q_uniform = q0;

T_optimum = zeros(N,1);
T_uniform = zeros(N,1);

T_optimum(1) = T0;
T_uniform(1) = T0;

for i = 1:N-1
    T_optimum(i+1) = T_optimum(i) + (del_t/c)*q_optimum(i);
    T_uniform(i+1) = T_uniform(i) + (del_t/c)*q_uniform(i);
end

t = linspace(0,tf,N);

figure(1)
plot(t,q_uniform,"LineWidth",2)
hold on
plot(t,q_optimum,"LineWidth",2)
grid on

figure(2)
plot(t,T_uniform,'LineWidth',2)
hold on
plot(t,T_optimum,'LineWidth',2)
grid on

Sgen_uniform = entropy_objective(q_uniform);
Sgen_optimum = entropy_objective(q_optimum);

fprintf('Total entropy generation uniform = %f kJ/K\n',Sgen_uniform)
fprintf('Total entropy generation optimal = %f kJ/K\n',Sgen_optimum)


%% all the functions

function S = entropy_objective(q)

    c  = 2.5;
    Tb = 300;
    T0 = 300;
    tf = 2000;
N  = length(q);
dt = tf/N;
T = zeros(N,1);
    T(1) = T0;
    for i = 1:N-1
        T(i+1) = T(i) + (dt/c)*q(i);
    end

    S = sum( (q./T - q/Tb) * dt );
end

function [c,ceq] = energy_constraint(q)

    tf   = 2000;
    Q_total = 5e5;
    N    = length(q);
    dt   = tf/N;
 c   = [];
    ceq = sum(q)*dt - Q_total;
end
