mutable struct SDDP_Data
  GMS::Int
  PCN::Int
  STC::Int
  MCA::Int
  REV::Int
  ARD::Int
  numDayCalendar::Any
  numDayDecember::Any
  monthLabel::Any
  histYear::Any
  wheeling_price::Any
  wheeling_rate::Any
  reservoir_constraintMin_storage::Any
  reservoir_constraintMax_storage::Any
  Min_QT::Any
  Max_QT::Any
  Min_QS::Any
  Max_QS::Any
  Min_QP::Any
  Max_P::Any
  Max_QT_per_unit::Any
  Max_P_per_unit::Any
  HK::Any
  HPLHR::Any
  V_SOA_P::Any
  V_TY_max_MCA::Any
  V_TY_min_MCA::Any
  V_TY_max_ARD::Any
  V_TY_min_ARD::Any
  V_NT_max_BC::Any
  V_NT_min_BC::Any
  Q_NT_min_BC::Any
  Q_NT_max_BC::Any
  Q_LCA_min::Any
  Q_LCA_max::Any
  unit_Availability_GMS::Any
  unit_Availability_MCA::Any 
  unit_Availability_REV::Any  
  unit_Availability_PCN::Any  
  unit_Availability_ARD::Any  
  load::Any
  price::Any
  US_tran_minH::Any
  US_tran_maxH::Any
  # HKUSFED = [60] #kcfs
  HKUSFED::Any 
end

