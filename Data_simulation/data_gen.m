% ---------------------------------------------
% Diffusion Propagator (fit quality / comparison)
% Adapted Version for Generating Diverse Data Sets
% Marion Menzel


% Adapted to introduce variations in simulation parameters, add noise,
% and handle varying amounts of fibers inside the voxel.
%
% ---------------------------------------------
    clear; close all;

% ---------------------------------------------
% 1. Define simulation parameters
% ---------------------------------------------

simsize = 33; % simulate a larger r-space than can be sampled
bmax = 10000; % s/mm^2
bigDelta = 66E-3; % sec
smallDelta = 60E-3; % sec
gmax = 40E-3; % T/m
gamma = 2*pi*42.57E6; % Hz/T for proton
qmax = gamma/2/pi*smallDelta*gmax;
qDelta = qmax*2/(simsize-1);
rFOV = 1/qDelta;
rmax = rFOV/2;

% Simulation variations
num_simulations = 10000;

D_range = [1E-11, 1E-9];
FA_range = [0.01, 0.99];
alpha_range = [0, 359]; % degrees
beta_range = [0, 359]; % degrees

% ---------------------------------------------
% 2. Generate and process data for multiple simulations
% ---------------------------------------------
results = cell(num_simulations, 1);


for i = 1:num_simulations
    disp(i);
    % Randomly choose number of fibers inside the voxel
    num_fibers = randi([3, 3]);

    % Init random rspace
    rspace = zeros(simsize, simsize, simsize);
    
    % Fiber fractions
    fiber_fractions = rand(1, num_fibers);
    fiber_fractions = fiber_fractions / sum(fiber_fractions); % Normaliziung so they sum to 1

    % Loop for each fiber
    for j = 1:num_fibers
        % Varying diffusion coefficients and fractional anisotropy
        FA = FA_range(1) + (FA_range(2) - FA_range(1)) * rand();
        Dxx = D_range(1) + (D_range(2) - D_range(1)) * rand();
        Dyy = Dxx * (1-FA) / sqrt(2);
        Dzz = Dxx * (1-FA) / sqrt(2);
            
        % Varying rotation angles
        alpha = alpha_range(1) + (alpha_range(2) - alpha_range(1)) * rand();
        beta = beta_range(1) + (beta_range(2) - beta_range(1)) * rand();
        
        % Grid generation for r-space
        [X, Y, Z] = ndgrid(linspace(-rmax, rmax, simsize));
        [X1, Y1, Z1] = rotateGrid(X, Y, Z, alpha, beta);

        % rspace for fiber j
        rspace_fiber = 1/sqrt(((4*pi*bigDelta)^3)*Dxx*Dyy*Dzz) * exp(-(X1.*X1/(4*Dxx*bigDelta) + Y1.*Y1/(4*Dyy*bigDelta) + Z1.*Z1/(4*Dzz*bigDelta)));

        % add fiber j to final rspace
        rspace = rspace + fiber_fractions(j) * rspace_fiber;
    end
    
    % q-space calculation
    qspace = fftshift(fftn(ifftshift(rspace)));
        
    % Store results
%    results{i} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);

    if i < 501
        results_01{i} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end
    
    if (i > 500 && i < 1001)
        results_02{i-500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 1000 && i < 1501)
        results_03{i-1000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 1500 && i < 2001)
        results_04{i-1500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 2000 && i < 2501)
        results_05{i-2000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 2500 && i < 3001)
        results_06{i-2500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 3000 && i < 3501)
        results_07{i-3000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 3500 && i < 4001)
        results_08{i-3500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 4000 && i < 4501)
        results_09{i-4000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 4500 && i < 5001)
        results_10{i-4500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 5000 && i < 5501)
        results_11{i-5000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 5500 && i < 6001)
        results_12{i-5500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 6000 && i < 6501)
        results_13{i-6000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 6500 && i < 7001)
        results_14{i-6500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 7000 && i < 7501)
        results_15{i-7000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 7500 && i < 8001)
        results_16{i-7500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end    

    if (i > 8000 && i < 8501)
        results_17{i-8000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 8500 && i < 9001)
        results_18{i-8500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end    

    if (i > 9000 && i < 9501)
        results_19{i-9000} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end

    if (i > 9500 && i < 10001)
        results_20{i-9500} = struct('rspace', rspace, 'qspace', qspace, 'num_fibers', num_fibers, 'fiber_fractions', fiber_fractions);
    end        

end


% ---------------------------------------------
% 3. Save results to file
% ---------------------------------------------

%save('simulation_results.mat', 'results', '-v7.3');

save('simulation_results_01.mat', 'results_01', '-v7.3');
save('simulation_results_02.mat', 'results_02', '-v7.3');
save('simulation_results_03.mat', 'results_03', '-v7.3');
save('simulation_results_04.mat', 'results_04', '-v7.3');
save('simulation_results_05.mat', 'results_05', '-v7.3');
save('simulation_results_06.mat', 'results_06', '-v7.3');
save('simulation_results_07.mat', 'results_07', '-v7.3');
save('simulation_results_08.mat', 'results_08', '-v7.3');
save('simulation_results_09.mat', 'results_09', '-v7.3');
save('simulation_results_10.mat', 'results_10', '-v7.3');
save('simulation_results_11.mat', 'results_11', '-v7.3');
save('simulation_results_12.mat', 'results_12', '-v7.3');
save('simulation_results_13.mat', 'results_13', '-v7.3');
save('simulation_results_14.mat', 'results_14', '-v7.3');
save('simulation_results_15.mat', 'results_15', '-v7.3');
save('simulation_results_16.mat', 'results_16', '-v7.3');
save('simulation_results_17.mat', 'results_17', '-v7.3');
save('simulation_results_18.mat', 'results_18', '-v7.3');
save('simulation_results_19.mat', 'results_19', '-v7.3');
save('simulation_results_20.mat', 'results_20', '-v7.3');



% Function to perform grid rotation
function [Xr, Yr, Zr] = rotateGrid(X, Y, Z, alpha, beta)
    rad_alpha = alpha * pi/180;
    rad_beta = beta * pi/180;
    Xr = (X*cos(rad_alpha) + Y*sin(rad_alpha))*cos(rad_beta) + Z*sin(rad_beta);
    Yr = (Y*cos(rad_alpha) - X*sin(rad_alpha))*cos(rad_beta);
    Zr = Z*cos(rad_beta) - (X*cos(rad_alpha) + Y*sin(rad_alpha))*sin(rad_beta);
end
