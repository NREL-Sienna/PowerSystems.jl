nodes_OMIB= [Bus(1 , #number
                 "Bus 1", #Name
                 "REF" , #BusType (REF, PV, PQ)
                 0, #Angle in radians
                 1.06, #Voltage in pu
                 (min=0.94, max=1.06), #Voltage limits in pu
                 69), #Base voltage in kV
                Bus(2 , "Bus 2"  , "PV" , 0 , 1.045 , (min=0.94, max=1.06), 69)]

branch_OMIB = [PSY.Line("Line1", #name
                     true, #available
                     0.0, #active power flow initial condition (from-to)
                     0.0, #reactive power flow initial condition (from-to)
                     Arc(from=nodes_OMIB[1], to=nodes_OMIB[2]), #Connection between buses
                     0.01, #resistance in pu
                     0.05, #reactance in pu
                     (from=0.0, to=0.0), #susceptance in pu
                     18.046, #rate in MW
                     1.04)]  #angle limits (-min and max)

@testset "Dynamic Machines" begin
Basic = BaseMachine(   0.0, #R
                       0.2995, #Xd_p
                       1.05, #eq_p
                       615.0)  #MVABase
@test Basic isa PowerSystems.DynamicComponent

oneDoneQ = OneDOneQMachine(0.0, #R
                        0.8979, #Xd
                        0.646, #Xq
                        0.2995, #Xd_p
                        0.04, #Xq_p
                        7.4, #Td0_p
                        0.033, #Tq0_p
                        615.0)   #MVABase
@test oneDoneQ isa PowerSystems.DynamicComponent

AndersonFouad = AndersonFouadMachine(0.0, #R
                        0.8979, #Xd
                        0.646, #Xq
                        0.2995, #Xd_p
                        0.646, #Xq_p
                        0.23, #Xd_pp
                        0.4, #Xq_pp
                        7.4, #Td0_p
                        0.01, #Tq0_p #Data not available in Milano: Used 0.01
                        0.03, #Td0_pp
                        0.033, #Tq0_pp
                        615.0) #MVABase
@test AndersonFouad isa PowerSystems.DynamicComponent

KundurMachine = SimpleFullMachine(0.003, #R on Example 3.1 and 4.1 of Kundur
                                  0.0006, #R_f
                                  0.0284, #R_1d or RD in Machowski
                                  0.0062, #R_1q or RQ on Machowski
                                  1.81, #L_d
                                  1.76, #L_q
                                  1.66, #L_ad or k*M_f or k*M_D in Machowski
                                  1.61, #L_aq or k*M_Q in Machowski
                                  1.66, #L_f1d or L_fD in Machowski. Assumed to be equal to L_ad
                                  1.825, #L_ff
                                  0.1713, #L_1d or L_D in Machowski
                                  0.7525, #L_1q or L_Q in Machowski
                                  555.0) #MVABase
@test KundurMachine isa PowerSystems.DynamicComponent


KundurFullMachine = FullMachine(0.003, #R on Example 3.1 and 4.1 of Kundur
                                0.0006, #R_f
                                #0.003, #R_f
                                0.0284, #R_1d or RD in Machowski
                                0.0062, #R_1q or RQ on Machowski
                                1.81, #L_d
                                1.76, #L_q
                                1.66, #L_ad or k*M_f or k*M_D in Machowski
                                1.61, #L_aq or k*M_Q in Machowski
                                1.66, #L_f1d or L_fD in Machowski. Assumed to be equal to L_ad
                                1.825, #L_ff
                                0.1713, #L_1d or L_D in Machowski
                                0.7525, #L_1q or L_Q in Machowski
                                555.0) #MVABase
@test KundurFullMachine isa PowerSystems.DynamicComponent

Mach2_benchmark = OneDOneQMachine(0.0, #R
                        1.3125, #Xd
                        1.2578, #Xq
                        0.1813, #Xd_p
                        0.25, #Xq_p
                        5.89, #Td0_p
                        0.6, #Tq0_p
                        100.0)   #MVABase
@test Mach2_benchmark isa PowerSystems.DynamicComponent
end

################ Shaft Data #####################
@testset "Dynamic Shaft" begin
BaseShaft = SingleMass(5.148, #H
                       2.0) #D
@test BaseShaft isa PowerSystems.DynamicComponent

FiveShaft = FiveMassShaft(5.148,  #H
                          0.3348, #H_hp
                          0.7306, #H_ip
                          0.8154, #H_lp
                          0.0452, #H_ex,
                          2.0,    #D
                          0.5180, #D_hp
                          0.2240, #D_ip
                          0.2240, #D_lp
                          0.1450, #D_ex
                          0.0518, #D_12
                          0.0224, #D_23
                          0.0224, #D_34
                          0.0145, #D_45
                          33.07,  #K_hp
                          28.59,  #K_ip
                          44.68,  #K_lp
                          21.984) #K_ex
@test FiveShaft isa PowerSystems.DynamicComponent
end