InputSDDPData = SDDP_Data(
  1,
  2,
  3,
  4,
  5,
  6,
  [31 28 31 30 31 30 31 31 30 31 30 31], # numDayCalendar
  [31 31 28 31 30 31 30 31 31 30 31 30], # numDayDecember
  ["DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV"], # monthLabel
  [1972:1:2020;], # histYear
  7.0, # wheeling_price
  0.019, # wheeling_rate
  [16160, 0, 0, 10655, 0, 0] * 1000000 / (60 * 60 * 24), # reservoir_constraintMin_storage cms-day
  [41288, 0, 0, 24770, 0, 8973] * 1000000 / (60 * 60 * 24), # reservoir_constraintMax_storage cms-day
  [0, 0, 0, 0, 0, 0], # Min_QT cms
  [1968, 1982, 0, 1840, 2125, 1115], # Max_QT cms
  [0 0 0 0 0 0], # Min_QS cms
  [8660.0, 8108.0, 18108.0, 4117.0, 5144.0, 18000.0], # Max_QS cms
  [100 283 0 8 141 141], # Min_QP cms
  [2850, 700, 0, 2700, 2525, 185], # Max_P mw
  [203, 508, 0, 340, 425, 558], # Max_QT_per_unit cms
  [295, 175, 0, 450, 505, 93], # Max_P_per_unit mw
  [ #GMS   PCN   STC  MCA   REV   ARD 
    1.464 0.343 0 0.549 1.185 0.074
    1.447 0.346 0 0.467 1.183 0.080
    1.420 0.343 0 0.405 1.191 0.073
    1.414 0.351 0 0.356 1.188 0.053
    1.397 0.347 0 0.334 1.170 0.067
    1.421 0.353 0 0.375 1.186 0.091
    1.468 0.352 0 0.466 1.192 0.131
    1.503 0.351 0 0.562 1.187 0.140
    1.518 0.352 0 0.606 1.184 0.130
    1.506 0.345 0 0.609 1.190 0.141
    1.502 0.348 0 0.604 1.185 0.134
    1.484 0.344 0 0.595 1.188 0.103
  ], # HK
  [2 6 8 6 2], # HPLHR
  #Dec	  Jan	  Feb	  Mar	  Apr	  May	  Jun	  Jul	  Aug	  Sep	  Oct	  Nov
  [0 10893 12033 12033 12324 10477 8625 0 0 0 0 0], # V_SOA_P
  [128570.0 117677.0 116537.0 116537.0 116246.0 118093.0 119945.0 128570.0 128570.0 128570.0 128570.0 128570.0], # V_TY_max_MCA
  [-36703 -36703 -36703 -36703 -36703 -36703 -36703 -36703 -36703 -36703 -36703 -36703], # V_TY_min_MCA
  [101363 101363 101363 101306 101363 101363 101363 101363 101363 101363 99970 101363], # V_TY_max_ARD
  [0 0 0 0 0 0 0 0 0 0 0 0], # V_TY_min_ARD
  [32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92 32121.92], # V_NT_max_BC
  [10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31 10707.31], # V_NT_min_BC
  [-205.53 -140.58 -4.94 -3.22 -33.73 -0.18 -5.74 0.0 -234.67 -149.92 -91.67 -210.03], # Q_NT_min_BC index by calendar month
  [59.97 173.24 283.17 2.06 0.0 0.0 179.02 205.91 279.27 283.17 237.22 132.92], # Q_NT_max_BC index by calendar month
  [0 -89 -78 -160 0 0 0 0 0 -130 -115 -79], # Q_LCA_min
  [0 89 78 51 0 0 0 118 132 101 38 79], # Q_LCA_max
  [9.387 9.29 8.571 8.935 8.733 7.871 8.5 8.839 8.613 9 8.839 9.2 9.613 10 10 9.613 9.067 8.677 8.9 9 9.484 8.933 9 9.367 9.968 10 9.483 9 8.467 7.452 7.533 8.548 8.452 8 8.548 9.533 10 10 9.5 9 8.467 7.452 7.533 8.548 8.452 8 8.548 9.533 10 10 9.5 9 8.467 7.452 7.533 8.548 8.452 8 8.548 9.533], # unit_Availability_GMS
  [4.903 5.581 5.571 5.419 4 4 4.433 5 5 3.967 4.226 4.267 6 6 5.214 5 4 4 4.667 5 5 5 4.194 5.5 6 6 5.207 5 4 4 4.667 5 5 5 4.194 5.5 6 6 5.214 5 4 4 4.667 5 5 5 4.194 5.5 6 6 5.214 5 4 4 4.667 5 5 5 4.194 5.5], # unit_Availability_MCA
  [4.581 4.871 5 4.839 4 4.161 4.133 4.516 5 4 4 4.167 4.935 5 5 4.355 3.867 4 4.067 5 5 3.733 3.935 5 5 5 5 4.452 4 4 4 4.677 5 4.4 4.419 5 5 5 5 4.452 4 4 4 4.677 5 4.4 4.419 5 5 5 5 4.452 4 4 4 4.677 5 4.4 4.419 5], # unit_Availability_REV
  [3.935 4 4 4 3.6 2.774 2.533 3.742 4 4 3.355 4 4 4 4 4 3.3 2.226 2.933 4 4 4 3.355 4 4 4 4 2.742 2 2 2 3.226 4 3.967 3.387 4 4 4 4 4 3.467 2.226 2.733 4 4 4 3.258 4 4 4 4 4 3.467 2.226 2.733 4 4 4 3.258 4], # unit_Availability_PCN
  [2 2 2 1.032 1 1.968 2 2 2 2 2 2 2 2 2 1.032 1 1.968 2 2 2 2 2 2 2 2 2 1.032 1 1.968 2 2 2 2 2 2 2 2 2 1.032 1 1.968 2 2 2 2 2 2 2 2 2 1.032 1 1.968 2 2 2 2 2 2], # unit_Availability_ARD
  [],
  [],
  [
-1128.5  -1128.5  -1128.5  -1128.5  -1128.5
-1128.5  -1128.5  -1128.5  -1128.5  -1128.5
-1128.5  -1128.5  -1128.5  -1128.5  -1128.5
-1378.5  -1378.5  -1378.5  -1378.5  -1378.5
-1628.5  -1628.5  -1628.5  -1628.5  -1628.5
-1878.5  -1878.5  -1878.5  -1878.5  -1878.5
-1878.5  -1878.5  -1878.5  -1878.5  -1878.5
-1343.5  -1343.5  -1343.5  -1343.5  -1343.5
-1236.0  -1236.0  -1236.0  -1236.0  -1236.0
-1236.0  -1236.0  -1236.0  -1236.0  -1236.0
-1378.5  -1378.5  -1378.5  -1378.5  -1378.5
-1378.5  -1378.5  -1378.5  -1378.5  -1378.5],
[2699  2699  2699  2732  2732
2706  2706  2706  2754  2754
2676  2676  2676  2672  2672
2549  2549  2549  2619  2619
2558  2558  2558  2408  2408
2416  2416  2416  2085  2085
2399  2399  2399  2024  2024
2621  2621  2621  2238  2238
2852  2852  2852  2412  2412
2699  2699  2699  2311  2311
2770  2770  2770  2484  2484
2631  2631  2631  2578  2578],
60 * (0.3048^3)
)
mutable struct SystemData
  Peace_river_inflow_fcst::Any
  Columbia_river_inflow_fcst::Any
  WSR_reservoir_inflow_fcst::Any
  PCN_reservoir_inflow_fcst::Any
  STC_reservoir_inflow_fcst::Any
  KBT_reservoir_inflow_fcst::Any
  REV_reservoir_inflow_fcst::Any
  ARW_reservoir_inflow_fcst::Any
  q_river_ac_peace::Any
  q_river_ac_columbia::Any
  WSR_daily_reservoir_inflow_hist::Any
  PCN_daily_reservoir_inflow_hist::Any
  STC_daily_reservoir_inflow_hist::Any
  KBT_daily_reservoir_inflow_hist::Any
  REV_daily_reservoir_inflow_hist::Any
  ARW_daily_reservoir_inflow_hist::Any
  q_reservoir_monthly_GMS::Any
  q_reservoir_monthly_PCN::Any
  q_reservoir_monthly_STC::Any
  q_reservoir_monthly_MCA::Any
  q_reservoir_monthly_REV::Any
  q_reservoir_monthly_ARD::Any
  total_treaty_strorage::Any
  se_ac_peace::Any
  min_se_ac_peace::Any
  max_se_ac_peace::Any
  se_ac_columbia::Any
  min_se_ac_columbia::Any
  max_se_ac_columbia::Any
  se_fc_peace::Any
  se_fc_columbia::Any
  sa_TD::Any
  histYear::Any
  prob_peace::Any
  prob_columbia::Any
  se_ac_columbia_intercept::Any
  se_ac_columbia_slope::Any
  se_ac_columbia_std::Any
  normalized_residual_columbia::Any
  se_ac_peace_intercept::Any
  se_ac_peace_slope::Any
  se_ac_peace_std::Any
  normalized_residual_peace::Any
  eigvalue::Any
  eigvector::Any
  multiplier_peace::Any
  multiplier_columbia::Any
