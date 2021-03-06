#=
Provides a function to solve for asset prices under one set of beliefs in the
Harrison -- Kreps model.

Authors: Shunsuke Hori
=#
"""
Function to Solve Single Beliefs
"""
function price_singlebeliefs(transition, dividend_payoff; beta=.75)
    # First compute inverse piece
    imbq_inv = inv(eye(size(transition,1)) - beta*transition)

    # Next compute prices
    prices = beta * ((imbq_inv*transition)* dividend_payoff)

    return prices
end