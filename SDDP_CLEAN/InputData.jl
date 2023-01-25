histYear = InputSDDPData.histYear
numDayCalendar = InputSDDPData.numDayCalendar
numDayDecember = InputSDDPData.numDayDecember
function ReadDataCol!(strpath::String, name)
  # Read data
  Data = DelimitedFiles.readdlm(strpath * name, ',')
  # Read header
  Header = Data[1, 1:end]
  # Remove first row
  Data = Data[1:end.≠1, 1:end]
  
  return Data
end

function ReadSysData(InputData::SystemData, strpath::String)
  
  # Input inflow forecast data
  name = "GMSIN.csv"
  InputData.WSR_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "PCNIN.csv"
  InputData.PCN_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "STCIN.csv"
  InputData.STC_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "MCAIN.csv"
  InputData.KBT_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "REVIN.csv"
  InputData.REV_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "ARDIN.csv"
  InputData.ARW_reservoir_inflow_fcst = ReadDataCol!(strpath, name)
  name = "TTYST.csv"
  InputData.total_treaty_strorage = ReadDataCol!(strpath, name)

  Peace_river_inflow_fcst = InputData.WSR_reservoir_inflow_fcst + InputData.PCN_reservoir_inflow_fcst + InputData.STC_reservoir_inflow_fcst
  Columbia_river_inflow_fcst = InputData.KBT_reservoir_inflow_fcst + InputData.REV_reservoir_inflow_fcst + InputData.ARW_reservoir_inflow_fcst

  InputData.Peace_river_inflow_fcst = Peace_river_inflow_fcst
  InputData.Columbia_river_inflow_fcst = Columbia_river_inflow_fcst

  # se_fc_peace = (Peace_river_inflow_fcst[:,5]*numDayDecember[5] + Peace_river_inflow_fcst[:,6]*numDayDecember[6] + Peace_river_inflow_fcst[:,7]*numDayDecember[7] + Peace_river_inflow_fcst[:,8]*numDayDecember[8] + Peace_river_inflow_fcst[:,9]*numDayDecember[9])/(numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])
  # se_fc_columbia = (Columbia_river_inflow_fcst[:,5]*numDayDecember[5] + Columbia_river_inflow_fcst[:,6]*numDayDecember[6] + Columbia_river_inflow_fcst[:,7]*numDayDecember[7] + Columbia_river_inflow_fcst[:,8]*numDayDecember[8] + Columbia_river_inflow_fcst[:,9]*numDayDecember[9])/(numDayDecember[5] + numDayDecember[6] + numDayDecember[7] + numDayDecember[8] + numDayDecember[9])

  # InputData.se_fc_peace = se_fc_peace
  # InputData.se_fc_columbia = se_fc_columbia

  # CSV.write("Output/se_fc_peace.csv", Tables.table(se_fc_peace), writeheader = false)
  # CSV.write("Output/se_fc_columbia.csv", Tables.table(se_fc_columbia), writeheader = false)

  # Input inflow historic data
  name = "GMSINHISTDAILY.csv"
  InputData.WSR_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)
  name = "PCNINHISTDAILY.csv"
  InputData.PCN_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)
  name = "STCINHISTDAILY.csv"
  InputData.STC_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)
  name = "MCAINHISTDAILY.csv"
  InputData.KBT_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)
  name = "REVINHISTDAILY.csv"
  InputData.REV_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)
  name = "ARDINHISTDAILY.csv"
  InputData.ARW_daily_reservoir_inflow_hist = ReadDataCol!(strpath, name)

end

ReadSysData(InputData, strpath)
InputData.histYear = histYear