end

InputData = SystemData(
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
  zeros(Float64, numStage),
)

mutable struct DifferentialEvolutionParameter
  maxit::Any
  beta_min::Any
  beta_max::Any
  pcr::Any
  npop::Any
  nvar::Any
  varmin::Any
  varmax::Any
  position::Any
  cost::Any
  bestcost::Any
  bestpos::Any
end

DeParam = DifferentialEvolutionParameter(zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1), zeros(Float64, 1))

# TODO Take our state_variable and NOW and value. WHat does cand stand for?
mutable struct SDDP_Variables
  cut_slope_GMS::Any
  cut_slope_MCA::Any
  cut_slope_ARW::Any
  cut_slope_NonTreaty_CA::Any
  cut_slope_NonTreaty_US::Any
  cut_slope_Treaty_MCA::Any
  cut_slope_Treaty_ARW::Any
  cut_intercept::Any
  V_TTY_candidate::Any
  V_LCA_now_candidate::Any 
  V_TY_MCA_now_candidate::Any 
  V_TY_ARD_now_candidate::Any 
  V_NT_BC_now_candidate::Any 
  V_NT_US_now_candidate::Any 
  V_now_GMS_candidate::Any 
  V_now_PCN_candidate::Any
  V_now_STC_candidate::Any
  V_now_MCA_candidate::Any
  V_now_REV_candidate::Any
  V_now_ARD_candidate::Any
  V_MCA_FLEX_candidate::Any
  V_ARD_FLEX_candidate::Any
  V_SOM_candidate::Any
  H_value_GMS::Any
  H_value_MCA::Any
  H_value_ARD::Any
  Q_river_peace::Any
  Q_river_columbia::Any
  Q_reservoir_NOW_GMS::Any
  Q_reservoir_NOW_PCN::Any
  Q_reservoir_NOW_STC::Any
  Q_reservoir_NOW_MCA::Any
  Q_reservoir_NOW_REV::Any
  Q_reservoir_NOW_ARD::Any
  se_fc_Peace::Any
  se_fc_Col::Any
  se_ac_Peace::Any
  se_ac_Col::Any
  sf_TD_value::Any
  sa_TD_value::Any
  V_sv_value_GMS::Any
  V_sv_value_MCA::Any
  V_sv_value_ARD::Any
  V_NOW_value_GMS::Any
  V_NOW_value_MCA::Any
  V_NOW_value_ARD::Any
  V_FLEX_value::Any
  QT_NOW_val_GMS::Any
  QT_NOW_val_PCN::Any
  QT_NOW_val_STC::Any
  QT_NOW_val_MCA::Any
  QT_NOW_val_REV::Any
  QT_NOW_val_ARD::Any
  QS_NOW_val_GMS::Any
  QS_NOW_val_PCN::Any
  QS_NOW_val_STC::Any
  QS_NOW_val_MCA::Any
  QS_NOW_val_REV::Any
  QS_NOW_val_ARD::Any
  P_NOW_val_GMS::Any
  P_NOW_val_PCN::Any
  P_NOW_val_STC::Any
  P_NOW_val_MCA::Any
  P_NOW_val_REV::Any
  P_NOW_val_ARD::Any
  QP_NOW_val_GMS::Any
  QP_NOW_val_PCN::Any
  QP_NOW_val_STC::Any
  QP_NOW_val_MCA::Any
  QP_NOW_val_REV::Any
  QP_NOW_val_ARD::Any
  Spot_Exp_USH_NOW_value::Any
  Spot_Imp_USH_NOW_value::Any
  Spot_Exp_ABH_NOW_value::Any
  V_TY_MCA_NOW_value::Any
  V_TY_MCA_sv_value::Any
  V_TY_ARD_NOW_value::Any
  V_NT_BC_NOW_value::Any
  V_NT_BC_sv_value::Any
  Q_NT_BC_NOW_value::Any
  Q_NT_US_NOW_value::Any
  Q_TY_MCA_NOW_value::Any
  V_TY_Total_SV_value::Any
  V_TY_Total_now_value::Any
  V_TY_sys_value::Any
  Q_TY_ARD_NOW_value::Any
  Q_FLEX_value::Any
  Q_SOA_value::Any
  Q_LCA_value::Any
  V_LCA_value::Any
  WATER_VALUE_value::Any
  H_val::Any
  fvalue::Any 
  V_IMBALANCE_ARD_NOW_value::Any
  V_FLEX_MCA_value::Any
  V_FLEX_ARD_value::Any
  Q_IMBALANCE_ARD_value::Any
  Q_FLEX_MCA_value::Any
  s1_value::Any
  s2_value::Any
  SURPLUSEXP_val::Any
  DEFICITIMP_val::Any
  V_NT_US_NOW_value::Any
  V_sv_MCA_candidate::Any
