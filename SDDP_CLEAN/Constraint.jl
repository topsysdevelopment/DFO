function Constraint(t, m, mode, dynamic_var, Output, InputSDDPData, genNum)

  V_now_GMS_candidate = Output.V_now_GMS_candidate
  V_now_MCA_candidate = Output.V_now_MCA_candidate
  V_now_ARD_candidate = Output.V_now_ARD_candidate
  V_NT_BC_now_candidate = Output.V_NT_BC_now_candidate
  V_NT_US_now_candidate = Output.V_NT_US_now_candidate
  V_TY_MCA_now_candidate = Output.V_TY_MCA_now_candidate
  V_TY_ARD_now_candidate = Output.V_TY_ARD_now_candidate
  V_LCA_now_candidate = Output.V_LCA_now_candidate
  V_SOM_candidate = Output.V_SOM_candidate
  V_MCA_FLEX_candidate = Output.V_MCA_FLEX_candidate
  V_ARD_FLEX_candidate = Output.V_ARD_FLEX_candidate

  GMS = InputSDDPData.GMS
  PCN = InputSDDPData.PCN
  STC = InputSDDPData.STC
  MCA = InputSDDPData.MCA
  REV = InputSDDPData.REV
  ARD = InputSDDPData.ARD

  GMS_Inflow = dynamic_var.GMS_Inflow
  PCN_Inflow = dynamic_var.PCN_Inflow 
  STC_Inflow = dynamic_var.STC_Inflow 
  MCA_Inflow = dynamic_var.MCA_Inflow 
  REV_Inflow = dynamic_var.REV_Inflow 
  ARD_Inflow = dynamic_var.ARD_Inflow 

  # what date is t?
 
  currentStageDate = Date(2021,12,1) # type Date or DateTime

  tp = month(currentStageDate)
  tpPlus1 = month(currentStageDate + Month(1))

  t5 = t
  if t5 > 5 * 12
    t5 = t5 - 5 * 12
  end

  V_TY_Total_SV = m[:V_TY_Total_SV]
  s1 = m[:s1]
  s2 = m[:s2]
  DEFICITIMP = m[:DEFICITIMP]
  SURPLUSEXP = m[:SURPLUSEXP]
  V_SV = m[:V_SV]
  V_AVE = m[:V_AVE]
  V_LCA_SOM = m[:V_LCA_SOM]
  V_LCA_NOW = m[:V_LCA_NOW]
  V_TY_MCA_SV = m[:V_TY_MCA_SV]
  V_TY_ARD_SV = m[:V_TY_ARD_SV]
  V_NT_BC_SV = m[:V_NT_BC_SV]
  V_NT_US_SV = m[:V_NT_US_SV]
  V_NOW = m[:V_NOW] # end of period t
  V_LIVE = m[:V_LIVE]
  QP_NOW = m[:QP_NOW]
  P_NOW = m[:P_NOW]
  QT_NOW = m[:QT_NOW]
  QS_NOW = m[:QS_NOW]
  Q_SOA = m[:Q_SOA]
  V_SOA_SOM = m[:V_SOA_SOM]
  Q_LCA = m[:Q_LCA]
  V_TY_MCA_NOW = m[:V_TY_MCA_NOW]
  V_TY_ARD_NOW = m[:V_TY_ARD_NOW]
  Q_TY_MCA_NOW = m[:Q_TY_MCA_NOW]
  Q_TY_ARD_NOW = m[:Q_TY_ARD_NOW]
  V_NT_BC_NOW = m[:V_NT_BC_NOW]
  V_NT_US_NOW = m[:V_NT_US_NOW]
  Q_NT_BC_NOW = m[:Q_NT_BC_NOW]
  Q_NT_US_NOW = m[:Q_NT_US_NOW]
  WATER_VALUE = m[:WATER_VALUE]
  SPOT_EXP_USH_NOW = m[:SPOT_EXP_USH_NOW]
  SPOT_IMP_USH_NOW = m[:SPOT_IMP_USH_NOW]
  V_FLEX_MCA_NOW = m[:V_FLEX_MCA_NOW]
  V_FLEX_MCA_SV = m[:V_FLEX_MCA_SV]
  Q_FLEX_MCA = m[:Q_FLEX_MCA]
  V_FLEX_ARD_NOW = m[:V_FLEX_ARD_NOW]
  V_FLEX_ARD_SV = m[:V_FLEX_ARD_SV]
  Q_FLEX_ARD = m[:Q_FLEX_ARD]
  V_IMBALANCE_NOW = m[:V_IMBALANCE_NOW]
  V_IMBALANCE_SV = m[:V_IMBALANCE_SV]
  Q_IMBALANCE = m[:Q_IMBALANCE]


  if t == 1 # DEC 1st
    JuMP.@constraint(m, V_TY_Total_SV == 165982)
    JuMP.@constraint(m, V_LCA_SOM == 0) # LCA
    JuMP.@constraint(m, V_TY_MCA_SV == 74669) # MCA
    JuMP.@constraint(m, V_TY_ARD_SV == 91313) # ARD
    JuMP.@constraint(m, V_NT_BC_SV == 14430) # NT_BC
    JuMP.@constraint(m, V_NT_US_SV == 28201) # NT_US
    JuMP.@constraint(m, V_SV[GMS] == 404360.58) # GMS 
    JuMP.@constraint(m, V_FLEX_MCA_SV == 0) 
    JuMP.@constraint(m, V_FLEX_ARD_SV == 0) 
    JuMP.@constraint(m, V_IMBALANCE_SV == 0) 
    JuMP.@constraint(m, V_SV[MCA] == V_FLEX_MCA_SV + V_TY_MCA_SV + V_NT_BC_SV + V_NT_US_SV + V_SOA_SOM + InputSDDPData.reservoir_constraintMin_storage[MCA])
    JuMP.@constraint(m, V_SV[ARD] == V_IMBALANCE_SV + V_FLEX_ARD_SV + V_TY_ARD_SV + V_LCA_SOM + InputSDDPData.reservoir_constraintMin_storage[ARD])
  else
    JuMP.@constraint(m, V_TY_Total_SV == V_TY_MCA_now_candidate[genNum,t-1] + V_TY_ARD_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_LCA_SOM == V_LCA_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_TY_MCA_SV == V_TY_MCA_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_TY_ARD_SV == V_TY_ARD_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_NT_BC_SV == V_NT_BC_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_NT_US_SV == V_NT_US_now_candidate[genNum,t-1])
    JuMP.@constraint(m, V_SV[GMS] == V_now_GMS_candidate[genNum,t-1])
    JuMP.@constraint(m, V_FLEX_MCA_SV == V_MCA_FLEX_candidate[genNum,t-1])
    JuMP.@constraint(m, V_FLEX_ARD_SV == V_ARD_FLEX_candidate[genNum,t-1])
    JuMP.@constraint(m, V_IMBALANCE_SV == V_SOM_candidate[genNum,t-1])
    JuMP.@constraint(m, V_SV[MCA] == V_now_MCA_candidate[genNum,t-1])
    JuMP.@constraint(m, V_SV[ARD] == V_now_ARD_candidate[genNum,t-1])
  end

  if tp == 1
    JuMP.@constraint(m, V_SOA_SOM == 0) # SOA
  else
    JuMP.@constraint(m, V_SOA_SOM == InputSDDPData.V_SOA_P[tp]) # SOA
  end

  state_variable_FLEX_MCA = JuMP.@constraint(m, V_FLEX_MCA_NOW == V_FLEX_MCA_SV + (-Q_FLEX_MCA) * InputSDDPData.numDayCalendar[tp])
  state_variable_FLEX_ARD = JuMP.@constraint(m, V_FLEX_ARD_NOW == V_FLEX_ARD_SV + (Q_FLEX_MCA) * InputSDDPData.numDayCalendar[tp])
  state_variable_SOM = JuMP.@constraint(m, V_IMBALANCE_NOW == V_IMBALANCE_SV + (-Q_IMBALANCE) * InputSDDPData.numDayCalendar[tp])
  JuMP.@constraint(m, V_IMBALANCE_NOW == s1-s2)

  JuMP.@constraint(m, Q_SOA == (V_SOA_SOM - InputSDDPData.V_SOA_P[tpPlus1]) / InputSDDPData.numDayCalendar[tp])
  state_variable_NT_BC = JuMP.@constraint(m, V_NT_BC_NOW == V_NT_BC_SV + (-Q_NT_BC_NOW) * InputSDDPData.numDayCalendar[tp])
  state_variable_NT_US = JuMP.@constraint(m, V_NT_US_NOW == V_NT_US_SV + (-Q_NT_US_NOW) * InputSDDPData.numDayCalendar[tp])
  state_variable_LCA = JuMP.@constraint(m, V_LCA_NOW == V_LCA_SOM + (-Q_LCA) * InputSDDPData.numDayCalendar[tp])
  JuMP.@constraint(m, V_NOW[MCA] == V_FLEX_MCA_NOW + V_TY_MCA_NOW + V_NT_BC_NOW + V_NT_US_NOW + InputSDDPData.V_SOA_P[tpPlus1] + InputSDDPData.reservoir_constraintMin_storage[MCA])
  # JuMP.@constraint(m, QP_NOW[MCA] == Q_TY_MCA_NOW + Q_NT_BC_NOW + Q_NT_US_NOW + Q_FLEX_MCA + Q_SOA)
  # JuMP.@constraint(m, V_NOW[ARD] == V_TY_ARD_NOW + V_FLEX_ARD_NOW + V_LCA_NOW + reservoir_constraintMin_storage[ARD])
  JuMP.@constraint(m, QP_NOW[ARD] == Q_IMBALANCE + Q_TY_ARD_NOW + Q_NT_BC_NOW + Q_NT_US_NOW + Q_LCA + Q_SOA)
  

  JuMP.@constraint(m, V_TY_MCA_NOW + V_TY_ARD_NOW == dynamic_var.V_TY_Total_now)
  # V_TY_max_MCA & V_TY_min_MCA ###
  #JuMP.@constraint(m, V_TY_MCA_NOW <= TY_MCA_max[t])
  # @JuMP.constraint(m, V_TY_MCA_NOW >= mca_sv_min[select,t5])
  #@JuMP.constraint(m, V_TY_MCA_NOW >= TY_MCA_min[t])

  ### V_TY_max_ARD & V_TY_min_ARD ###
  # JuMP.@constraint(m, V_TY_ARD_NOW <= V_TY_max_ARD[tp])
  JuMP.@constraint(m, V_TY_ARD_NOW >= 0)  # not sure this is necessary
  # end

  state_variable_TY_MCA = JuMP.@constraint(m, V_TY_MCA_NOW == V_TY_MCA_SV + (MCA_Inflow - Q_TY_MCA_NOW) * InputSDDPData.numDayCalendar[tp])
  state_variable_TY_ARD = JuMP.@constraint(m, V_TY_ARD_NOW == V_TY_ARD_SV + (Q_TY_MCA_NOW + REV_Inflow + ARD_Inflow - Q_TY_ARD_NOW) * InputSDDPData.numDayCalendar[tp]) 
  # TTY_equation = JuMP.@constraint(m, V_TY_Total_now == V_TY_Total_SV + (MCA_Inflow + REV_Inflow + ARD_Inflow - Q_TY_ARD_NOW) * numDayCalendar[tp]) 

  state_variable_MCA = JuMP.@constraint(m, V_NOW[MCA] == V_SV[MCA] + (MCA_Inflow - QP_NOW[MCA]) * InputSDDPData.numDayCalendar[tp])
  state_variable_REV = JuMP.@constraint(m, 0 == QP_NOW[MCA] + REV_Inflow - QP_NOW[REV])
  state_variable_ARD = JuMP.@constraint(m, V_NOW[ARD] == V_SV[ARD] + (QP_NOW[REV] + ARD_Inflow - QP_NOW[ARD]) * InputSDDPData.numDayCalendar[tp])

  
  JuMP.@constraint(m, V_LCA_NOW >= 0)
  JuMP.@constraint(m, V_LCA_NOW <= 0)
  # JuMP.@constraint(m, Q_LCA_min[tp] <= Q_LCA <= Q_LCA_max[tp])
  state_variable_GMS = JuMP.@constraint(m, V_NOW[GMS] == V_SV[GMS] + (GMS_Inflow - QP_NOW[GMS]) * InputSDDPData.numDayCalendar[tp]) # end of period t
  state_variable_PCN = JuMP.@constraint(m, 0 == (QP_NOW[GMS] + PCN_Inflow - QP_NOW[PCN]) * InputSDDPData.numDayCalendar[tp])
  state_variable_STC = JuMP.@constraint(m, 0 == (QP_NOW[PCN] + STC_Inflow - QP_NOW[STC]) * InputSDDPData.numDayCalendar[tp])


  if t5<numStage5
    # if mode == "Simulation" || mode == "Forward"
    #   JuMP.@constraint(m, V_NOW[MCA] >= csv_inputs.mca_sv_min[dynamic_var.select,t5+1] + V_NT_BC_NOW + V_NT_US_NOW - InputSDDPData.V_NT_min_BC[tpPlus1] - InputSDDPData.V_NT_min_BC[tpPlus1] )
    # JuMP.@constraint(m, QP_NOW[MCA] <= (V_SV[MCA]-(csv_inputs.mca_sv_min[dynamic_var.select,t5+1] + V_NT_BC_NOW + V_NT_US_NOW - InputSDDPData.V_NT_min_BC[tpPlus1] - InputSDDPData.V_NT_min_BC[tpPlus1]))/InputSDDPData.numDayCalendar[tp] + MCA_Inflow) 
    # end
    JuMP.@constraint(m, V_NOW[ARD] <= fccblock[dynamic_var.select,t5+1])
  end


  # if mode == "Simulation" || mode == "Forward"
  @JuMP.constraint(m, QP_NOW[GMS] >= InputSDDPData.Min_QP[GMS]) # This is minimum fish discharge.
  @JuMP.constraint(m, QP_NOW[STC] >= InputSDDPData.Min_QP[STC]) # This is minimum fish discharge.
  @JuMP.constraint(m, QP_NOW[MCA] >= InputSDDPData.Min_QP[MCA]) # This is minimum fish discharge.
  @JuMP.constraint(m, QP_NOW[ARD] >= InputSDDPData.Min_QP[ARD]) # This is minimum fish discharge.
  ### STATE_EQUATIONS ###
  # if sv = > t-1 then now = > end of period t (this case)
  # if sv = > t+1 then now = > start of period t
  # GMS
  j = 1
  JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.unit_Availability_GMS[t5] * InputSDDPData.Max_QT_per_unit[j])
  JuMP.@constraint(m, sum(P_NOW[j, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock) <= InputSDDPData.unit_Availability_GMS[t5] * InputSDDPData.Max_P_per_unit[j])

  # PCN
  j = 2
  JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.unit_Availability_PCN[t5] * InputSDDPData.Max_QT_per_unit[j])
  JuMP.@constraint(m, sum(P_NOW[j, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock) <= InputSDDPData.unit_Availability_PCN[t5] * InputSDDPData.Max_P_per_unit[j])

  # STC
  j = 3
  JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.Max_QT[j])

  # MCA
  j = 4
  JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.unit_Availability_MCA[t5] * InputSDDPData.Max_QT_per_unit[j])
  JuMP.@constraint(m, sum(P_NOW[j, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock) <= InputSDDPData.unit_Availability_MCA[t5] * InputSDDPData.Max_P_per_unit[j])

  # REV
  j = 5
  JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.unit_Availability_REV[t5] * InputSDDPData.Max_QT_per_unit[j])
  JuMP.@constraint(m, sum(P_NOW[j, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock) <= InputSDDPData.unit_Availability_REV[t5] * InputSDDPData.Max_P_per_unit[j])

  # ARD
  j = 6
  JuMP.@constraint(m, sum(P_NOW[j, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock) <= InputSDDPData.unit_Availability_ARD[t5] * InputSDDPData.Max_P_per_unit[j])


  JuMP.@constraint(m, Q_NT_BC_NOW >= InputSDDPData.Q_NT_min_BC[tp])
  JuMP.@constraint(m, Q_NT_BC_NOW <= InputSDDPData.Q_NT_max_BC[tp])
  JuMP.@constraint(m, Q_NT_US_NOW >= 0)
  JuMP.@constraint(m, Q_NT_US_NOW <= 0)
  for i = 1:numTimeBlock
    ### PLANT_MAX_GENERATION_now ###
    for j = 1:numPlant
      JuMP.@constraint(m, P_NOW[j, i] <= InputSDDPData.Max_P[j])
    end

      JuMP.@constraint(m, sum(P_NOW[j, i] for j = 1:numPlant) - SPOT_EXP_USH_NOW[i] + SPOT_IMP_USH_NOW[i] + DEFICITIMP[i] - SURPLUSEXP[i] == InputSDDPData.load[i][t5,dynamic_var.select])
      # JuMP.@constraint(m, sum(P_NOW[j, i] for j = 1:numPlant) - SPOT_EXP_USH_NOW[i] + SPOT_IMP_USH_NOW[i] + DEFICITIMP[i] - SURPLUSEXP[i] == load2020[tp,i])

      @JuMP.constraint(m, SPOT_IMP_USH_NOW[i] <= -InputSDDPData.US_tran_minH[tp,i])
      
      @JuMP.constraint(m, InputSDDPData.US_tran_maxH[tp,i] >= SPOT_EXP_USH_NOW[i])

      


  end
  
  # ### PLANT_DISCHARGE_now ###
  for j = 1:numPlant
    JuMP.@constraint(m, V_LIVE[j] == V_NOW[j] - InputSDDPData.reservoir_constraintMin_storage[j])
    JuMP.@constraint(m, QT_NOW[j] + QS_NOW[j] == QP_NOW[j])
    JuMP.@constraint(m, V_NOW[j] >= InputSDDPData.reservoir_constraintMin_storage[j])
    JuMP.@constraint(m, V_NOW[j] <= InputSDDPData.reservoir_constraintMax_storage[j])
    JuMP.@constraint(m, QT_NOW[j] <= InputSDDPData.Max_QT[j])
    JuMP.@constraint(m, QT_NOW[j] >= InputSDDPData.Min_QT[j])
    JuMP.@constraint(m, QS_NOW[j] <= InputSDDPData.Max_QS[j])
    JuMP.@constraint(m, QS_NOW[j] >= InputSDDPData.Min_QS[j])
    JuMP.@constraint(m, V_AVE[j] == 0.5 * (V_NOW[j] + V_SV[j]))

    for i = 1:numTimeBlock
      JuMP.@constraint(m, P_NOW[j, i] == QT_NOW[j] * InputSDDPData.HK[tp, j]*1.0)
      # JuMP.@constraint(m, P_NOW[j, i] >= 0)
    end

  end


  # ### V_NT_BC_limit ###
  JuMP.@constraint(m, V_NT_BC_NOW <= InputSDDPData.V_NT_max_BC[tpPlus1]) 
  JuMP.@constraint(m, InputSDDPData.V_NT_min_BC[tpPlus1] <= V_NT_BC_NOW)

  # ### V_NT_US_limit ###
  JuMP.@constraint(m, V_NT_US_NOW <= InputSDDPData.V_NT_max_BC[tpPlus1])
  JuMP.@constraint(m, InputSDDPData.V_NT_min_BC[tpPlus1] <= V_NT_US_NOW)

  for k = 1:max(1,cut_n)
    JuMP.@constraint(m, WATER_VALUE <= (max(0,Output.cut_intercept[k, t]) +
    Output.cut_slope_GMS[k, t] * V_LIVE[GMS] +
    Output.cut_slope_MCA[k, t] * V_LIVE[MCA] +
    Output.cut_slope_ARW[k, t] * V_LIVE[ARD] +
    Output.cut_slope_Treaty_MCA[k, t] * (V_TY_MCA_NOW) +
    Output.cut_slope_Treaty_ARW[k, t] * (V_TY_ARD_NOW) +
    Output.cut_slope_NonTreaty_CA[k, t] * (V_NT_BC_NOW - InputSDDPData.V_NT_min_BC[tpPlus1]) +
    Output.cut_slope_NonTreaty_US[k, t] * (V_NT_US_NOW - InputSDDPData.V_NT_min_BC[tpPlus1]) 
      )
    )
  end



  return m, state_variable_GMS, state_variable_MCA, state_variable_ARD, state_variable_NT_BC, state_variable_NT_US, state_variable_TY_MCA, state_variable_TY_ARD
end
