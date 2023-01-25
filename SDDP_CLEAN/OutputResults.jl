function OutputResults(sim_number, t, m, Output, dynamic_var)
  tp = t
  for i = 1:numForecastYear
    if tp > 12
      tp = tp - 12
    end
  end
  # fval = getobjectivevalue(m)
  fval = objective_value(m)
  Output.fvalue[sim_number] = fval

  ELEV = m[:ELEV]
  H_val = JuMP.value.(ELEV)

  Output.H_value_GMS[sim_number, t] = H_val[1]
  Output.H_value_MCA[sim_number, t] = H_val[4]
  Output.H_value_ARD[sim_number, t] = H_val[6]

  V_SV = m[:V_SV]
  V_SV_val = JuMP.value.(V_SV)
  Output.V_NOW_value_GMS[sim_number, t] = V_SV_val[1]
  Output.V_NOW_value_MCA[sim_number, t] = V_SV_val[4]
  Output.V_NOW_value_ARD[sim_number, t] = V_SV_val[6]

  Q_SOA = m[:Q_SOA]
  Q_SOA_val = JuMP.value.(Q_SOA)
  Output.Q_SOA_value[sim_number, t] = Q_SOA_val

  Q_LCA = m[:Q_LCA]
  Q_LCA_val = JuMP.value.(Q_LCA)
  Output.Q_LCA_value[sim_number, t] = Q_LCA_val

  V_LCA_NOW = m[:V_LCA_NOW]
  V_LCA_val = JuMP.value.(V_LCA_NOW)
  Output.V_LCA_value[sim_number, t] = V_LCA_val


  WATER_VALUE = m[:WATER_VALUE]
  WATER_VALUE_val = JuMP.value.(WATER_VALUE)
  Output.WATER_VALUE_value[sim_number, t] = WATER_VALUE_val

  QT_NOW = m[:QT_NOW]
  QT_NOW_val = JuMP.value.(QT_NOW)
  Output.QT_NOW_val_GMS[sim_number, t] = QT_NOW_val[1]
  Output.QT_NOW_val_PCN[sim_number, t] = QT_NOW_val[2]
  Output.QT_NOW_val_STC[sim_number, t] = QT_NOW_val[3]
  Output.QT_NOW_val_MCA[sim_number, t] = QT_NOW_val[4]
  Output.QT_NOW_val_REV[sim_number, t] = QT_NOW_val[5]
  Output.QT_NOW_val_ARD[sim_number, t] = QT_NOW_val[6]

  QS_NOW = m[:QS_NOW]
  QS_NOW_val = JuMP.value.(QS_NOW)
  Output.QS_NOW_val_GMS[sim_number, t] = QS_NOW_val[1]
  Output.QS_NOW_val_PCN[sim_number, t] = QS_NOW_val[2]
  Output.QS_NOW_val_STC[sim_number, t] = QS_NOW_val[3]
  Output.QS_NOW_val_MCA[sim_number, t] = QS_NOW_val[4]
  Output.QS_NOW_val_REV[sim_number, t] = QS_NOW_val[5]
  Output.QS_NOW_val_ARD[sim_number, t] = QS_NOW_val[6]

  P_NOW = m[:P_NOW]
  P_NOW_val = JuMP.value.(P_NOW)
  Output.P_NOW_val_GMS[sim_number, t] = (sum(P_NOW_val[1, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000
  Output.P_NOW_val_PCN[sim_number, t] = (sum(P_NOW_val[2, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000
  Output.P_NOW_val_STC[sim_number, t] = (sum(P_NOW_val[3, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000
  Output.P_NOW_val_MCA[sim_number, t] = (sum(P_NOW_val[4, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000
  Output.P_NOW_val_REV[sim_number, t] = (sum(P_NOW_val[5, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000
  Output.P_NOW_val_ARD[sim_number, t] = (sum(P_NOW_val[6, i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000

  QP_NOW = m[:QP_NOW]
  QP_NOW_val = JuMP.value.(QP_NOW)
  Output.QP_NOW_val_GMS[sim_number, t] = QP_NOW_val[1]
  Output.QP_NOW_val_PCN[sim_number, t] = QP_NOW_val[2]
  Output.QP_NOW_val_STC[sim_number, t] = QP_NOW_val[3]
  Output.QP_NOW_val_MCA[sim_number, t] = QP_NOW_val[4]
  Output.QP_NOW_val_REV[sim_number, t] = QP_NOW_val[5]
  Output.QP_NOW_val_ARD[sim_number, t] = QP_NOW_val[6]


  V_TY_MCA_SV = m[:V_TY_MCA_SV]
  V_TY_MCA_NOW_val = JuMP.value.(V_TY_MCA_SV)
  Output.V_TY_MCA_NOW_value[sim_number, t] = V_TY_MCA_NOW_val


  V_TY_ARD_SV = m[:V_TY_ARD_SV]
  V_TY_ARD_NOW_val = JuMP.value.(V_TY_ARD_SV)
  Output.V_TY_ARD_NOW_value[sim_number, t] = V_TY_ARD_NOW_val

  V_FLEX_MCA_SV = m[:V_FLEX_MCA_SV]
  V_FLEX_MCA_NOW_val = JuMP.value.(V_FLEX_MCA_SV)
  Output.V_FLEX_MCA_value[sim_number, t] = V_FLEX_MCA_NOW_val
  
  V_FLEX_ARD_SV = m[:V_FLEX_ARD_SV]
  V_FLEX_ARD_NOW_val = JuMP.value.(V_FLEX_ARD_SV)
  Output.V_FLEX_ARD_value[sim_number, t] = V_FLEX_ARD_NOW_val


  Q_FLEX_MCA = m[:Q_FLEX_MCA]
  Q_FLEX_MCA_val = JuMP.value.(Q_FLEX_MCA)
  Output.Q_FLEX_MCA_value[sim_number, t] = Q_FLEX_MCA_val

  
  V_IMBALANCE_SV = m[:V_IMBALANCE_SV]
  V_IMBALANCE_val = JuMP.value.(V_IMBALANCE_SV)
  Output.V_IMBALANCE_ARD_NOW_value[sim_number, t] = V_IMBALANCE_val

  Q_IMBALANCE = m[:Q_IMBALANCE]
  Q_IMBALANCE_val = JuMP.value.(Q_IMBALANCE)
  Output.Q_IMBALANCE_ARD_value[sim_number, t] = Q_IMBALANCE_val
 

  V_NT_BC_SV = m[:V_NT_BC_SV]
  V_NT_BC_NOW_val = JuMP.value.(V_NT_BC_SV)
  Output.V_NT_BC_NOW_value[sim_number, t] = V_NT_BC_NOW_val

  V_NT_US_SV = m[:V_NT_US_SV]
  V_NT_US_NOW_val = JuMP.value.(V_NT_US_SV)
  Output.V_NT_US_NOW_value[sim_number, t] = V_NT_US_NOW_val


  Q_NT_BC_NOW = m[:Q_NT_BC_NOW]
  Q_NT_BC_NOW_val = JuMP.value.(Q_NT_BC_NOW)
  Output.Q_NT_BC_NOW_value[sim_number, t] = Q_NT_BC_NOW_val

  Q_TY_MCA_NOW = m[:Q_TY_MCA_NOW]
  Q_TY_MCA_NOW_val = JuMP.value.(Q_TY_MCA_NOW)
  Output.Q_TY_MCA_NOW_value[sim_number, t] = Q_TY_MCA_NOW_val

  Q_TY_ARD_NOW = m[:Q_TY_ARD_NOW]
  Q_TY_ARD_NOW_val = JuMP.value.(Q_TY_ARD_NOW)
  Output.Q_TY_ARD_NOW_value[sim_number, t] = Q_TY_ARD_NOW_val

  Q_NT_US_NOW = m[:Q_NT_US_NOW]
  Q_NT_US_NOW_val = JuMP.value.(Q_NT_US_NOW)
  Output.Q_NT_US_NOW_value[sim_number, t] = Q_NT_US_NOW_val

  V_TY_Total_now_val = V_TY_MCA_NOW_val + V_TY_ARD_NOW_val
  Output.V_TY_Total_now_value[sim_number, t] = V_TY_Total_now_val

  Output.Q_reservoir_NOW_GMS[sim_number, t] = dynamic_var.GMS_Inflow
  Output.Q_reservoir_NOW_PCN[sim_number, t] = dynamic_var.PCN_Inflow
  Output.Q_reservoir_NOW_STC[sim_number, t] = dynamic_var.STC_Inflow
  Output.Q_reservoir_NOW_MCA[sim_number, t] = dynamic_var.MCA_Inflow
  Output.Q_reservoir_NOW_REV[sim_number, t] = dynamic_var.REV_Inflow
  Output.Q_reservoir_NOW_ARD[sim_number, t] = dynamic_var.ARD_Inflow

  DEFICITIMP = m[:DEFICITIMP]
  SYS_DEFICIENCY_IMPORT_val = JuMP.value.(DEFICITIMP)
  Output.DEFICITIMP_val[sim_number, t]  = (sum(SYS_DEFICIENCY_IMPORT_val[i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000

  SURPLUSEXP = m[:SURPLUSEXP]
  SYS_SURPLUS_EXPORT_val = JuMP.value.(SURPLUSEXP)
  Output.SURPLUSEXP_val[sim_number, t]  = (sum(SYS_SURPLUS_EXPORT_val[i] * InputSDDPData.HPLHR[i] / 24 for i = 1:numTimeBlock)) * 24 * InputSDDPData.numDayCalendar[tp] / 1000

  SPOT_EXP_USH_NOW = m[:SPOT_EXP_USH_NOW]
  SPOT_EXP_USH_NOW_val = JuMP.value.(SPOT_EXP_USH_NOW)
  Output.Spot_Exp_USH_NOW_value[sim_number, t] = (sum(SPOT_EXP_USH_NOW_val[i] * InputSDDPData.HPLHR[i] for i = 1:numTimeBlock)) * InputSDDPData.numDayCalendar[tp] / 1000


  SPOT_IMP_USH_NOW = m[:SPOT_IMP_USH_NOW]
  SPOT_IMP_USH_NOW_val = JuMP.value.(SPOT_IMP_USH_NOW)
  Output.Spot_Imp_USH_NOW_value[sim_number, t] = (sum(SPOT_IMP_USH_NOW_val[i] * InputSDDPData.HPLHR[i] for i = 1:numTimeBlock)) * InputSDDPData.numDayCalendar[tp] / 1000



  s1 = m[:s1]
  s2 = m[:s2]
  Output.s1_value[sim_number, t] = JuMP.value.(s1)
  Output.s2_value[sim_number, t] = JuMP.value.(s2)
end
