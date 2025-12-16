T1 = 310;
T2 = 670;
Tb = 300;

h = @(T) 300+ 2.5*T + 0.0007*T^2;
s = @(T) 2*log(T) + 0.001*T;

h2 = h(T2);
h1 = h(T1);

s2 = s(T2);
s1 = s(T1);
%% part 1: Qdot between 20 and 100 kW 
%limits by I law
mdot_min1 = 20/(h2-h1);
mdot_max1 = 100/(h2-h1);

%limits by II law 
mdot_min2 = 20/(Tb*(s2-s1));
fprintf(">There is no value of Qdot feasibe such that both laws I and II are followed simultaneously for the given values \n")
fprintf(" \n")
%% part 2: feasible region only I law

Qdot = linspace(20,100,200);
mdot = Qdot/(h2-h1);

plot(mdot,Qdot)

%% part 3: 
fprintf(">the delta h dictates where the system can operate, while the ratio of dleta s / delta h determines if that line is thermodynamically possible according to the Second Law \n")