module Vofi

using libvofi_jll

export getcelltype, getcc

const cintegrand = Ref{Ptr{Cvoid}}(0)

function integrand(xyz, thunk)
    func = unsafe_pointer_to_objref(thunk)
    x = unsafe_load(xyz, 1)
    y = unsafe_load(xyz, 2)
    z = unsafe_load(xyz, 3)
    func(x, y, z)
end

function getcelltype(func, x0, h0, ndim0 = Cint(3))
    @ccall libvofi.vofi_get_cell_type(cintegrand[]::Ptr{Cvoid},
                                      func::Any,
                                      x0::Ref{Cdouble},
                                      h0::Ref{Cdouble},
                                      ndim0::Cint)::Cint
end

function getcc(func, x0, h0, xex, ndim0 = Cint(3);
               nex = Cint.((0, 0)),
               npt = Cint.((4, 4, 4, 4)),
               nvis = Cint.((0, 0)))
    @ccall libvofi.vofi_get_cc(cintegrand[]::Ptr{Cvoid},
                               func::Any,
                               x0::Ref{Cdouble},
                               h0::Ref{Cdouble},
                               xex::Ref{Cdouble},
                               nex::Ref{Cint},
                               npt::Ref{Cint},
                               nvis::Ref{Cint},
                               ndim0::Cint)::Cdouble
end

function __init__()
    cintegrand[] = @cfunction(integrand, Cdouble, (Ptr{Cdouble}, Ptr{Cvoid}))
end


end
