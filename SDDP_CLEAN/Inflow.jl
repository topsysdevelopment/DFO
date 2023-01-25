# Copyright 2021, Naser Moosavian, Ph.D., University of British Columbia
# This Source Code Form is subject to the terms of the BC Hydro Co.
# A copy of the code is available at J Drive (***Put the address***).
#############################################################################
# Application of SDDP for the Optimization of Reservoir Operations 
# Source: Naser Moosavian
#############################################################################

function Sddp_sub_run(se_fc_rv_value, rv_value)

  global se_fc, se_ac, sf_TD, sa_TD, Q_river, Q_reservoir_now, fcc_1_MCA, fcc_1_ARD
  se_fc_rwn = zeros(numRiver, numStage)
  se_fc_resi_sv = zeros(numRiver, numStage)
  se_fc_resi = zeros(numRiver, numStage)
  se_fc_reservoir = zeros(numRiver, numStage)
  se_fc = zeros(numRiver, numStage)
  se_ac = zeros(numRiver, numStage)
  rwn = zeros(numRiver, numStage)
  resi_sv = zeros(numRiver, numStage)
  resi = zeros(numRiver, numStage)
  Q_river = zeros(numRiver, numStage)
  Q_reservoir_now = zeros(numPlant, numStage)
  sf_TD = zeros(numStage)
  sa_TD = zeros(numStage)
  fcc_1_MCA = zeros(numStage)
  fcc_1_ARD = zeros(numStage)
  fcc_corrected = zeros(6)

  for t = 1:numStage

    tp = t
    for i = 1:6
      if tp > 12
        tp = tp - 12
      end
    end
    # constraints
    if tp == 1
      for j = 1:numRiver

        se_fc[j, t] = 0
        se_ac[j, t] = 0
        rwn[j, t] = 0 # White_noise_cal
        resi_sv[j, t] = 0 # Residual_state_variable
        resi[j, t] = 0 # Residual_cal
        # Inflow_river_cal
        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * year[t])



        fcc_1_MCA[t] = fcc_min[tp, 1]
        fcc_1_ARD[t] = fcc_min[tp, 2]



      end

    elseif tp == 2
      for j = 1:numRiver
        se_fc_rwn[j, t] = se_fc_rv_value[1, tp] * sqrt(se_fc_eig_value[1, j]) * se_fc_eig_vector_peace[j, 1] + se_fc_rv_value[2, tp] * sqrt(se_fc_eig_value[j, 2]) * se_fc_eig_vector_columbia[2, j]
        se_fc_resi_sv[j, t] = 0
        se_fc_resi[j, t] = se_fc_rwn[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        rwn[j, t] = 0
        resi_sv[j, t] = 0
        resi[j, t] = 0
        Q_river[j, t] = inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])

        sf_TD[t] = sf_TD_intercept[tp] + sf_TD_slope[tp] * se_fc[2, t]
        sa_TD[t] = sa_TD_intercept[tp] + sa_TD_slope[tp] * sf_TD[t]

        fcc_1_MCA[t] = (sf_TD[t] - fcc_shift[1]) * fcc_slope[tp, 1] + fcc_intercept[tp, 1]
        fcc_1_ARD[t] = (sf_TD[t] - fcc_shift[2]) * fcc_slope[tp, 2] + fcc_intercept[tp, 2]

        if fcc_1_MCA[t] > fcc_max[tp, 1]
          fcc_corrected[4] = fcc_max[tp, 1] - fcc_1_MCA[t]
        elseif fcc_1_MCA[t] >= fcc_min[tp, 1]
          fcc_corrected[4] = 0
        else
          fcc_corrected[4] = fcc_min[tp, 1] - fcc_1_MCA[t]
        end

        if fcc_1_ARD[t] > fcc_max[tp, 2]
          fcc_corrected[6] = fcc_max[tp, 2] - fcc_1_ARD[t]
        elseif fcc_1_ARD[t] >= fcc_min[tp, 2]
          fcc_corrected[6] = 0
        else
          fcc_corrected[6] = fcc_min[tp, 2] - fcc_1_ARD[t]
        end

      end


    elseif tp == 3
      for j = 1:numRiver

        se_fc_rwn[j, t] = se_fc_rv_value[1, tp] * sqrt(se_fc_eig_value[1, j]) * se_fc_eig_vector_peace[j, 1] + se_fc_rv_value[2, tp] * sqrt(se_fc_eig_value[j, 2]) * se_fc_eig_vector_columbia[2, j]
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_rou[tp, j] * se_fc_resi_sv[j, t] + sqrt(1 - se_fc_rou[tp, j]^2) * se_fc_rwn[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        rwn[j, t] = 0
        resi_sv[j, t] = 0
        resi[j, t] = 0
        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t]))

        sf_TD[t] = sf_TD_intercept[tp] + sf_TD_slope[tp] * se_fc[2, t]
        sa_TD[t] = sa_TD_intercept[tp] + sa_TD_slope[tp] * sf_TD[t]

        fcc_1_MCA[t] = (sf_TD[t] - fcc_shift[1]) * fcc_slope[tp, 1] + fcc_intercept[tp, 1]
        fcc_1_ARD[t] = (sf_TD[t] - fcc_shift[2]) * fcc_slope[tp, 2] + fcc_intercept[tp, 2]

        if fcc_1_MCA[t] > fcc_max[tp, 1]
          fcc_corrected[4] = fcc_max[tp, 1] - fcc_1_MCA[t]
        elseif fcc_1_MCA[t] >= fcc_min[tp, 1]
          fcc_corrected[4] = 0
        else
          fcc_corrected[4] = fcc_min[tp, 1] - fcc_1_MCA[t]
        end

        if fcc_1_ARD[t] > fcc_max[tp, 2]
          fcc_corrected[6] = fcc_max[tp, 2] - fcc_1_ARD[t]
        elseif fcc_1_ARD[t] >= fcc_min[tp, 2]
          fcc_corrected[6] = 0
        else
          fcc_corrected[6] = fcc_min[tp, 2] - fcc_1_ARD[t]
        end

      end


    elseif tp == 4
      for j = 1:numRiver

        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_rou[tp, j] * se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        rwn[j, t] = 0
        resi_sv[j, t] = 0
        resi[j, t] = 0
        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t]))

        sf_TD[t] = sf_TD_intercept[tp] + sf_TD_slope[tp] * se_fc[2, t]
        sa_TD[t] = sa_TD_intercept[tp] + sa_TD_slope[tp] * sf_TD[t]

        fcc_1_MCA[t] = (sf_TD[t] - fcc_shift[1]) * fcc_slope[tp, 1] + fcc_intercept[tp, 1]
        fcc_1_ARD[t] = (sf_TD[t] - fcc_shift[2]) * fcc_slope[tp, 2] + fcc_intercept[tp, 2]

        if fcc_1_MCA[t] > fcc_max[tp, 1]
          fcc_corrected[4] = fcc_max[tp, 1] - fcc_1_MCA[t]
        elseif fcc_1_MCA[t] >= fcc_min[tp, 1]
          fcc_corrected[4] = 0
        else
          fcc_corrected[4] = fcc_min[tp, 1] - fcc_1_MCA[t]
        end

        if fcc_1_ARD[t] > fcc_max[tp, 2]
          fcc_corrected[6] = fcc_max[tp, 2] - fcc_1_ARD[t]
        elseif fcc_1_ARD[t] >= fcc_min[tp, 2]
          fcc_corrected[6] = 0
        else
          fcc_corrected[6] = fcc_min[tp, 2] - fcc_1_ARD[t]
        end

      end


    elseif tp == 5
      for j = 1:numRiver

        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_rou[tp, j] * se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t]

        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])) + inflow_sd[tp, j] * resi[j, t] + inflow_slope_se[tp, j] * se_ac[j, t]

        sf_TD[t] = sf_TD_intercept[tp] + sf_TD_slope[tp] * se_fc[2, t]
        sa_TD[t] = sa_TD_intercept[tp] + sa_TD_slope[tp] * sf_TD[t]

        fcc_1_MCA[t] = (sf_TD[t] - fcc_shift[1]) * fcc_slope[tp, 1] + fcc_intercept[tp, 1]
        fcc_1_ARD[t] = (sf_TD[t] - fcc_shift[2]) * fcc_slope[tp, 2] + fcc_intercept[tp, 2]

        if fcc_1_MCA[t] > fcc_max[tp, 1]
          fcc_corrected[4] = fcc_max[tp, 1] - fcc_1_MCA[t]
        elseif fcc_1_MCA[t] >= fcc_min[tp, 1]
          fcc_corrected[4] = 0
        else
          fcc_corrected[4] = fcc_min[tp, 1] - fcc_1_MCA[t]
        end

        if fcc_1_ARD[t] > fcc_max[tp, 2]
          fcc_corrected[6] = fcc_max[tp, 2] - fcc_1_ARD[t]
        elseif fcc_1_ARD[t] >= fcc_min[tp, 2]
          fcc_corrected[6] = 0
        else
          fcc_corrected[6] = fcc_min[tp, 2] - fcc_1_ARD[t]
        end

      end


    elseif tp == 6
      for j = 1:numRiver
        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])) + inflow_sd[tp, j] * resi[j, t] + inflow_slope_se[tp, j] * se_ac[j, t]

        fcc_1_MCA[t] = 0
        fcc_1_ARD[t] = 0

      end



    elseif tp == 7
      for j = 1:numRiver

        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])) + inflow_sd[tp, j] * resi[j, t] + inflow_slope_se[tp, j] * se_ac[j, t]

        fcc_corrected[4] = 0
        fcc_corrected[6] = 0

      end



    elseif tp == 8
      for j = 1:numRiver

        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])) + inflow_sd[tp, j] * resi[j, t] + inflow_slope_se[tp, j] * se_ac[j, t]

        fcc_1_MCA[t] = 0
        fcc_1_ARD[t] = 0

      end


    elseif tp == 9
      for j = 1:numRiver

        se_fc_rwn[j, t] = 0
        se_fc_resi_sv[j, t] = se_fc_resi[j, t-1]
        se_fc_resi[j, t] = se_fc_resi_sv[j, t]
        se_fc_reservoir[j, t] = se_fc_reservoir_intercept[tp, j] + se_fc_reservoir_slope[tp, j] * (year[t]) + se_fc_reservoir_sd[tp, j] * se_fc_resi[j, t]
        se_fc[j, t] = se_fc_intercept[tp, j] + se_fc_slope[tp, j] * se_fc_reservoir[j, t]
        se_ac[j, t] = se_actual_intercept[tp, j] + se_actual_slope[tp, j] * se_fc[j, t]

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end
        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]
        Q_river[j, t] = (inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t])) + inflow_sd[tp, j] * resi[j, t] + inflow_slope_se[tp, j] * se_ac[j, t]

        fcc_1_MCA[t] = 0
        fcc_1_ARD[t] = 0

      end


    elseif tp == 10
      for j = 1:numRiver

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]
        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t]) + inflow_sd[tp, j] * resi[j, t]

        fcc_1_MCA[t] = 0
        fcc_1_ARD[t] = 0

      end


    elseif tp == 11
      for j = 1:numRiver
        se_fc[j, t] = 0
        se_ac[j, t] = 0

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end
        resi_sv[j, t] = resi[j, t-1]

        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t]) + inflow_sd[tp, j] * resi[j, t]

        fcc_1_MCA[t] = fcc_min[tp, 1]
        fcc_1_ARD[t] = fcc_min[tp, 2]

      end


    elseif tp == 12
      for j = 1:numRiver

        se_fc[j, t] = 0
        se_ac[j, t] = 0

        if j == 1
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_peace[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_peace[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        else
          rwn[j, t] = exp((rv_value[1, t] * sqrt(eig_value[tp, 1]) * eig_vector_columbia[tp, 1] + rv_value[2, t] * sqrt(eig_value[tp, 2]) * eig_vector_columbia[tp, 2]) * rwn_sd[tp] + rwn_mean[tp]) - rwn_shift[tp]
        end

        resi_sv[j, t] = resi[j, t-1]

        resi[j, t] = rwn[j, t] * sqrt(1 - rou[tp]^2) + rou[tp] * resi_sv[j, t]

        Q_river[j, t] = inflow_intercept[tp, j] + inflow_slope_year[tp, j] * (year[t]) + inflow_sd[tp, j] * resi[j, t]

        fcc_1_MCA[t] = fcc_min[tp, 1]
        fcc_1_ARD[t] = fcc_min[tp, 2]

      end

    end

    j = 1
    if Inflow_min_Peace[tp] > Q_river[j, t]
      Q_river[j, t] = Inflow_min_Peace[tp]
    end
    if Inflow_max_Peace[tp] < Q_river[j, t]
      Q_river[j, t] = Inflow_max_Peace[tp]
    end
    j = 2
    if Inflow_min_Col[tp] > Q_river[j, t]
      Q_river[j, t] = Inflow_min_Col[tp]
    end
    if Inflow_max_Peace[tp] < Q_river[j, t]
      Q_river[j, t] = Inflow_max_Peace[tp]
    end


    for j = 1:numPlant
      if j == 1
        Q_reservoir_now[j, t] = inflow_percentage[tp, j] * Q_river[1, t]
      elseif j == 2
        Q_reservoir_now[j, t] = inflow_fixed
      elseif j == 3
        Q_reservoir_now[j, t] = inflow_percentage[tp, j] * Q_river[1, t]
      elseif j == 4
        Q_reservoir_now[j, t] = inflow_percentage[tp, j] * Q_river[2, t]
      elseif j == 5
        Q_reservoir_now[j, t] = inflow_percentage[tp, j] * Q_river[2, t]
      elseif j == 6
        Q_reservoir_now[j, t] = inflow_percentage[tp, j] * Q_river[2, t]
      end
    end


  end

end
