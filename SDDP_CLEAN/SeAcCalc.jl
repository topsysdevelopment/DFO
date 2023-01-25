function Se_Ac_Calc()
  inflowGMS = gms_inflow
  inflowPCN = pcn_inflow
  inflowSTC = stc_inflow
  inflowMCA = mca_inflow
  inflowREV = rev_inflow
  inflowARD = ard_inflow

  InflowColumbia = inflowGMS + inflowPCN + inflowSTC
  InflowPeace = inflowMCA + inflowREV + inflowARD

  se_ac_peace = (InflowPeace[:, 5] * numDayDecember[5] + InflowPeace[:, 6] * numDayDecember[6] + InflowPeace[:, 7] * numDayDecember[7] + InflowPeace[:, 8] * numDayDecember[8] + InflowPeace[:, 9] * numDayDecember[9]) / (numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])
  min_se_ac_peace = minimum(se_ac_peace)
  max_se_ac_peace = maximum(se_ac_peace)

  se_ac_columbia = (InflowColumbia[:, 5] * numDayDecember[5] + InflowColumbia[:, 6] * numDayDecember[6] + InflowColumbia[:, 7] * numDayDecember[7] + InflowColumbia[:, 8] * numDayDecember[8] + InflowColumbia[:, 9] * numDayDecember[9]) / (numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])
  min_se_ac_columbia = minimum(se_ac_columbia)
  max_se_ac_columbia = maximum(se_ac_columbia)

  return se_ac_peace, se_ac_columbia, min_se_ac_peace, max_se_ac_peace, min_se_ac_columbia, max_se_ac_columbia
end

