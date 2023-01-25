function Se_Ac_Calc(InputData::SystemData)
  inflowGMS = InputData.q_reservoir_monthly_GMS
  inflowPCN = InputData.q_reservoir_monthly_PCN
  inflowSTC = InputData.q_reservoir_monthly_STC
  inflowMCA = InputData.q_reservoir_monthly_MCA
  inflowREV = InputData.q_reservoir_monthly_REV
  inflowARD = InputData.q_reservoir_monthly_ARD

  InflowColumbia = inflowGMS + inflowPCN + inflowSTC
  InflowPeace = inflowMCA + inflowREV + inflowARD

  CSV.write("In/inflowActualColumbia.csv", Tables.table(InflowColumbia), writeheader = false)
  CSV.write("In/inflowActualPeace.csv", Tables.table(InflowPeace), writeheader = false)

  InputData.q_river_ac_peace = InflowPeace
  InputData.q_river_ac_columbia = InflowColumbia

  se_ac_peace = (InflowPeace[:, 5] * numDayDecember[5] + InflowPeace[:, 6] * numDayDecember[6] + InflowPeace[:, 7] * numDayDecember[7] + InflowPeace[:, 8] * numDayDecember[8] + InflowPeace[:, 9] * numDayDecember[9]) / (numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])
  min_se_ac_peace = minimum(se_ac_peace)
  max_se_ac_peace = maximum(se_ac_peace)

  se_ac_columbia = (InflowColumbia[:, 5] * numDayDecember[5] + InflowColumbia[:, 6] * numDayDecember[6] + InflowColumbia[:, 7] * numDayDecember[7] + InflowColumbia[:, 8] * numDayDecember[8] + InflowColumbia[:, 9] * numDayDecember[9]) / (numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])
  min_se_ac_columbia = minimum(se_ac_columbia)
  max_se_ac_columbia = maximum(se_ac_columbia)

  InputData.se_ac_peace = se_ac_peace
  InputData.se_ac_columbia = se_ac_columbia

  InputData.min_se_ac_peace = min_se_ac_peace
  InputData.max_se_ac_peace = max_se_ac_peace
  InputData.min_se_ac_columbia = min_se_ac_columbia
  InputData.max_se_ac_columbia = max_se_ac_columbia

  CSV.write("In/se_ac_peace.csv", Tables.table(se_ac_peace), writeheader = false)
  CSV.write("In/se_ac_columbia.csv", Tables.table(se_ac_columbia), writeheader = false)

end

Se_Ac_Calc(InputData)
