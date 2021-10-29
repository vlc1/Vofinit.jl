using Vofinit
using Test

function test_getcelltype()
    x0 = Cdouble.((0, 0, 0))
    h0 = Cdouble.((1, 1, 1))

    getcelltype(x0, h0) do x...
        sum(x .* x) - 0.25
    end
end

function test_getcc()
    x0 = Cdouble.((0, 0, 0))
    h0 = Cdouble.((1, 1, 1))
    xex = Cdouble[0, 0, 0, 0]

    getcc(x0, h0, xex) do x...
        sum(x .* x) - 0.25
    end
end

@testset "Vofinit.jl" begin
    @test test_getcelltype() == -1
    @test isapprox(test_getcc(), π / 48, rtol = 5e-3)
end

