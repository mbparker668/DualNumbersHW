module DualNumbersHW

import Base: +, -, *, /, ^, sin, cos, exp, sqrt

export Dual

struct Dual{T}
    value::T
    deriv::T
end

Dual(v, d) = Dual{typeof(v)}(v, d)

# Dual with Dual
+(a::Dual, b::Dual) =
    Dual(a.value + b.value,
         a.deriv + b.deriv)

-(a::Dual) =
    Dual(-a.value, -a.deriv)

-(a::Dual, b::Dual) = a + (-b)

*(a::Dual, b::Dual) =
    Dual(a.value*b.value,
         a.value*b.deriv + a.deriv*b.value)

/(a::Dual, b::Dual) =
    Dual(a.value/b.value,
         (a.deriv*b.value - a.value*b.deriv)/(b.value^2))

# Dual with Number
+(a::Dual, b::Number) = Dual(a.value + b, a.deriv)
+(a::Number, b::Dual) = Dual(a + b.value, b.deriv)

-(a::Dual, b::Number) = Dual(a.value - b, a.deriv)
-(a::Number, b::Dual) = Dual(a - b.value, -b.deriv)

*(a::Dual, b::Number) = Dual(a.value*b, a.deriv*b)
*(a::Number, b::Dual) = Dual(a*b.value, a*b.deriv)

/(a::Dual, b::Number) = Dual(a.value/b, a.deriv/b)

(/)(a::Number, b::Dual) =
    Dual(a/b.value,
         (-a*b.deriv)/(b.value^2))

# Power
^(a::Dual, n::Integer) =
    Dual(a.value^n,
         n*a.value^(n-1)*a.deriv)

# Functions
sin(a::Dual) =
    Dual(sin(a.value),
         cos(a.value)*a.deriv)

cos(a::Dual) =
    Dual(cos(a.value),
         -sin(a.value)*a.deriv)

exp(a::Dual) =
    Dual(exp(a.value),
         exp(a.value)*a.deriv)

sqrt(a::Dual) =
    Dual(sqrt(a.value),
         a.deriv/(2*sqrt(a.value)))

end