function BackwardPass(InputData, Output, csv_inputs, dynamic_var, t, forwardselect, genNum, cut_n)
  GMS = InputSDDPData.GMS
  PCN = InputSDDPData.PCN
  STC = InputSDDPData.STC
  MCA = InputSDDPData.MCA
  REV = InputSDDPData.REV
  ARD = InputSDDPData.ARD
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

  vecp = [-1 0 1]
  vecc = [-1 0 1]
  ij = 0
  for i = 1:3
    for j = 1:3
      ij = ij + 1
      selected_year, prob_peace, prob_columbia = SeFcCalc(InputData, t, [vecc[j] vecp[i]], [vecc[j] vecp[i]])
      # option 1
      selectedrowcdf = csv_inputs.ScenarioTMCDF[(t5-1)*numSimulation + Int(forwardselect[t]),:]
      # selectedrow = ScenarioTM[(t5-1)*numSimulation + forwardselect,:]
      randnumber = rand()[1]*maximum(selectedrowcdf)
      for tt = 1:numSimulation-1
        if randnumber <= selectedrowcdf[tt+1] && randnumber > selectedrowcdf[tt]
          dynamic_var.select = tt+1
          break
        end
      end
      # # option 2
      # dynamic_var.select = selected_year

      dynamic_var.V_TY_Total_now = csv_inputs.total_treaty_storage[dynamic_var.select, t5+1]
      dynamic_var.GMS_Inflow = csv_inputs.gms_inflow[dynamic_var.select, t5]
      dynamic_var.PCN_Inflow = csv_inputs.pcn_inflow[dynamic_var.select, t5]
      dynamic_var.STC_Inflow = csv_inputs.stc_inflow[dynamic_var.select, t5]
      dynamic_var.MCA_Inflow = csv_inputs.mca_inflow[dynamic_var.select, t5]
      dynamic_var.REV_Inflow = csv_inputs.rev_inflow[dynamic_var.select, t5]
      dynamic_var.ARD_Inflow = csv_inputs.ard_inflow[dynamic_var.select, t5]

      JuMP.empty!
      Clp.empty!
      # m = Model(HiGHS.Optimizer)
      m = Model(optimizer_with_attributes(Clp.Optimizer))
      # # set_optimizer_attribute(m, "SolveType", 3)
      set_optimizer_attribute(m, "LogLevel", 0)
      m = DefineVariable(m)
      
      m = ObjectiveFunction(t, m, dynamic_var, InputSDDPData)
      m, state_variable_GMS, state_variable_MCA, state_variable_ARD, state_variable_NT_BC, state_variable_NT_US, state_variable_TY_MCA, state_variable_TY_ARD = Constraint(t, m, mode, dynamic_var, Output, InputSDDPData, genNum)

      status = optimize!(m)
      # check if its feasible or not
      termStatus = termination_status(m)
      if termStatus != MOI.OPTIMAL
        unset_silent(m)
        optimize!(m)
        readline()
      end

      lambda_state_variable_GMS = -dual(state_variable_GMS)
      lambda_state_variable_MCA = -dual(state_variable_MCA)
      lambda_state_variable_ARD = -dual(state_variable_ARD)
      lambda_state_variable_NT_BC = -dual(state_variable_NT_BC)
      lambda_state_variable_NT_US = -dual(state_variable_NT_US)
      lambda_state_variable_TY_MCA = -dual(state_variable_TY_MCA)
      lambda_state_variable_TY_ARD = -dual(state_variable_TY_ARD)
      lambda_TTY_equation = 0#-dual(TTY_equation)
      lambda_SOM_equation = 0#-dual(state_variable_SOM)
      lambda_FLEX_MCA = 0#-dual(state_variable_FLEX_MCA)


      fval = objective_value(m)

      if t > 1

        Term1 = lambda_state_variable_GMS * (Output.V_now_GMS_candidate[genNum,t-1] - InputSDDPData.reservoir_constraintMin_storage[GMS])
        Term2 = lambda_state_variable_MCA * (Output.V_now_MCA_candidate[genNum,t-1] - InputSDDPData.reservoir_constraintMin_storage[MCA])
        Term3 = lambda_state_variable_ARD * (Output.V_now_ARD_candidate[genNum,t-1] - InputSDDPData.reservoir_constraintMin_storage[ARD])
        Term4 = lambda_state_variable_NT_BC * (Output.V_NT_BC_now_candidate[genNum,t-1] - InputSDDPData.V_NT_min_BC[tp])
        Term5 = lambda_state_variable_NT_US * (Output.V_NT_US_now_candidate[genNum,t-1] - InputSDDPData.V_NT_min_BC[tp])
        Term6 = 0#lambda_state_variable_TY_MCA * (Output.V_TY_MCA_now_candidate[genNum,t-1])
        Term7 = 0#lambda_state_variable_TY_ARD * (V_TY_ARD_now_candidate[genNum,t-1])
        TermIM = 0#lambda_SOM_equation*V_SOM_candidate[genNum,t-1]
        TermFLEX = 0#lambda_FLEX_MCA*Output.V_MCA_FLEX_candidate[genNum,t-1]
        term8 = (fval - Term1 - Term2 - Term3 - Term4 - Term5 - Term6 - Term7-TermFLEX)
        Output.cut_intercept[cut_n, t-1] = Output.cut_intercept[cut_n, t-1] + (term8) * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_GMS[cut_n, t-1] = Output.cut_slope_GMS[cut_n, t-1] + lambda_state_variable_GMS * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_MCA[cut_n, t-1] = Output.cut_slope_MCA[cut_n, t-1] + lambda_state_variable_MCA * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_ARW[cut_n, t-1] = Output.cut_slope_ARW[cut_n, t-1] + lambda_state_variable_ARD * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_NonTreaty_CA[cut_n, t-1] = Output.cut_slope_NonTreaty_CA[cut_n, t-1] + lambda_state_variable_NT_BC * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_NonTreaty_US[cut_n, t-1] = Output.cut_slope_NonTreaty_US[cut_n, t-1] + lambda_state_variable_NT_US * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_Treaty_MCA[cut_n, t-1] = Output.cut_slope_Treaty_MCA[cut_n, t-1] + lambda_state_variable_TY_MCA * prob_peace[i] * prob_columbia[j]
        Output.cut_slope_Treaty_ARW[cut_n, t-1] = Output.cut_slope_Treaty_ARW[cut_n, t-1] + lambda_state_variable_TY_ARD * prob_peace[i] * prob_columbia[j]
        # Output.cut_slope_TY[cut_n, t-1] = Output.cut_slope_TY[cut_n, t-1] + lambda_SOM_equation * prob_peace[i] * prob_columbia[j]
        # Output.cut_slope_FLEX[cut_n, t-1] = Output.cut_slope_FLEX[cut_n, t-1] + lambda_FLEX_MCA * prob_peace[i] * prob_columbia[j]

      end

    end
  end

  return Output
end
