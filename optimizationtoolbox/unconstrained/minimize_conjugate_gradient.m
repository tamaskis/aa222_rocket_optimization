%==========================================================================
%
% minimize_conjugate_gradient  Finds the local minimizer and minimum of an 
% objective function using the conjugate gradient descent method.
%
%   x_min = minimize_conjugate_gradient(f,x0)
%   x_min = minimize_conjugate_gradient(f,x0,opts)
%   [x_min,f_min] = minimize_conjugate_gradient(__)
%   [x_min,f_min,k] = minimize_conjugate_gradient(__)
%   [x_min,f_min,k,x_all,f_all] = minimize_conjugate_gradient(__)
%
% Author: Tamas Kis
% Last Update: 2022-05-02
%
% REFERENCES:
%   [1] Kochenderfer and Wheeler, "Algorithms for Optimization" (pp. 69-74)
%
% This function requires the Numerical Differentiation Toolbox:
% https://www.mathworks.com/matlabcentral/fileexchange/97267-numerical-differentiation-toolbox
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   f       - (1×1 function_handle) objective function, f(x) (f : ℝⁿ → ℝ)
%   x0      - (n×1 double) initial guess for local minimizer
%   opts    - (1×1 struct) (OPTIONAL) solver options
%       • alpha       - (1×1 double) learning rate (i.e. constant step
%                       factor)
%       • beta_type   - (char) 'Fletcher-Reeves' or 'Polak-Ribiere'
%                       (defaults to 'Polak-Ribiere')
%       • gamma       - (1×1 double) step factor decay rate
%       • gradient    - (1×1 function_handle) gradient of the objective
%                       function
%       • k_max       - (1×1 double) maximimum number of iterations
%                       (defaults to 200)
%       • return_all  - (1×1 logical) all intermediate root estimates are
%                       returned if set to "true"; otherwise, a faster 
%                       algorithm is used to return only the converged 
%                       local minimizer/minimum
%       • step_type   - (char) specifies type of step factor to use: 
%                       'line search', 'decay', or 'constant' (defaults to
%                       'line search')
%                           --> if step_type = 'constant', then opts.alpha 
%                               must be specified
%                           --> if step_type = 'decay', then opts.alpha 
%                               AND opts.gamma must be specified
%       • termination - (char) termination condition ('abs' or 'rel')
%       • TOL         - (1×1 double) tolerance (defaults to 10⁻¹⁰)
%
% -------
% OUTPUT:
% -------
%   x_min   - (n×1 double) local minimizer of f(x)
%   f_min   - (1×1 double) local minimum of f(x)
%   k       - (1×1 double) number of solver iterations
%   x_all   - (n×k double) all estimates of local minimizer of f(x)
%   f_all   - (1×k double) all estimates of local minimum of f(x)
%
%==========================================================================
function [x_min,f_min,k,x_all,f_all] = minimize_conjugate_gradient(f,x0,...
    opts)
    
    % ----------------------------------
    % Sets (or defaults) solver options.
    % ----------------------------------
    
    % determines which method to use for calculating β
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'beta_type')
        beta_type = 'Polak-Ribiere';
    else
        beta_type = opts.beta_type;
    end

    % sets function handle for gradient (approximates using complex-step
    % approximation if not input)
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'gradient')
        g = @(x) igradient(f,x);
    else
        g = @(x) opts.gradient(x);
    end
    
    % sets maximum number of iterations (defaults to 200)
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'k_max')
        k_max = 200;
    else
        k_max = opts.k_max;
    end
    
    % determines if all intermediate estimates should be returned
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'return_all')
        return_all = false;
    else
        return_all = opts.return_all;
    end
    
    % determines which step factor to use
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'step_type')
        step_type = 'line search';
    else
        step_type = opts.step_type;
    end

    % sets termination condition (defaults to 'abs')
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'termination')
        condition = 'abs';
    else
        condition = opts.termination;
    end

    % sets tolerance (defaults to 10⁻¹⁰)
    if (nargin < 3) || isempty(opts) || ~isfield(opts,'TOL')
        TOL = 1e-10;
    else
        TOL = opts.TOL;
    end
    
    % ---------------------
    % Step factor settings.
    % ---------------------

    % logicals controlling which type of step factor to use
    decay_step_factor = false;
    optim_step_factor = false;
    if strcmpi(step_type,'decay'), decay_step_factor = true; end
    if strcmpi(step_type,'line search'), optim_step_factor = true; end
    
    % initial step factor
    if ~optim_step_factor
        alpha = opts.alpha;
    end
    
    % step factor decay rate
    if decay_step_factor
        gamma = opts.gamma;
    end

    % line search options
    opts_ls.n = 10;

    % ---------------------
    % β parameter settings.
    % ---------------------
    
    fletcher_reeves_beta = false;
    polak_ribiere_beta = false;
    if strcmpi(beta_type,'Fletcher-Reeves')
        fletcher_reeves_beta = true;
    end
    if strcmpi(beta_type,'Polak-Ribiere')
        polak_ribiere_beta = true;
    end

    % -----------------------------------------------------
    % First iteration of conjugate gradient descent method.
    % -----------------------------------------------------
    
    % preallocates arrays
    if return_all
        x_all = zeros(length(x0),k_max+1);
        f_all = zeros(1,k_max+1);
    end

    % sets initial guess for local minimizer
    x_curr = x0;
    
    % objective function evaluation at initial guess
    f_curr = f(x_curr);

    % gradient at 1st iteration
    g_curr = g(x_curr);

    %  descent direction at 1st iteration
    d_curr = -g_curr;

    % step factor for 1st iteration
    alpha_1st = line_search(f,x_curr,d_curr,opts_ls);
    
    % estimate of local minimizer at 2nd iteration
    x_next = x_curr+alpha_1st*d_curr;
    
    % perturb estimate of local minimizer at 2nd iteration if it is
    % numerically equivalent to local minimizer at 1st iteration
    if norm(x_next-x_curr) < 1e-10
        x_next = x_next+0.001;
    end

    % estimate of local minimum at 2nd iteration
    f_next = f(x_next);
    
    % stores first iteration
    if return_all
        x_all(:,1) = x0;
        f_all(1) = f_curr;
    end

    % stores results/evaluations for next iteration
    x_curr = x_next;
    f_curr = f_next;
    d_prev = d_curr;
    g_prev = g_curr;
    
    % ----------------------------------
    % Conjugate gradient descent method.
    % ----------------------------------
    
    % gradient descent method
    for k = 2:k_max
        
        % stores results in arrays
        if return_all
            x_all(:,k) = x_curr;
            f_all(k) = f_curr;
        end
        
        % gradient at current iteration
        g_curr = g(x_curr);
        
        % β parameter
        if polak_ribiere_beta
            beta = polak_ribiere(g_curr,g_prev);
        elseif fletcher_reeves_beta
            beta = fletcher_reeves(g_curr,g_prev);
        end
        
        % descent direction at current iteration
        d_curr = -g_curr+beta*d_prev;

        % step factor
        if decay_step_factor
            alpha = alpha*gamma;
        elseif optim_step_factor
            alpha = line_search(f,x_curr,d_curr,opts_ls);
        end
        
        % next estimate of local minimizer and minimum
        x_next = x_curr+alpha*d_curr;
        f_next = f(x_next);
        
        % terminates solver if termination condition satisfied
        if terminate_solver(f_curr,f_next,TOL,condition)
            break;
        end

        % stores variables for next iteration
        g_prev = g_curr;
        d_prev = d_curr;
        x_curr = x_next;
        f_curr = f_next;
        
    end

    % converged local minimizer and minimum
    x_min = x_next;
    f_min = f_next;

    % stores converged results and trims arrays
    if return_all
        x_all(:,k+1) = x_min; x_all = x_all(:,1:(k+1));
        f_all(k+1) = f_min; f_all = f_all(:,1:(k+1));
    end
    
end