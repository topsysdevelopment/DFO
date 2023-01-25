TVF = readdlm("In/tvf.csv", ',', Float64)
function Terminal_Value(Output,TVF,numIteration,numStage)
  for cutNum=1:numIteration
    tvfLength = length(TVF[:,1])
    ii = mod(cutNum,tvfLength)
    if ii == 0; ii=tvfLength; end;
  
    if TVF[ii,1]>0
      Output.cut_intercept[cutNum, numStage] = TVF[ii,1]
    end
    if TVF[ii,2]>0
      Output.cut_slope_GMS[cutNum, numStage] = TVF[ii,2]
    end
    if TVF[ii,3]>0
      Output.cut_slope_MCA[cutNum, numStage] = TVF[ii,3]
    end
    if TVF[ii,4]>0
      Output.cut_slope_ARW[cutNum, numStage] = TVF[ii,4]
    end
    if TVF[ii,5]>0
      Output.cut_slope_Treaty_MCA[cutNum, numStage] = 0#TVF[ii,5]
    end
    if TVF[ii,6]>0
      Output.cut_slope_Treaty_ARW[cutNum, numStage] = 0#TVF[ii,6]
    end
    if TVF[ii,7]>0
      Output.cut_slope_NonTreaty_CA[cutNum, numStage] = TVF[ii,7]
    end
    if TVF[ii,8]>0
      Output.cut_slope_NonTreaty_US[cutNum, numStage] = TVF[ii,8]
    end
    
  end
  return Output
end

Output = Terminal_Value(Output,TVF,numIteration,numStage)