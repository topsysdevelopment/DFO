if hkNonlinear == 1
  global numit = 10
else
  global numit = 1
end
cut_n = numIteration

function SDDP(InputData::SystemData, Output:: SDDP_Variables, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR ,numIteration, numSimulation, numStage)
  cut_n = 1
  genNum = 0
  
  for gen = 1:numIteration
    genNum += 1
    selected_year = SeFcCalcForward(InputData)
    forwardselect = zeros(numStage)
    X = collect(1:numSimulation)
    Y = shuffle(X)
    for t_now = 1:numStage-1
      global mode = "Forward"
      println(mode)
      m , Output = ForwardPass(selected_year, Output, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR, InputSDDPData, t_now, forwardselect, genNum, Y)
      println("........................................................")
      println(t_now)
    end
    cut_n += 1
    if cut_n<=numIteration
      # Backward
      for t_now = numStage:-1:2
        global mode = "Backward"
        println(mode)
        println("........................................................")
        println(cut_n)
        Output = BackwardPass(InputData, Output, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR, t_now, forwardselect, genNum, cut_n)
      end
    end
  end
end

