
function SIM(Output, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR, InputSDDPData, numIteration, numStage, cut_n, numSimulation)
  genNum = 0
  for sim = 1:numSimulation
    genNum += 1
    ## Forward
    for t_now = 1:numStage
      #for t_now = numStage:-1:1

      tp = t_now
      for i = 1:numForecastYear
        if tp > 12
          tp = tp - 12
        end
      end

      select = sim
      #select = gen
      global mode = "Simulation"
      Y = collect(1:numSimulation)
      println(mode)
      m , Output = SimulationFunc(Output, csv_inputs, dynamic_var, InputSDDPData, t_now, genNum, select)
      println(".........................stage_number............................")
      OutputResults(sim,t_now,m,Output,dynamic_var)
    end
  end

  include("ElevCalc.jl")

  # Write CSV
  include("WriteCSV.jl")

  # Write XML
  include("WriteXML.jl")

end

