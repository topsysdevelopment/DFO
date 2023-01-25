fccblock = readdlm("In/FCC.csv", ',', Float64)
V_sv_MCA_candidate = zeros(numSimulation, numStage)
function FCC_Calc(numSimulation,numIteration,numStage,fccblock,V_sv_MCA_candidate)
  cut_n = 1
  for k = 1:numSimulation
    wxYr = k
    cut_n += 1
    if cut_n<=numIteration
      # Backward
      mode = "FCC"
      println(mode)
      println("........................................................")
      println(cut_n)
      for t_now = numStage:-1:2
        V_sv_MCA_candidate = BackwardPassFcc(t_now, wxYr, numSimulation,fccblock,V_sv_MCA_candidate)
      end
    end
  end
  return V_sv_MCA_candidate
end

V_sv_MCA_candidate = FCC_Calc(numSimulation,numIteration,numStage,fccblock,V_sv_MCA_candidate)

monthLabel = ["DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV"]
global HEADER = repeat(monthLabel, numForecastYear)
CSV.write("In/V_MCA_SV_MIN.csv", Tables.table(V_sv_MCA_candidate), writeheader = true, header = HEADER)
# CSV.write("Output/fcc.csv", Tables.table(fccblock), writeheader = false)
csv_inputs.mca_sv_min = V_sv_MCA_candidate