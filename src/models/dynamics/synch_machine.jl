export SynchronousMachine
#export TwoAxis
export Classic
export OneAxis

abstract type 
    SynchronousMachine
end

struct Classic <: SynchronousMachine
    Ωb::Float64
    ωs::Float64
    H::Float64
    D::Float64
    Model::Function
    function Classic(Ωb, ωs, H, D)
        dynamics = output, du, u, input::Tuple, t -> begin
                                                    output[1] = Ωb *(u[4] - ωs)- du[3]
                                                    output[2] = (inputs[1]- u[1]*sin(u[3] - u[2])/Xd - D*(u[4] - ωs))/(2*H) - du[4]
                                                    end
    end

end

struct OneAxis <: SynchronousMachine
    Ωb::Float64
    ωs::Float64
    H::Float64
    D::Float64
    Xd::Float64
    Model::Function
    function OneAxis(Ωb, ωs, H, D, Xd) 
        dynamics  =  (output, du, u, input::Tuple, t) -> begin 
                            output = zeros(4)
                            output[3] = Ωb *(u[4] - ωs)- du[3]
                            output[4] = (inputs[1]- u[1]*sin(u[3] - u[2])/Xd - D*(u[4] - ωs))/(2*H) - du[4]
                            
                            Vd = u[3]*sin(u[3] - u[2])
                            Vq = u[3]*cos(u[3] - u[2])
                            iq = u[3]*sin(u[3] - u[2])/Xd
                            id = (inputs[2] - u[1]*cos(u[3] - u[2]))/Xd
                            
                            output[1] = Vd*id + Vq*iq
                            output[2] = Vq*id - Vd*iq
                end
           new(Ωb, ωs, H, D, dynamics)     
    end
end

#=
struct TwoAxis <: SynchronousMachine
    Ωb::Float64
    ωs::Float64
    H::Float64
    D::Float64
    Xd ::Float64
    Xq ::Float64
    Model :: Function
    ModelNumVars :: Int32
    function Generator(Wn, Ws, Pm, H, D, Xd, Eq, BusNumber)
        Model = two_axis_generator(Wn, Ws, Pm, H, D, Xd, Eq)
        new(Wn,Ws,Pm, H, D, Xd, Eq, BusNumber, Model, 4)
    end
end
=#