# Copyright 2022, Naser Moosavian, Ph.D., University of British Columbia
# This Source Code Form is subject to the terms of the BC Hydro Co.
# A copy of the code is available at EnergyStudiesTest\Models\WVM\.
#############################################################################
# Application of SDDP for the Optimization of Reservoir Operations 
# Source: Naser Moosavian]
#############################################################################

# Loading required packages for SDDP code
using Clp
using CSV
using DataFrames
using Dates
using DelimitedFiles
using Distributions
using ESMToolKit
using ESMToolKit.Enums
using JuMP
using LinearAlgebra
using Random
using Statistics
using Tables
using Dates

# Initializing the basic parameters for SDDP
numIteration = 50 # number of SDDP iterations
numSimulation = 49 # number of simulations after optimization
numForecastYear = 5 # number of years
numStage = 12 * numForecastYear # number of stages
numStage5 = 60 # number of stages for five years
numPlant = 6 # number of reservoirs/plants
numRiver = 2 # number of rivers
numTimeBlock = 5 # number of time blocks
hkNonlinear = 0 # This value is zero when we assume Hk is constant and is 1 when we use nonlinear equations for Hk approximation
global sim = 0 # this parameter is used on WriteCSV.jl
homePath = "C:/EnergyStudiesTest/Models/WVM/src/SDDP_CLEAN/"
cd(homePath)
strpath = string(homePath, "In/")

# Initialization
include("Initialization.jl")
include("TVF.jl")
include("loadprice.jl")
# load2020 = readdlm("In/load_2020.csv", ',', Float64)
include("InputData.jl")
# Calculate Inflow
include("InflowCalc.jl")
# Caculate Actual Seasonal Inflow
include("SeasonalActualCalc.jl")
# Calclate AR1 Inflow
include("AR1Calc.jl")
# Caculate Forecasted Seasonal Inflow
include("SeasonalForecastCalc.jl")
# Select Inflow Year
include("SelectYear.jl")

# Define Variables
include("Variable.jl")
# Define Constraints
include("Constraint.jl")

# Define Objective Function
include("ObjectiveFunction.jl")
# include("ObjectiveFunctionBack.jl")
# Optimization Outputs
include("OutputResults.jl")
# Forward Pass Function (Preparation for Backward Pass)
include("ForwardPassFunc.jl")

# Backward Pass Function
include("BackwardPassFunc.jl")

# Backward Pass Function
include("BackwardPassFcc.jl")

# Main SSDP Optimization
include("Fcc.jl")

include("SimulationFunc.jl")

# Main SSDP Optimization
include("Main_SDDP.jl")

start = time()
SDDP(InputData,Output, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR ,numIteration, numSimulation, numStage)
elapsed = time() - start
cut_n -= 1

include("SimFunc.jl")
SIM(Output, csv_inputs::CSV_INPUTS, dynamic_var::DYNMAIC_VAR, InputSDDPData, numIteration, numStage, cut_n, numSimulation)