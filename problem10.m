Tc = 270;
Th = 320;
alpha = 0.02;
k = 50;

lb = 1.1;
ub = 6;
rp0 = 2;

obj = @(rp) -COP_real(rp,Tc,Th,alpha);

% Nonlinear entropy constraint
nonlcon = @(rp) entropy_constraint(rp,Tc,Th,alpha,k);

% Solving for optimization
rp_opt = fmincon(obj, rp0, [], [], [], [], lb, ub, nonlcon);

% Evaluating at optimum
COP_optimum = COP_real(rp_opt,Tc,Th,alpha);
Sgen_optimum = entropy_gen(rp_opt,Tc,Th,alpha,k);

fprintf('Optimal rp = %f \n',rp_opt)
fprintf('Max COP = %f \n',COP_optimum)
fprintf('Entropy generation = %f kJ/K  \n',Sgen_optimum)


function COP = COP_real(rp,Tc,Th,alpha)
    COP = (Tc/(Th-Tc)) * (1 - alpha*(rp-1).^2)./rp;
end

function W = work_comp(rp,k)
    W = k*(sqrt(rp) - 1);
end

function Sgen = entropy_gen(rp,Tc,Th,alpha,k)

    COP = COP_real(rp,Tc,Th,alpha);
    Wc  = work_comp(rp,k);

    Qh = COP .* Wc;
    Qc = Qh - Wc;

    Sgen = Qh./Th - Qc./Tc;
end

function [c,ceq] = entropy_constraint(rp,Tc,Th,alpha,k)

    Sgen = entropy_gen(rp,Tc,Th,alpha,k);

    c = Sgen - 0.05;   % should have beeen ≤ 0
    ceq = [];
end

rp = linspace(1.1,6,500);

COP_vals  = COP_real(rp,Tc,Th,alpha);
Sgen_vals = arrayfun(@(x) entropy_gen(x,Tc,Th,alpha,k), rp);

figure(1)
subplot(3,1,1)
plot(rp,COP_vals,"LineWidth",2)
ylabel("COP")
grid on

subplot(3,1,2)
plot(rp,Sgen_vals,"LineWidth",2)
yline(0.05,"r--")
ylabel("Sgen (kJ/K)")
grid on

subplot(3,1,3)
plot(rp,COP_vals,"LineWidth",2)
hold on
plot(rp(Sgen_vals<0.05),COP_vals(Sgen_vals<0.05),"g","LineWidth",3)
xlabel("Pressure ratio r_p")
ylabel("Feasible COP")
grid on
