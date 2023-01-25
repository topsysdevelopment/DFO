function initialization(DeParam::DifferentialEvolutionParameter)
  DeParam.maxit = 10000
  DeParam.beta_min = 0.2
  DeParam.beta_max = 0.8
  DeParam.pcr = 0.3
  DeParam.npop = 200
  DeParam.nvar = 2
  DeParam.varmin = -1e10 * ones(DeParam.nvar, 1)
  DeParam.varmax = 1e10 * ones(DeParam.nvar, 1)

  return DeParam
end


function obj(z, x, y)
  Error = zeros(length(y), 1)
  for i = 1:length(y)
    term = z[1]
    for k = 2:length(z)
      term = term + z[k] * x[i, k-1]
    end
    Error[i] = (y[i] - term)^2
  end
  f = sqrt(sum(Error))

  return f
end


function initialPop(DeParam::DifferentialEvolutionParameter, xin, yout)
  varmin = DeParam.varmin
  varmax = DeParam.varmax
  npop = DeParam.npop
  nvar = DeParam.nvar
  position = zeros(npop, nvar)
  cost = zeros(npop, 1)
  bestcost = 1e200
  bestpos = zeros(1, nvar)

  for i = 1:npop
    newpos = zeros(nvar, 1)
    for j = 1:nvar
      RandomNumber = rand(1)
      newpos[j] = varmin[j] + (varmax[j] - varmin[j]) * RandomNumber[1]
    end
    newcost = obj(newpos, xin, yout)
    position[i, :] = newpos
    cost[i] = newcost

    if newcost < bestcost
      bestcost = newcost
      bestpos = newpos
    end
  end

  DeParam.position = position
  DeParam.cost = cost
  DeParam.bestcost = bestcost
  DeParam.bestpos = bestpos

  return DeParam
end


function DEiterations(DeParam::DifferentialEvolutionParameter, xin, yout)
  nvar = DeParam.nvar
  pcr = DeParam.pcr
  beta_min = DeParam.beta_min
  beta_max = DeParam.beta_max
  varmin = DeParam.varmin
  varmax = DeParam.varmax
  maxit = DeParam.maxit
  npop = DeParam.npop

  position = DeParam.position
  cost = DeParam.cost
  bestcost = DeParam.bestcost
  bestpos = DeParam.bestpos

  for iter = 1:maxit
    for i = 1:npop
      A = collect(1:npop)
      A = shuffle(A)
      filter!(e -> e ≠ i, A)
      a = A[1]
      b = A[2]
      c = A[3]

      x = position[i, :]

      beta = zeros(nvar, 1)
      y = zeros(nvar, 1)
      for j = 1:nvar
        RandomNumber = rand(1)
        beta[j] = beta_min + RandomNumber[1] * (beta_max - beta_min)
        y[j] = position[a, j] + beta[j] * (position[b, j] - position[c, j])
        y[j] = min(max(y[j], varmin[j]), varmax[j])
      end

      z = zeros(nvar, 1)

      for j = 1:nvar
        RandomNumber = rand(1)
        if RandomNumber[1] <= pcr
          z[j] = y[j]
        else
          z[j] = x[j]
        end
      end

      newposition = z
      newcost = obj(newposition, xin, yout)

      if newcost < cost[i]
        cost[i] = newcost
        position[i, :] = newposition

        if newcost < bestcost
          bestcost = newcost
          bestpos = newposition
        end
      end

    end
    # println(bestcost)
  end

  DeParam.position = position
  DeParam.cost = cost
  DeParam.bestcost = bestcost
  DeParam.bestpos = bestpos

  return DeParam
end

