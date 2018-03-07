export PrimeMover
export HydrualicTurbine

abstract type 
    PrimeMover
end

struct HydrualicTurbine <: PrimeMover
	Tw :: Float64
	Pᵣ :: Float64
	L :: Float64
	Ur :: Float64
	aᵧ :: Float64
	Hᵣ :: Float64
	Aₜ :: Float64
	gfl :: Float64
	gₙₗ :: Float64
	H₀  :: Float64
	Uₙₗ  :: Float64
	Generator :: SynchronousMachine
	NumberVariables :: Int32
	NumberParams :: Int32
	Model :: Function

    function HydrualicTurbine(Pᵣ, L, Uᵣ, aᵧ, Hᵣ, gfl, gₙₗ, H₀, Generator)
        Aₜ = 1/(gₗ - gₙₗ)
   		Tw = (L * Uᵣ)/(aᵧ * Hᵣ)
    	Uₙₗ = Aₜ*gₙₗ*sqrt(H₀)

        dynamics = (output, dU, U, params::Tuple, t) -> begin
 			V = U[1] #water velocity
 			dV = dU[1] #water acceleration
 			g = params[1]

        	output = 0.0
       		output = -1/Tw*( (V/(Aₜ*g) )^2 - H₀) - dV
        	Pm = (dV - Uₙₗ)*(V/(Aₜ * g ))^2*Pᵣ
        	return Pm
        end
        NumberVariables = 1;
        NumberParams = 1;
        new(Tw, Pᵣ, L, Uᵣ, aᵧ, Hᵣ, Aₜ, gfl, gₙₗ, H₀, Uₙₗ, Generator, NumberVariables, NumberParams, dynamics)
    end
    
end