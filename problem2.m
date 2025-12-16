% Initial Temperature (K)
T0 = 300; 

% Initial Internal Energy (kJ/kg)
u0 = 450 + 1.1*T0 + 0.0012*T0^2 ;

%%  solving du/dt 
% Time span for the ODE solver
tspan = [0 4000]; 

% Define the ODE du/dt = f(t, u)
odefun1 = @(t,u) 5000*exp(-0.002*t) + 1500*(1 - exp(-0.01*(( -1.1 + sqrt((1.1)^2 +((u-450)*(0.0048)) ) )/0.0024))) ;

% Solve the ODE
[t,u] = ode45(odefun1,tspan,u0);

figure(1)
plot(t,u)
legend("u vs t")
grid on
hold on

%%  solving dT/dt 
% Determine the number of points from the ODE solution
num_points = length(u);

% Pre-allocate the Temperature vector
T = zeros(num_points, 1);

% Convert internal energy (u) back to temperature (T)
% Note: The original loop condition was 'i = 1:65'. I will use the actual number of 
% points from the ODE solution, which is generally better practice, but I am keeping 
% the variable names from the original request.
for i = 1:num_points
T(i) = ( -1.1 + sqrt((1.1)^2 + (u(i)-450)*(0.0048)) )/(0.0024) ;
end 

figure(2)
plot (t,T)
legend("T vs t")
grid on

%% part 3: when r(T) >= q_ext(t) 
% External heat input function q_ext(t)
q_ext = @(t) 5000*exp(-0.002*t);

% Reaction/Output rate function r(T)
r_func = @(T_val) 1500*(1 - exp(-0.01*T_val));

i = 1;
while i <= num_points
if r_func(T(i)) >= q_ext(t(i))
    break;
end
i = i + 1; 
end

% The time at which the condition is first met
time_reaction_exceeds = t(i); 

fprintf("the value of time at which r(T) >= q_ext(t) : %f ", time_reaction_exceeds)