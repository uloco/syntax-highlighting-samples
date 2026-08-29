# Julia highlight sample
#= block comment =#
module Demo
using Printf: @printf
import Base: show
export Shape, area, ∑
abstract type Shape end
const ORIGIN = (x = 0.0, y = -1.5e-5)
const LIMITS = Dict(:min => 0x00, :max => 0xFF, "raw" => raw"C:\re\gex")
struct Circle{T<:Real} <: Shape
    r::T
    tag::Union{Symbol,Nothing}
end
mutable struct Poly <: Shape
    pts::Matrix{Float64}
    closed::Bool
    Poly(pts) = new(pts, false)
end

"""
    area(s::Shape; scale=1.0)

Docstring with `code`, **bold** and $(1 + 1).
"""
function area(c::Circle{T}; scale::Float64 = 1.0, extra...) where {T<:Real}
    local acc = π * c.r^2 * scale
    global CALLS = 1_000_000
    return acc ≤ 0 ? missing : acc
end
area(p::Poly) = sum(abs, p.pts[:, 1])
area(::Nothing) = nothing
macro twice(ex)
    :(println("expanded ", $(esc(ex))))
end
function ∑(xs::AbstractVector{<:Number}, args...)
    @assert !isempty(xs) "empty $(typeof(xs))"
    total = zero(eltype(xs))
    @inbounds for (i, x) in enumerate(xs)
        i == 1 && continue
        x isa Missing && break
        total += x >> 1 | 0b1010
    end
    total
end

function report(n::Int = 3)
    evens = [i^2 for i in 1:2:10 if iseven(i - 1)]
    gen = (2x for x in evens)
    tbl = [1 2 3; 4 5 6]
    piped = sqrt.(evens .+ 0o17) |> sum
    open("/tmp/f.txt", "w") do io
        write(io, "n=$n f32=$(3.14f0) rat=$(1//3)\ttrue=$(true)\n")
    end
    let s = 'a', t = "single"
        @printf("%s %c\n", t, s)
    end
    if n ∈ 1:5
        @twice "small"
    elseif n > 5 && !false
        while true
            n -= 1
            n < 0 && break
        end
    else
        throw(DomainError(n, "bad"))
    end
    begin
        try
            error("boom")
        catch err
            @time show(stderr, err)
        finally
            nothing
        end
    end
    return (tbl, piped, gen, map(x -> x + 1, evens)...)
end
end # module
