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

function SelectCalc(InputData::SystemData)
  # For discrete stochastic process calculate the probability and random number between -1, 0, 1
  normalized_residual = InputData.normalized_residual_peace
  p1, p2, p3 = ProbabilityCalc(normalized_residual)
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
  histYear = InputData.histYear

  y = 2021
  se_fc_rv_value = RandomGenerator(p1, p2)
  rwn_peace = se_fc_rv_value[1] * multiplier_peace[1] + se_fc_rv_value[2] * multiplier_peace[2]
  rwn_columbia = se_fc_rv_value[1] * multiplier_columbia[1] + se_fc_rv_value[2] * multiplier_columbia[2]
  se_fc_peace = se_ac_peace_intercept + se_ac_peace_slope * y + se_ac_peace_std * rwn_peace
  se_fc_columbia = se_ac_columbia_intercept + se_ac_columbia_slope * y + se_ac_columbia_std * rwn_columbia

  min_se_ac_peace = InputData.min_se_ac_peace
  max_se_ac_peace = InputData.max_se_ac_peace
  min_se_ac_columbia = InputData.min_se_ac_columbia
  max_se_ac_columbia = InputData.max_se_ac_columbia

  AP = (se_ac_peace - se_fc_peace * ones(length(histYear))) / (max_se_ac_peace - min_se_ac_peace)
  AC = (se_ac_columbia - se_fc_columbia * ones(length(histYear))) / (max_se_ac_columbia - min_se_ac_columbia)

  # peace_position = findmin((se_ac_peace-se_fc_peace*ones(length(histYear))).^2)
  # columbia_position = findmin((se_ac_columbia-se_fc_columbia*ones(length(histYear))).^2)

  peace_position = findmin(AP .^ 2)
  columbia_position = findmin(AC .^ 2)

  prob_peace = peace_position[1] / (peace_position[1] + columbia_position[1])
  prob_columbia = columbia_position[1] / (peace_position[1] + columbia_position[1])


  a = rand(1)
  RandomNum = a[1]
  if RandomNum < prob_peace
    selected_year = histYear[peace_position[2]]
  else
    selected_year = histYear[columbia_position[2]]
  end

  return selected_year
end

SelectCalc(InputData)
