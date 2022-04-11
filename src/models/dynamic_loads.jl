function get_AggregateDistributedGenerationA_states(Freq_Flag::Int)
    if Freq_Flag == 0
        return [:Vmeas, :Pmeas, :Q_V, :Iq, :Mult, :Fmeas, :dPord, :Pord, :Ip], 9
    elseif Freq_Flag == 1
        return [:Vmeas, :Pmeas, :Q_V, :Iq, :Mult, :Fmeas, :Power_PI, :dPord, :Pord, :Ip], 10
    else
        error("Unsupported value of Freq_Flag")
    end
end
