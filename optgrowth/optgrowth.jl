
#=
Solving the optimal growth problem via value function iteration.

@authors : Spencer Lyon, John Stachurski

@date : Thu Feb 2 14:39:36 AEDT 2017

References
----------
    
https://lectures.quantecon.org/jl/optgrowth.html

=#

using QuantEcon
using Optim


"""
The approximate Bellman operator, which computes and returns the
updated value function Tw on the grid points.  An array to store
the new set of values Tw is optionally supplied (to avoid having to
allocate new arrays at each iteration).  If supplied, any existing data in 
Tw will be overwritten.

#### Arguments

`w` : Vector
      The value of the input function on different grid points
`grid` : Vector
         The set of grid points
`beta` : AbstractFloat
         The discount factor
`u` : Function
      The utility function
`f` : Function
      The production function
`shocks` : Vector
           An array of draws from the shock, for Monte Carlo integration (to
           compute expectations).
`Tw` : Vector, optional (default=similar(w))
       Array to write output values to
`compute_policy` : Bool, optional (default=false)
                   Whether or not to compute policy function

"""
function bellman_operator(w::Vector, 
                          grid::Vector,
                          beta::AbstractFloat, 
                          u::Function, 
                          f::Function, 
                          shocks::Vector, 
                          Tw::Vector = similar(w);
                          compute_policy::Bool = false)

    # === Apply linear interpolation to w === #
    w_func = LinInterp(grid, w)

    if compute_policy
        sigma = similar(w)
    end

    # == set Tw[i] = max_c { u(c) + beta E w(f(y  - c) z)} == #
    for (i, y) in enumerate(grid)
        objective(c) = - u(c) - beta * mean(w_func.(f(y - c) .* shocks))
        res = optimize(objective, 1e-10, y)

        if compute_policy
            sigma[i] = res.minimizer
        end
        Tw[i] = - res.minimum
    end

    if compute_policy
        return Tw, sigma
    else
        return Tw
    end
end
    


