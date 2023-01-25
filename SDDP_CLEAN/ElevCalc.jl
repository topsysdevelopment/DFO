function ElevCalc(Output)
for sim_number = 1:numSimulation
    for t = 1: 12 * numForecastYear
        a1 = -4E-11
        b1 = 9E-05
        c1 = 640.41
        a1 = -6E-09
        b1 = 0.001
        c1 = 640.41
        Output.H_value_GMS[sim_number, t] = a1* Output.V_NOW_value_GMS[sim_number, t]^2 + b1* Output.V_NOW_value_GMS[sim_number, t] + c1
        a1 = -6E-10
        b1 = 0.0005
        c1 = 657.72 
        a1 = -8E-08
        b1 = 0.0058
        c1 = 657.72
        Output.H_value_MCA[sim_number, t] = a1* Output.V_NOW_value_MCA[sim_number, t]^2 + b1* Output.V_NOW_value_MCA[sim_number, t] + c1
        a1 = 0
        b1 = 0.0002
        c1 = 420.66  
        Output.H_value_ARD[sim_number, t] = a1* Output.V_NOW_value_ARD[sim_number, t]^2 + b1* Output.V_NOW_value_ARD[sim_number, t] + c1

        # y2 = 2.01079E-10
        # a2 = -5.97E-08
        # b2 = 9.79E-04
        # c2 = 5.02094E+02
        # TailwaterGMS =  y2* Output.QT_NOW_val_GMS[sim_number, t]^3 + a2* Output.QT_NOW_val_GMS[sim_number, t]^2 + b2* Output.QT_NOW_val_GMS[sim_number, t] + c2
        # H_GMS[sim_number, t] = H_value_GMS[sim_number, t] - TailwaterGMS
        # y2 = 3.732022E-10
        # a2 = -3.205027E-08
        # b2 = 1.507249E-03
        # c2 = 5.707599E+02  
        # TailwaterMCA =  y2* Output.QT_NOW_val_MCA[sim_number, t]^3 + a2* Output.QT_NOW_val_MCA[sim_number, t]^2 + b2* Output.QT_NOW_val_MCA[sim_number, t] + c2
        # H_MCA[sim_number, t] = H_value_MCA[sim_number, t] - TailwaterMCA
        # y2 = 1.49022E-10
        # a2 = -1.14889E-06
        # b2 = 4.30204E-03
        # c2 = 4.15982E+02  
        # TailwaterARD =  y2* Output.QT_NOW_val_ARD[sim_number, t]^3 + a2* Output.QT_NOW_val_ARD[sim_number, t]^2 + b2* Output.QT_NOW_val_ARD[sim_number, t] + c2
        # H_ARD[sim_number, t] = H_value_ARD[sim_number, t] - TailwaterARD
    end

    return Output
  end
end
Output = ElevCalc(Output)