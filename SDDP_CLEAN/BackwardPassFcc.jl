function BackwardPassFcc(t, wxYr, numSimulation,fccblock,V_sv_MCA_candidate)

  GMS = InputSDDPData.GMS
  PCN = InputSDDPData.PCN
  STC = InputSDDPData.STC
  MCA = InputSDDPData.MCA
  REV = InputSDDPData.REV
  ARD = InputSDDPData.ARD
  tpPlus1 = t+1
  for i = 1:numForecastYear
    if tpPlus1 > 12
      tpPlus1 = tpPlus1 - 12
    end
  end

  t5 = t
  if t5 > 5 * 12
    t5 = t5 - 5 * 12
  end

  ij = 0
  V_sv_MCA_candidate[wxYr,t] = 0
  for i = 1:numSimulation
    ij = ij + 1
    selectedrow = csv_inputs.ScenarioTM[(t5-1)*numSimulation + wxYr,:]

    if selectedrow[i] > 0.0
      select = i
      REV_Inflow = csv_inputs.rev_inflow[select, t5]
      MCA_Inflow = csv_inputs.mca_inflow[select, t5]
      # for the start of month, the state varibles are V_TY_MCA_SV, V_TY_ARD_SV should be determined based on the year (not random).
      # V_TY_Total_now = V_TTY_candidate[t] # based on year changes as inflow changes
      if t5<numStage5
        V_TY_Total_now = csv_inputs.total_treaty_storage[select, t5+1]
        V_TY_ARD_NOW = fccblock[select,t5+1]
        V_TY_MCA_NOW = max(0, V_TY_Total_now - V_TY_ARD_NOW)
        V_MCA_NOW_MIN = V_sv_MCA_candidate[i,t5+1]
        V_MCA_NOW_MIN_PRIME = V_TY_MCA_NOW + InputSDDPData.V_NT_min_BC[tpPlus1] + InputSDDPData.V_NT_min_BC[tpPlus1] + InputSDDPData.reservoir_constraintMin_storage[MCA] + InputSDDPData.V_SOA_P[tpPlus1]
        Q_MIN_MCA = max(InputSDDPData.Min_QP[MCA],InputSDDPData.Min_QP[REV] - REV_Inflow)
        V_MCA_SV_MIN = max(V_MCA_NOW_MIN_PRIME,V_MCA_NOW_MIN) - (MCA_Inflow - Q_MIN_MCA)*InputSDDPData.numDayCalendar[tpPlus1]
        V_sv_MCA_candidate[wxYr,t5] = max(V_MCA_SV_MIN,V_sv_MCA_candidate[wxYr,t5])
      else
        V_sv_MCA_candidate[wxYr,t5] = 0

      end
    end
  end
  return V_sv_MCA_candidate
end


  