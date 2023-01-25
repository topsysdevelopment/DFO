function RandomGenerator(p1, p2)
  # In the backward pass -1 for peace with probability of p1; 0 with prob of p2 and 1 with prob of p3
  se_fc_rv_value = zeros(2)
  for e = 1:2
    a = rand(1)
    RandomNum = a[1]
    if RandomNum <= p1
      se_fc_rv_value[e] = -1
    elseif RandomNum <= p1 + p2
      se_fc_rv_value[e] = 0
    else
      se_fc_rv_value[e] = 1
    end
  end
  return se_fc_rv_value
end

function ProbabilityCalc(normalized_residual)
  #normalized_residual = sort(normalized_residual)
  L = length(normalized_residual)
  l1 = floor(L / 3)
  l3 = l1
  l2 = L - 2 * l1
  p1 = l1 / L
  p2 = l2 / L
  p3 = l3 / L
  return p1, p2, p3

end

function SeFcCalcProb(InputData::SystemData)
  # For discrete stochastic process calculate the probability and random number between -1, 0, 1
  normalized_residual = InputData.normalized_residual_peace
  p1peace, p2peace, p3peace = ProbabilityCalc(normalized_residual)
  normalized_residual = InputData.normalized_residual_columbia
  p1columbia, p2columbia, p3columbia = ProbabilityCalc(normalized_residual)
  InputData.prob_peace = [p1peace p2peace p3peace]
  InputData.prob_columbia = [p1columbia p2columbia p3columbia]
end

SeFcCalcProb(InputData)

function SeFcCalcForward(InputData::SystemData)

  prob_peace = InputData.prob_peace
  prob_columbia = InputData.prob_columbia

  multiplier_peace = InputData.multiplier_peace
  multiplier_columbia = InputData.multiplier_columbia
  se_ac_peace_intercept = InputData.se_ac_peace_intercept
  se_ac_peace_slope = InputData.se_ac_peace_slope
  se_ac_peace_std = InputData.se_ac_peace_std
  se_ac_columbia_intercept = InputData.se_ac_columbia_intercept
  se_ac_columbia_slope = InputData.se_ac_columbia_slope
  se_ac_columbia_std = InputData.se_ac_columbia_std
  se_ac_peace = InputData.se_ac_peace
  se_ac_columbia = InputData.se_ac_columbia
  min_se_ac_peace = InputData.min_se_ac_peace
  max_se_ac_peace = InputData.max_se_ac_peace
  min_se_ac_columbia = InputData.min_se_ac_columbia
  max_se_ac_columbia = InputData.max_se_ac_columbia

  selected_year = zeros(numStage)
  y = 2021
  for t = 1:numStage
    t0 = t
    if t0 > 10 * 12
      t0 = t0 - 10 * 12
    end
    y = y + (t-t0)/12

    se_fc_rv_peace = RandomGenerator(prob_peace[1], prob_peace[2])
    se_fc_rv_columbia = RandomGenerator(prob_columbia[1], prob_columbia[2])
    rwn_peace = se_fc_rv_peace[1] * multiplier_peace[1] + se_fc_rv_peace[2] * multiplier_peace[2]
    rwn_columbia = se_fc_rv_columbia[1] * multiplier_columbia[1] + se_fc_rv_columbia[2] * multiplier_columbia[2]
    se_fc_peace = se_ac_peace_intercept + se_ac_peace_slope * y + se_ac_peace_std * rwn_peace
    se_fc_columbia = se_ac_columbia_intercept + se_ac_columbia_slope * y + se_ac_columbia_std * rwn_columbia
    AP = (se_ac_peace - se_fc_peace * ones(length(histYear))) / (max_se_ac_peace - min_se_ac_peace)
    AC = (se_ac_columbia - se_fc_columbia * ones(length(histYear))) / (max_se_ac_columbia - min_se_ac_columbia)
    peace_position = findmin(AP .^ 2)
    columbia_position = findmin(AC .^ 2)
    prob_peace1 = peace_position[1] / (peace_position[1] + columbia_position[1])
    prob_columbia1 = columbia_position[1] / (peace_position[1] + columbia_position[1])
    a = rand(1)
    RandomNum = a[1]
    if RandomNum < prob_peace1
      selected_year[t] = histYear[peace_position[2]] - histYear[1] + 1
    else
      selected_year[t] = histYear[columbia_position[2]] - histYear[1] + 1
    end
  end

  return selected_year
end



function SeFcCalc(InputData::SystemData, t, se_fc_rv_peace, se_fc_rv_columbia)

  prob_peace = InputData.prob_peace
  prob_columbia = InputData.prob_columbia

  multiplier_peace = InputData.multiplier_peace
  multiplier_columbia = InputData.multiplier_columbia
  se_ac_peace_intercept = InputData.se_ac_peace_intercept
  se_ac_peace_slope = InputData.se_ac_peace_slope
  se_ac_peace_std = InputData.se_ac_peace_std
  se_ac_columbia_intercept = InputData.se_ac_columbia_intercept
  se_ac_columbia_slope = InputData.se_ac_columbia_slope
  se_ac_columbia_std = InputData.se_ac_columbia_std
  se_ac_peace = InputData.se_ac_peace
  se_ac_columbia = InputData.se_ac_columbia
  min_se_ac_peace = InputData.min_se_ac_peace
  max_se_ac_peace = InputData.max_se_ac_peace
  min_se_ac_columbia = InputData.min_se_ac_columbia
  max_se_ac_columbia = InputData.max_se_ac_columbia


  y = 2021
  t0 = t
  if t0 > 11 * 12
    t0 = t0 - 11 * 12
  end
  y = y + (t-t0)/12

  rwn_peace = se_fc_rv_peace[1] * multiplier_peace[1] + se_fc_rv_peace[2] * multiplier_peace[2]
  rwn_columbia = se_fc_rv_columbia[1] * multiplier_columbia[1] + se_fc_rv_columbia[2] * multiplier_columbia[2]
  se_fc_peace = se_ac_peace_intercept + se_ac_peace_slope * y + se_ac_peace_std * rwn_peace
  se_fc_columbia = se_ac_columbia_intercept + se_ac_columbia_slope * y + se_ac_columbia_std * rwn_columbia
  AP = (se_ac_peace - se_fc_peace * ones(length(histYear))) / (max_se_ac_peace - min_se_ac_peace)
  AC = (se_ac_columbia - se_fc_columbia * ones(length(histYear))) / (max_se_ac_columbia - min_se_ac_columbia)
  peace_position = findmin(AP .^ 2)
  columbia_position = findmin(AC .^ 2)
  prob_peace1 = peace_position[1] / (peace_position[1] + columbia_position[1])
  prob_columbia1 = columbia_position[1] / (peace_position[1] + columbia_position[1])
  a = rand(1)
  RandomNum = a[1]
  if RandomNum < prob_peace1
    selected_year = histYear[peace_position[2]] - histYear[1] + 1
  else
    selected_year = histYear[columbia_position[2]] - histYear[1] + 1
  end


  return selected_year, prob_peace, prob_columbia
end
