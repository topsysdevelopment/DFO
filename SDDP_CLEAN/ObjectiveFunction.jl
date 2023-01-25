# objective function
function ObjectiveFunction(t, m, dynamic_var, InputSDDPData)
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
  WATER_VALUE = m[:WATER_VALUE]
  SPOT_EXP_USH_NOW = m[:SPOT_EXP_USH_NOW]
  SPOT_IMP_USH_NOW = m[:SPOT_IMP_USH_NOW]
  Q_NT_BC_NOW = m[:Q_NT_BC_NOW]
  Q_LCA = m[:Q_LCA]

  s1 = m[:s1]
  s2 = m[:s2]
  DEFICITIMP = m[:DEFICITIMP]
  SURPLUSEXP = m[:SURPLUSEXP]

  JuMP.@objective(m, Max, 0.9955 * WATER_VALUE - (1e6) * (s1 + s2) + 
    + sum((SPOT_EXP_USH_NOW[i]) * InputSDDPData.HPLHR[i] * max(0, InputSDDPData.price[i][t5, dynamic_var.select]*(1-InputSDDPData.wheeling_rate) - InputSDDPData.wheeling_price) * InputSDDPData.numDayCalendar[tp] for i = 1:numTimeBlock) 
    - sum((SPOT_IMP_USH_NOW[i]) * InputSDDPData.HPLHR[i] * max(0, InputSDDPData.wheeling_price + (1+InputSDDPData.wheeling_rate)*InputSDDPData.price[i][t5, dynamic_var.select]) * InputSDDPData.numDayCalendar[tp] for i = 1:numTimeBlock) 
    + sum(((Q_NT_BC_NOW + Q_LCA) * InputSDDPData.HKUSFED) * max(0, InputSDDPData.price[i][t5, dynamic_var.select]) * InputSDDPData.HPLHR[i] * InputSDDPData.numDayCalendar[tp] for i = 1:numTimeBlock) 
    - 1*sum( DEFICITIMP[i] * (max(25, InputSDDPData.price[i][t5, dynamic_var.select])+25) * InputSDDPData.HPLHR[i] * InputSDDPData.numDayCalendar[tp] for i = 1:numTimeBlock)
    - 1*sum( SURPLUSEXP[i] * (max(25, InputSDDPData.price[i][t5, dynamic_var.select])+25) * InputSDDPData.HPLHR[i] * InputSDDPData.numDayCalendar[tp] for i = 1:numTimeBlock)
  )

  return m
end