end

Output = SDDP_Variables(
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  0.01*ones(numIteration, numStage),
  zeros(numIteration, numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numIteration,numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage),
  zeros(numSimulation, numStage)

)

Output.cut_slope_GMS[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_MCA[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_ARW[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_NonTreaty_CA[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_NonTreaty_US[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_Treaty_MCA[1,:] = 10^8 * ones(1,numStage)
Output.cut_slope_Treaty_ARW[1,:] = 10^8 * ones(1,numStage)



mutable struct CSV_INPUTS
  ard_inflow::Any 
  rev_inflow::Any 
  mca_inflow::Any 
  gms_inflow::Any 
  pcn_inflow::Any 
  stc_inflow::Any 
  total_treaty_storage::Any  
  mca_sv_min::Any  
  ScenarioTMCDF::Any  
  ScenarioTM::Any
end
csv_inputs = CSV_INPUTS(
  CSV.read("In/ARDIN.csv", DataFrame),
  CSV.read("In/REVIN.csv", DataFrame),
  CSV.read("In/MCAIN.csv", DataFrame),
  CSV.read("In/GMSIN.csv", DataFrame),
  CSV.read("In/PCNIN.csv", DataFrame),
  CSV.read("In/STCIN.csv", DataFrame),
  CSV.read("In/TTYST.csv", DataFrame),
  CSV.read("In/V_MCA_SV_MIN.csv", DataFrame),
  CSV.read("In/ScenarioTMCDF.csv", DataFrame),
  CSV.read("In/ScenarioTM.csv", DataFrame)
)


csv_inputs.ScenarioTMCDF = csv_inputs.ScenarioTMCDF[:,4:end]
csv_inputs.ScenarioTM = csv_inputs.ScenarioTM[:,4:end]
mutable struct DYNMAIC_VAR
  V_TY_Total_now::Any 
  GMS_Inflow::Any 
  PCN_Inflow::Any 
  STC_Inflow::Any 
  MCA_Inflow::Any 
  REV_Inflow::Any 
  ARD_Inflow::Any  
  select::Any  
end
dynamic_var = DYNMAIC_VAR(
  [],
  [],
  [],
  [],
  [],
  [],
  [],
  []
)