% --- Thermal Analysis Setup ---
% Define the temperature bounds for the change in internal energy (Delta U)
T_initial = 320; % Starting temperature (K)
T_final = 820;   % Ending temperature (K)

syms T

% The heat capacity function p(T) (J/kg*K or J/mol*K)
heat_capacity_func_sym = ( 700 + 0.35*T - (2e-4)*(T.^2) ) ;

% Calculate Delta U (Internal Energy Change) by integrating p(T) dT
delta_u_symbolic_J = int(heat_capacity_func_sym, T, T_initial, T_final);

% Convert to double and output the result in kJ/kg
delta_u_symbolic_kJ = double(delta_u_symbolic_J) / 1000;
fprintf('Delta u (kJ/kg) via the analytical (symbolic) method: %f \n', delta_u_symbolic_kJ)

% --- Method 2: High-Accuracy Numerical Integration ('integral') ---
% Define the function as an anonymous function handle for numerical solver
heat_capacity_func_handle = @(T) ( 700 + 0.35*T - (2e-4)*(T.^2) ) ;

% Use the robust built-in integrator for a high-precision result
delta_u_integral_J = integral(heat_capacity_func_handle, T_initial, T_final, 'AbsTol', 1e-4);

% Display the result from the 'integral' function
delta_u_integral_kJ = delta_u_integral_J / 1000;
fprintf('Delta u (kJ/kg) using the high-precision integral() method: %f \n ', delta_u_integral_kJ)

% --- Method 3: Trapezoidal Rule ('trapz') Iteration ---
% Set the high-precision result as our 'true' reference value
delta_u_reference_J = delta_u_integral_J; 

% Start with a minimal number of points
num_points = 2;

% Iterate, increasing the grid points, until we achieve a 0.1% accuracy (0.001 error)
while num_points < 1000
    % Generate the temperature vector (x-axis)
    T_vector = linspace(T_initial, T_final, num_points);
    
    % Calculate the function values at those points (y-axis)
    func_values = heat_capacity_func_handle(T_vector);
    
    % Approximate the area under the curve using the trapezoidal rule
    delta_u_trapz_J = trapz(T_vector, func_values);
    
    % Calculate the relative error against our reference
    relative_error = abs((delta_u_trapz_J - delta_u_reference_J) / delta_u_reference_J) ; 
    
    % Check if the 0.1% accuracy threshold is met
    if relative_error <= 0.001
        break; % Target achieved, exit loop
    end
    
    num_points = num_points + 1; % Try with one more point
end 

% Output the final trapezoidal result and the required grid density
delta_u_trapz_kJ = delta_u_trapz_J / 1000;
fprintf('Delta u (kJ/kg) from the trapz() (Trapezoidal Rule) method: %f \n', delta_u_trapz_kJ)
fprintf('Minimum grid points (N) needed for 0.1%% relative error: %d \n', num_points)