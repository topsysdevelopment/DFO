monthLabel = ["DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV"]
global HEADER = repeat(monthLabel, numForecastYear)

CSV.write("Output/ELEV_GMS.csv", Tables.table(Output.H_value_GMS), writeheader = true, header = HEADER)
CSV.write("Output/ELEV_MCA.csv", Tables.table(Output.H_value_MCA), writeheader = true, header = HEADER)
CSV.write("Output/ELEV_ARD.csv", Tables.table(Output.H_value_ARD), writeheader = true, header = HEADER)

# CSV.write("Output/Q_FLEX.csv", Tables.table(Q_FLEX_value), writeheader = true, header = HEADER)
# CSV.write("Output/V_FLEX.csv", Tables.table(V_FLEX_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_SOA.csv", Tables.table(Output.Q_SOA_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_LCA.csv", Tables.table(Output.Q_LCA_value), writeheader = true, header = HEADER)
CSV.write("Output/V_LCA.csv", Tables.table(Output.V_LCA_value), writeheader = true, header = HEADER)
CSV.write("Output/WaterValue.csv", Tables.table(Output.WATER_VALUE_value), writeheader = true, header = HEADER)

CSV.write("Output/Q_TY_MCA_NOW.csv", Tables.table(Output.Q_TY_MCA_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_TY_ARD_NOW.csv", Tables.table(Output.Q_TY_ARD_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_NT_BC_NOW.csv",  Tables.table(Output.Q_NT_BC_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_NT_US_NOW.csv",  Tables.table(Output.Q_NT_US_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_SOA.csv",  Tables.table(Output.Q_SOA_value), writeheader = true, header = HEADER)
# CSV.write("Output/Q_IMBALANCE_ARD.csv",  Tables.table(Q_IMBALANCE_ARD_value), writeheader = true, header = HEADER)
CSV.write("Output/Q_FLEX_MCA.csv",  Tables.table(Output.Q_FLEX_MCA_value), writeheader = true, header = HEADER)

CSV.write("Output/V_TY_MCA_NOW.csv",  Tables.table(Output.V_TY_MCA_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/V_TY_ARD_NOW.csv",  Tables.table(Output.V_TY_ARD_NOW_value), writeheader = true, header = HEADER)   
CSV.write("Output/V_NT_BC_NOW.csv",  Tables.table(Output.V_NT_BC_NOW_value), writeheader = true, header = HEADER)   
CSV.write("Output/V_NT_US_NOW.csv",  Tables.table(Output.V_NT_US_NOW_value), writeheader = true, header = HEADER)  

# CSV.write("Output/V_IMBALANCE_ARD_NOW_value.csv",  Tables.table(V_IMBALANCE_ARD_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/V_FLEX_MCA_value.csv",  Tables.table(Output.V_FLEX_MCA_value), writeheader = true, header = HEADER)   
CSV.write("Output/V_FLEX_ARD_value.csv",  Tables.table(Output.V_FLEX_ARD_value), writeheader = true, header = HEADER)   

CSV.write("Output/Q_reservoir_NOW_GMS.csv", Tables.table(Output.Q_reservoir_NOW_GMS), writeheader = true, header = HEADER)
CSV.write("Output/Q_reservoir_NOW_PCN.csv", Tables.table(Output.Q_reservoir_NOW_PCN), writeheader = true, header = HEADER)
CSV.write("Output/Q_reservoir_NOW_STC.csv", Tables.table(Output.Q_reservoir_NOW_STC), writeheader = true, header = HEADER)
CSV.write("Output/Q_reservoir_NOW_MCA.csv", Tables.table(Output.Q_reservoir_NOW_MCA), writeheader = true, header = HEADER)
CSV.write("Output/Q_reservoir_NOW_REV.csv", Tables.table(Output.Q_reservoir_NOW_REV), writeheader = true, header = HEADER)
CSV.write("Output/Q_reservoir_NOW_ARD.csv", Tables.table(Output.Q_reservoir_NOW_ARD), writeheader = true, header = HEADER)

CSV.write("Output/V_NOW_value_GMS.csv", Tables.table(Output.V_NOW_value_GMS), writeheader = true, header = HEADER)
CSV.write("Output/V_NOW_value_MCA.csv", Tables.table(Output.V_NOW_value_MCA), writeheader = true, header = HEADER)
CSV.write("Output/V_NOW_value_ARD.csv", Tables.table(Output.V_NOW_value_ARD), writeheader = true, header = HEADER)

CSV.write("Output/QT_NOW_val_GMS.csv", Tables.table(Output.QT_NOW_val_GMS), writeheader = true, header = HEADER)
CSV.write("Output/QT_NOW_val_PCN.csv", Tables.table(Output.QT_NOW_val_PCN), writeheader = true, header = HEADER)
CSV.write("Output/QT_NOW_val_STC.csv", Tables.table(Output.QT_NOW_val_STC), writeheader = true, header = HEADER)
CSV.write("Output/QT_NOW_val_MCA.csv", Tables.table(Output.QT_NOW_val_MCA), writeheader = true, header = HEADER)
CSV.write("Output/QT_NOW_val_REV.csv", Tables.table(Output.QT_NOW_val_REV), writeheader = true, header = HEADER)
CSV.write("Output/QT_NOW_val_ARD.csv", Tables.table(Output.QT_NOW_val_ARD), writeheader = true, header = HEADER)

CSV.write("Output/QS_NOW_val_GMS.csv", Tables.table(Output.QS_NOW_val_GMS), writeheader = true, header = HEADER)
CSV.write("Output/QS_NOW_val_PCN.csv", Tables.table(Output.QS_NOW_val_PCN), writeheader = true, header = HEADER)
CSV.write("Output/QS_NOW_val_STC.csv", Tables.table(Output.QS_NOW_val_STC), writeheader = true, header = HEADER)
CSV.write("Output/QS_NOW_val_MCA.csv", Tables.table(Output.QS_NOW_val_MCA), writeheader = true, header = HEADER)
CSV.write("Output/QS_NOW_val_REV.csv", Tables.table(Output.QS_NOW_val_REV), writeheader = true, header = HEADER)
CSV.write("Output/QS_NOW_val_ARD.csv", Tables.table(Output.QS_NOW_val_ARD), writeheader = true, header = HEADER)

CSV.write("Output/QP_NOW_val_GMS.csv", Tables.table(Output.QP_NOW_val_GMS), writeheader = true, header = HEADER)
CSV.write("Output/QP_NOW_val_PCN.csv", Tables.table(Output.QP_NOW_val_PCN), writeheader = true, header = HEADER)
CSV.write("Output/QP_NOW_val_STC.csv", Tables.table(Output.QP_NOW_val_STC), writeheader = true, header = HEADER)
CSV.write("Output/QP_NOW_val_MCA.csv", Tables.table(Output.QP_NOW_val_MCA), writeheader = true, header = HEADER)
CSV.write("Output/QP_NOW_val_REV.csv", Tables.table(Output.QP_NOW_val_REV), writeheader = true, header = HEADER)
CSV.write("Output/QP_NOW_val_ARD.csv", Tables.table(Output.QP_NOW_val_ARD), writeheader = true, header = HEADER)


CSV.write("Output/P_NOW_val_GMS.csv", Tables.table(Output.P_NOW_val_GMS), writeheader = true, header = HEADER)
CSV.write("Output/P_NOW_val_PCN.csv", Tables.table(Output.P_NOW_val_PCN), writeheader = true, header = HEADER)
CSV.write("Output/P_NOW_val_STC.csv", Tables.table(Output.P_NOW_val_STC), writeheader = true, header = HEADER)
CSV.write("Output/P_NOW_val_MCA.csv", Tables.table(Output.P_NOW_val_MCA), writeheader = true, header = HEADER)
CSV.write("Output/P_NOW_val_REV.csv", Tables.table(Output.P_NOW_val_REV), writeheader = true, header = HEADER)
CSV.write("Output/P_NOW_val_ARD.csv", Tables.table(Output.P_NOW_val_ARD), writeheader = true, header = HEADER)

# CSV.write("Output/V_TY_MCA_NOW_value.csv", Tables.table(V_TY_MCA_NOW_value), writeheader = true, header = HEADER)
# CSV.write("Output/V_TY_ARD_NOW_value.csv", Tables.table(V_TY_ARD_NOW_value), writeheader = true, header = HEADER)
# CSV.write("Output/V_NT_BC_NOW_value.csv", Tables.table(V_NT_BC_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/V_TY_Total_now_value.csv", Tables.table(Output.V_TY_Total_now_value), writeheader = true, header = HEADER)

# CSV.write("Output/Q_NT_BC_NOW_value.csv", Tables.table(Q_NT_BC_NOW_value), writeheader = true, header = HEADER)
# CSV.write("Output/Q_NT_US_NOW_value.csv", Tables.table(Q_NT_US_NOW_value), writeheader = true, header = HEADER)

CSV.write("Output/SPOT_EXP_USH_NOW.csv", Tables.table(Output.Spot_Exp_USH_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/SPOT_IMP_USH_NOW.csv", Tables.table(Output.Spot_Imp_USH_NOW_value), writeheader = true, header = HEADER)
CSV.write("Output/s1_value.csv",  Tables.table(Output.s1_value), writeheader = true, header = HEADER)   
CSV.write("Output/s2_value.csv",  Tables.table(Output.s2_value), writeheader = true, header = HEADER)  

CSV.write("Output/V_IMBALANCE.csv",  Tables.table(Output.V_IMBALANCE_ARD_NOW_value), writeheader = true, header = HEADER)  
CSV.write("Output/Q_IMBALANCE_ARD.csv",  Tables.table(Output.Q_IMBALANCE_ARD_value), writeheader = true, header = HEADER)  


CSV.write("Output/SURPLUSEXP.csv",  Tables.table(Output.SURPLUSEXP_val), writeheader = true, header = HEADER)
CSV.write("Output/DEFICITIMP.csv",  Tables.table(Output.DEFICITIMP_val), writeheader = true, header = HEADER)

if sim == 0
CSV.write("Output/Intercept.csv",  Tables.table(Output.cut_intercept), writeheader = true, header = HEADER)   
CSV.write("Output/SlopeGMS.csv",  Tables.table(Output.cut_slope_GMS), writeheader = true, header = HEADER)   
CSV.write("Output/SlopeMCA.csv",  Tables.table(Output.cut_slope_MCA), writeheader = true, header = HEADER)  
CSV.write("Output/SlopeARD.csv",  Tables.table(Output.cut_slope_ARW), writeheader = true, header = HEADER) 
CSV.write("Output/SlopeNTBC.csv",  Tables.table(Output.cut_slope_NonTreaty_CA), writeheader = true, header = HEADER) 
CSV.write("Output/SlopeNTUS.csv",  Tables.table(Output.cut_slope_NonTreaty_US), writeheader = true, header = HEADER) 
CSV.write("Output/SlopeTYMCA.csv",  Tables.table(Output.cut_slope_Treaty_MCA), writeheader = true, header = HEADER) 
CSV.write("Output/SlopeTYARD.csv",  Tables.table(Output.cut_slope_Treaty_ARW), writeheader = true, header = HEADER) 
end
