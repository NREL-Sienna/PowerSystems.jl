export DynamicController

abstract type
    DynamicController
end

struct SimpleController <: DynamicController
	ExampleConstant :: Float64
	PrimeMover :: PrimeMover
	NumberVariables :: Int32
	NumberParams :: Int32
	Model :: Function

    function SimpleController(ExampleConstant, PrimeMover)
    	dynamics = (output, dU, U, params::Tuple, t) -> begin
    			control_value = params[1] + cos(dU[1])
        	return
        end
        NumberVariables = 1;
        NumberParams = 1;
        new(ExampleConstant, PrimeMover, NumberVariables, NumberParams, dynamics)
    end
end