################# PSS Data #####################
@testset "Dynamic PSS" begin
no_pss = PSSFixed(0.0)
@test no_pss isa PowerSystems.DynamicComponent
end
################ TG Data #####################
@testset "Dynamic Turbine Governor Constructors" begin
fixed_tg = TGFixed(1.0) #eff
@test fixed_tg isa PowerSystems.DynamicComponent

typeI_tg = TGTypeI(0.02, #R
                   0.1, #Ts
                   0.45, #Tc
                   0.0, #T3
                   0.0, #T4
                   50.0, #T5
                   0.3, #P_min
                   1.2) #P_max
@test typeI_tg isa PowerSystems.DynamicComponent

typeII_tg = TGTypeII(0.05, #R
                     0.3, #T1
                     0.1, #T2
                     1.0, #τ_max
                     0.1) #τ_min
@test typeII_tg isa PowerSystems.DynamicComponent
end
################ AVR Data #####################
@testset "Dynamic AVR Constructors" begin
proportional_avr = AVRSimple(5000.0) #Kv
@test proportional_avr isa PowerSystems.DynamicComponent

fixed_avr = AVRFixed(1.05) #Emf
@test fixed_avr isa PowerSystems.DynamicComponent

typeI_avr = AVRTypeI(200.0, #Ka
                     1.0, #Ke
                     0.0012, #Kf
                     0.02, #Ta
                     0.19, #Te
                     1.0, #Tf
                     0.001, #Tr
                     9.9, #Vr_max
                     0.0, #Vr_min
                     0.0006, #Ae
                     0.9)
@test typeI_avr isa PowerSystems.DynamicComponent

gen2_avr_benchmark = AVRTypeII(20.0, #K0 - Gain
                     0.2, #T1 - 1st pole
                     0.063, #T2 - 1st zero
                     0.35, #T3 - 2nd pole
                     0.01, #T4 - 2nd zero
                     0.314, #Te - Field current time constant
                     0.001, #Tr - Measurement time constant
                     5.0, #Vrmax
                     -5.0, #Vrmin
                     0.0039, #Ae - 1st ceiling coefficient
                     1.555) #Be - 2nd ceiling coefficient
@test gen2_avr_benchmark isa PowerSystems.DynamicComponent
end
######################### Generators ########################
@testset "Dynamic Generators" begin
#Components for the test
Basic = BaseMachine(   0.0, #R
                       0.2995, #Xd_p
                       1.05, #eq_p
                       615.0)  #MVABase

BaseShaft = SingleMass(5.148, #H
                       2.0) #D

fixed_avr = AVRFixed(1.05) #Emf

proportional_avr = AVRSimple(5000.0) #Kv

fixed_tg = TGFixed(1.0) #eff

no_pss = PSSFixed(0.0)

oneDoneQ = OneDOneQMachine(0.0, #R
                        0.8979, #Xd
                        0.646, #Xq
                        0.2995, #Xd_p
                        0.04, #Xq_p
                        7.4, #Td0_p
                        0.033, #Tq0_p
                        615.0)   #MVABase

Gen1AVR = DynamicGenerator(1, #Number
                 "TestGen",
                 nodes_OMIB[2],#bus
                 1.0, # ω_ref,
                 1.05,
                 0.4,
                 Basic,
                 BaseShaft,
                 proportional_avr, #avr
                 fixed_tg, #tg
                 no_pss)
@test Gen1AVR isa PowerSystems.Component

Gen1AVRnoAVR = DynamicGenerator(1, #Number
                 "TestGen",
                 nodes_OMIB[2],#bus
                 1.0, # ω_ref,
                 1.05,
                 0.4,
                 Basic,
                 BaseShaft,
                 fixed_avr, #avr
                 fixed_tg, #tg
                 no_pss)
@test Gen1AVRnoAVR isa PowerSystems.Component

Gen2AVRnoAVR = DynamicGenerator(1, #Number
                 "TestGen",
                 nodes_OMIB[2],#bus
                 1.0, # ω_ref,
                 1.02,
                 0.4,
                 oneDoneQ,
                 BaseShaft,
                 fixed_avr, #avr
                 fixed_tg, #tg
                 no_pss)
@test Gen2AVRnoAVR isa PowerSystems.Component

Gen2AVR = DynamicGenerator(1, #Number
                 "TestGen",
                 nodes_OMIB[2],#bus
                 1.0, # ω_ref,
                 1.02,
                 0.4,
                 oneDoneQ,
                 BaseShaft,
                 proportional_avr, #avr
                 fixed_tg, #tg
                 no_pss)
@test Gen2AVR isa PowerSystems.Component

sys = PSY.System(100)
for bus in nodes_OMIB
    PSY.add_component!(sys, bus)
end
for lines in branch_OMIB
    PSY.add_component!(sys, lines)
end
PSY.add_component!(sys, Gen1AVR)

@test collect(PSY.get_components(DynamicGenerator, sys))[1] == Gen1AVR

end