function LineCalc(DeParam::DifferentialEvolutionParameter, InputData::SystemData)
  initialization(DeParam)

  DeParam.nvar = 2
  DeParam.varmin = -1e10 * ones(DeParam.nvar, 1)
  DeParam.varmax = 1e10 * ones(DeParam.nvar, 1)
  # cut-line for se_ac_columbia
  yout = InputData.se_ac_columbia
  xin = InputData.histYear
  initialPop(DeParam, xin, yout)
  DEiterations(DeParam, xin, yout)
  cut_cept_slope = DeParam.bestpos
  CSV.write("In/cut_cept_slope_se_ac_columbia.csv", Tables.table(cut_cept_slope), writeheader = false)

  # se_ac = intercept + slope*year
  # intercept = 5299.257528
  # slope = -1.555431089

  InputData.se_ac_columbia_intercept = cut_cept_slope[1]
  InputData.se_ac_columbia_slope = cut_cept_slope[2]
  InputData.se_ac_columbia_std = std(yout)
  residual_columbia = (yout - (InputData.se_ac_columbia_slope * xin + InputData.se_ac_columbia_intercept * ones(length(xin))))
  normalized_residual_columbia = residual_columbia / InputData.se_ac_columbia_std
  InputData.normalized_residual_columbia = normalized_residual_columbia

  # DeParam.nvar = 3
  # DeParam.varmin = -1e10 * ones(DeParam.nvar,1)
  # DeParam.varmax = 1e10 * ones(DeParam.nvar,1)
  # # cut-line for se_ac_columbia
  # yout = InputData.se_ac_columbia
  # xin = [InputData.histYear normalized_residual_columbia]
  # initialPop(DeParam, xin, yout)
  # DEiterations(DeParam, xin, yout)
  # cut_cept_slope = DeParam.bestpos
  # CSV.write("Output/cut_cept_slope_se_ac_columbia.csv",  Tables.table(cut_cept_slope), writeheader = false)

  DeParam.nvar = 2
  DeParam.varmin = -1e10 * ones(DeParam.nvar, 1)
  DeParam.varmax = 1e10 * ones(DeParam.nvar, 1)
  yout = InputData.se_ac_peace
  xin = InputData.histYear
  initialPop(DeParam, xin, yout)
  DEiterations(DeParam, xin, yout)
  cut_cept_slope = DeParam.bestpos
  CSV.write("In/cut_cept_slope_se_ac_peace.csv", Tables.table(cut_cept_slope), writeheader = false)

  # se_ac = intercept + slope*year
  # intercept = 4981.140093
  # slope = -1.4668192

  InputData.se_ac_peace_intercept = cut_cept_slope[1]
  InputData.se_ac_peace_slope = cut_cept_slope[2]
  InputData.se_ac_peace_std = std(yout)
  residual_peace = (yout - (InputData.se_ac_peace_intercept * ones(length(xin)) + InputData.se_ac_peace_slope * xin))
  normalized_residual_peace = residual_peace / InputData.se_ac_peace_std
  InputData.normalized_residual_peace = normalized_residual_peace

  # DeParam.nvar = 3
  # DeParam.varmin = -1e10 * ones(DeParam.nvar,1)
  # DeParam.varmax = 1e10 * ones(DeParam.nvar,1)
  # yout = InputData.se_ac_peace
  # xin = [InputData.histYear normalized_residual_peace]
  # initialPop(DeParam, xin, yout)
  # DEiterations(DeParam, xin, yout)
  # cut_cept_slope = DeParam.bestpos
  # CSV.write("Output/cut_cept_slope_se_ac_peace.csv",  Tables.table(cut_cept_slope), writeheader = false)
end

LineCalc(DeParam, InputData)

function CovCalc(mat)
  x = mat[:, 1]
  y = mat[:, 2]
  xm = mean(x)
  ym = mean(y)

  xn = x - xm * ones(length(x), 1)
  yn = y - ym * ones(length(y), 1)

  cov11 = xn' * xn / (length(x) - 1)
  cov12 = xn' * yn / (length(x) - 1)
  cov21 = yn' * xn / (length(x) - 1)
  cov22 = yn' * yn / (length(x) - 1)

  covariance = [cov11 cov12; cov21 cov22]

  return covariance
end


function PcaCalc(InputData::SystemData)
  normalized_residual_peace = InputData.normalized_residual_peace
  normalized_residual_columbia = InputData.normalized_residual_columbia
  mat = [normalized_residual_peace normalized_residual_columbia]
  covariance = CovCalc(mat)
  eigvalue = eigvals(covariance)
  eigvector = eigvecs(covariance)
  InputData.eigvalue = eigvalue
  InputData.eigvector = eigvector
end

PcaCalc(InputData)

function MultiplierCalc(InputData::SystemData)
  eigvalue = InputData.eigvalue
  eigvector = InputData.eigvector
  # first method
  multiplier_peace = [eigvalue[1] / eigvector[1, 1] eigvalue[2] / eigvector[1, 2]]
  multiplier_columbia = [eigvalue[1] / eigvector[2, 1] eigvalue[2] / eigvector[2, 2]]
  # second method
  multiplier_peace = [sqrt(eigvalue[1]) * eigvector[1, 1] sqrt(eigvalue[2]) * eigvector[1, 2]]
  multiplier_columbia = [sqrt(eigvalue[1]) * eigvector[2, 1] sqrt(eigvalue[2]) * eigvector[2, 2]]
  #rwn_peace = se_fc_rv_value[1] * sqrt(eigvalue[1]) * eigvector[1,1] + se_fc_rv_value[2] * sqrt(eigvalue[2]) * eigvector[1,2]
  InputData.multiplier_peace = multiplier_peace
  InputData.multiplier_columbia = multiplier_columbia
end

MultiplierCalc(InputData)
