function Day2Month(plantname)
  Data = plantname
  yearall = Data[:, 1]
  inflowall = Data[:, 2]
  inflow = zeros(2021 - 1928 + 1, 12) # 1928-2021

  for j = 1:length(inflowall)
    yeartext = yearall[j]
    ysplit = deleteat!(split(yeartext, ""), 5)
    year = [ysplit[1], ysplit[2], ysplit[3], ysplit[4]]
    year = parse.(Int, year)
    year = join(year)
    year = parse.(Int, year)

    month = [ysplit[5], ysplit[6]]
    month = parse.(Int, month)
    month = join(month)
    month = parse.(Int, month)

    day = [ysplit[8], ysplit[9]]
    day = parse.(Int, day)
    day = join(day)
    day = parse.(Int, day)
    t = 0
    for y = 1928:2021
      t += 1
      for m = 1:12
        if (year == y && month == m)
          inflow[t, m] += inflowall[j]
        end
      end

    end

  end
  
  for t = 1:length(inflow[:, 1])
    for m = 1:length(inflow[1, :])
      inflow[t, m] = inflow[t, m] / numDayCalendar[m]
    end
  end
  
  return inflow
end


function inflowcalc(InputData::SystemData)
  plantname = InputData.WSR_daily_reservoir_inflow_hist
  inflowGMS = Day2Month(plantname)
  plantname = InputData.PCN_daily_reservoir_inflow_hist
  inflowPCN = Day2Month(plantname)
  plantname = InputData.STC_daily_reservoir_inflow_hist
  inflowSTC = Day2Month(plantname)
  plantname = InputData.KBT_daily_reservoir_inflow_hist
  inflowMCA = Day2Month(plantname)
  plantname = InputData.REV_daily_reservoir_inflow_hist
  inflowREV = Day2Month(plantname)
  plantname = InputData.ARW_daily_reservoir_inflow_hist
  inflowARD = Day2Month(plantname)

  return inflowGMS, inflowPCN, inflowSTC, inflowMCA, inflowREV, inflowARD
end

function InflowSpecifications(InputData::SystemData)
  inflowGMS, inflowPCN, inflowSTC, inflowMCA, inflowREV, inflowARD = inflowcalc(InputData)
  # 1 = 1928
  # 45 = 1972
  # 93 = 2020
  # Jan-Dec: 1972-2020
  inflowGMS = inflowGMS[45:93, :]
  inflowPCN = inflowPCN[45:93, :]
  inflowSTC = inflowSTC[45:93, :]
  inflowMCA = inflowMCA[45:93, :]
  inflowREV = inflowREV[45:93, :]
  inflowARD = inflowARD[45:93, :]

  # Dec-Nov: 1972-2020 
  inflowGMS = [inflowGMS[:, end] inflowGMS]
  inflowGMS[:, (1:end).!=13] # drop the last column

  inflowPCN = [inflowPCN[:, end] inflowPCN]
  inflowPCN[:, (1:end).!=13] # drop the last column

  inflowSTC = [inflowSTC[:, end] inflowSTC]
  inflowSTC[:, (1:end).!=13] # drop the last column

  inflowMCA = [inflowMCA[:, end] inflowMCA]
  inflowMCA[:, (1:end).!=13] # drop the last column

  inflowREV = [inflowREV[:, end] inflowREV]
  inflowREV[:, (1:end).!=13] # drop the last column

  inflowARD = [inflowARD[:, end] inflowARD]
  inflowARD[:, (1:end).!=13] # drop the last column

  InputData.q_reservoir_monthly_GMS = inflowGMS
  InputData.q_reservoir_monthly_PCN = inflowPCN
  InputData.q_reservoir_monthly_STC = inflowSTC
  InputData.q_reservoir_monthly_MCA = inflowMCA
  InputData.q_reservoir_monthly_REV = inflowREV
  InputData.q_reservoir_monthly_ARD = inflowARD

  CSV.write("In/inflowActualGMS.csv", Tables.table(inflowGMS), writeheader = false)
  CSV.write("In/inflowActualPCN.csv", Tables.table(inflowPCN), writeheader = false)
  CSV.write("In/inflowActualSTC.csv", Tables.table(inflowSTC), writeheader = false)
  CSV.write("In/inflowActualMCA.csv", Tables.table(inflowMCA), writeheader = false)
  CSV.write("In/inflowActualREV.csv", Tables.table(inflowREV), writeheader = false)
  CSV.write("In/inflowActualARD.csv", Tables.table(inflowARD), writeheader = false)

end

InflowSpecifications(InputData)
