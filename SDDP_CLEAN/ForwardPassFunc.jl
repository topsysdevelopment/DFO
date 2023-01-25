function ForwardPass(selected_year, Output, csv_inputs, dynamic_var, InputSDDPData, t, forwardselect, genNum, Y)
  GMS = InputSDDPData.GMS
  PCN = InputSDDPData.PCN
  STC = InputSDDPData.STC
  MCA = InputSDDPData.MCA
  REV = InputSDDPData.REV
  ARD = InputSDDPData.ARD
  println("print select forwardpass:", select)
  tp = t
  for i = 1:numForecastYear
    if tp > 12
      tp = tp - 12
    end
  end
  t5 = t
  if t5 > 5 * 12
    t5 = t5 - 5 * 12
  end
  if t == 1
    previous_year = Y[1]
  else
    previous_year = Int(forwardselect[t-1])
  end
  # option 1
  selectedrowcdf = csv_inputs.ScenarioTMCDF[(t5-1)*numSimulation + previous_year,:]
  randnumber = rand()[1]*maximum(selectedrowcdf)
  for tt = 1:numSimulation-1
    if randnumber <= selectedrowcdf[tt+1] && randnumber > selectedrowcdf[tt]
      dynamic_var.select = tt+1
      break
    end
  end
  println(dynamic_var.select)
  forwardselect[t] = dynamic_var.select
  # # option 2
  # println(selected_year[t])
  # dynamic_var.select = Int(selected_year[t])
  # forwardselect[t] = Int(selected_year[t])

  dynamic_var.V_TY_Total_now = csv_inputs.total_treaty_storage[dynamic_var.select, t5+1]
  dynamic_var.GMS_Inflow = csv_inputs.gms_inflow[dynamic_var.select, t5]
  dynamic_var.PCN_Inflow = csv_inputs.pcn_inflow[dynamic_var.select, t5]
  dynamic_var.STC_Inflow = csv_inputs.stc_inflow[dynamic_var.select, t5]
  dynamic_var.MCA_Inflow = csv_inputs.mca_inflow[dynamic_var.select, t5]
  dynamic_var.REV_Inflow = csv_inputs.rev_inflow[dynamic_var.select, t5]
  dynamic_var.ARD_Inflow = csv_inputs.ard_inflow[dynamic_var.select, t5]

  JuMP.empty!
  Clp.empty!
  m = Model(optimizer_with_attributes(Clp.Optimizer))
  set_optimizer_attribute(m, "LogLevel", 0)
  # set_optimizer_attribute(m, "SolveType", 3)
  # end
  m = DefineVariable(m)
  m = ObjectiveFunction(t, m, dynamic_var, InputSDDPData)
  m, state_variable_GMS, state_variable_MCA, state_variable_ARD, state_variable_NT_BC, state_variable_NT_US, state_variable_TY_MCA, state_variable_TY_ARD = Constraint(t, m, mode, dynamic_var, Output, InputSDDPData, genNum)
  status = optimize!(m)
  termStatus = termination_status(m)
  if termStatus != MOI.OPTIMAL
    unset_silent(m)
    optimize!(m)
    readline()
  end


  V_TY_MCA_NOW = m[:V_TY_MCA_NOW]
  V_TY_MCA_NOW_val = JuMP.value.(V_TY_MCA_NOW)

  V_TY_ARD_NOW = m[:V_TY_ARD_NOW]
  V_TY_ARD_NOW_val = JuMP.value.(V_TY_ARD_NOW)

  V_NT_BC_NOW = m[:V_NT_BC_NOW]
  V_NT_BC_NOW_val = JuMP.value.(V_NT_BC_NOW)

  V_NT_US_NOW = m[:V_NT_US_NOW]
  V_NT_US_NOW_val = JuMP.value.(V_NT_US_NOW)

  V_NOW = m[:V_NOW]
  V_NOW_val = JuMP.value.(V_NOW)

  V_LCA_NOW = m[:V_LCA_NOW]
  V_LCA_NOW_val = JuMP.value.(V_LCA_NOW)

  V_FLEX_MCA_NOW = m[:V_FLEX_MCA_NOW]
  V_FLEX_MCA_NOW_val = JuMP.value.(V_FLEX_MCA_NOW)

  V_FLEX_ARD_NOW = m[:V_FLEX_ARD_NOW]
  V_FLEX_ARD_NOW_val = JuMP.value.(V_FLEX_ARD_NOW)

  V_IMBALANCE_NOW = m[:V_IMBALANCE_NOW]
  V_MCA_SOM_NOW_val = JuMP.value.(V_IMBALANCE_NOW)

  Output.V_TTY_candidate[genNum,t] = dynamic_var.V_TY_Total_now
  Output.V_LCA_now_candidate[genNum,t] = V_LCA_NOW_val
  Output.V_TY_MCA_now_candidate[genNum,t] = V_TY_MCA_NOW_val
  Output.V_TY_ARD_now_candidate[genNum,t] =  V_TY_ARD_NOW_val
  Output.V_NT_BC_now_candidate[genNum,t] = V_NT_BC_NOW_val
  Output.V_NT_US_now_candidate[genNum,t] = V_NT_US_NOW_val
  Output.V_now_MCA_candidate[genNum,t] = V_NOW_val[MCA]
  Output.V_now_ARD_candidate[genNum,t] = V_NOW_val[ARD]
  Output.V_now_GMS_candidate[genNum,t] = V_NOW_val[GMS]
  Output.V_MCA_FLEX_candidate[genNum,t] = V_FLEX_MCA_NOW_val
  Output.V_ARD_FLEX_candidate[genNum,t] = V_FLEX_ARD_NOW_val
  Output.V_SOM_candidate[genNum,t] = V_MCA_SOM_NOW_val
# end
return m , Output
end

