function get_GenericDER_states(Qref_Flag::Int)
    if Qref_Flag == 1
        return [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9], 9
    elseif Qref_Flag == 2 || Qref_Flag == 3
        return [:x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9], 8
    else
        error("Unsupported value of Qref_Flag")
    end
end

function get_AggregateDistributedGenerationA_states(Freq_Flag::Int)
    if Freq_Flag == 0
        return [:Vmeas, :Pmeas, :Q_V, :Iq, :Mult, :Fmeas, :dPord, :Pord, :Ip], 9
    elseif Freq_Flag == 1
        return [:Vmeas, :Pmeas, :Q_V, :Iq, :Mult, :Fmeas, :Power_PI, :dPord, :Pord, :Ip], 10
    else
        error("Unsupported value of Freq_Flag")
    end
end
