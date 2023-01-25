# block1 = CSV.read("BlocksFinal1.csv", DataFrame)
block1 = readdlm("In/BlocksFinal.csv", ',', Float64)

function ImportLoadPriceData(InputSDDPData, block1, numSimulation, numStage5)
    price_dec = zeros(numStage5, numSimulation)
    load_dec = zeros(numStage5, numSimulation)
    block2 = zeros(numStage5, numSimulation*10)
    kk = 1
    k = 1
    ii = 0
    for i = 1:12*5
        ii = ii + 1
        block2[ii,:] = block1[k,:]
        k = k+5
        if k > 60
            kk = kk + 1
            k = kk
        end
    end

    peakprice = zeros(numStage5,numSimulation)
    h6price = zeros(numStage5,numSimulation)
    h8price = zeros(numStage5,numSimulation)
    l6price = zeros(numStage5,numSimulation)
    l2price = zeros(numStage5,numSimulation)
    peakload = zeros(numStage5,numSimulation)
    h6load = zeros(numStage5,numSimulation)
    h8load = zeros(numStage5,numSimulation)
    l6load = zeros(numStage5,numSimulation)
    l2load = zeros(numStage5,numSimulation)

    k = 1
    kk = 1
    for i = 1:49
        peakprice[:,k] = block2[:,kk]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        h6price[:,k] = block2[:,kk+1]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        h8price[:,k] = block2[:,kk+2]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        l6price[:,k] = block2[:,kk+3]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        l2price[:,k] = block2[:,kk+4]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        peakload[:,k] = block2[:,kk+5]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        h6load[:,k] = block2[:,kk+6]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        h8load[:,k] = block2[:,kk+7]
        k = k + 1
        kk = kk + 10
    end

    k = 1
    kk = 1
    for i = 1:49
        l6load[:,k] = block2[:,kk+8]
        k = k + 1
        kk = kk + 10
    end


    k = 1
    kk = 1
    for i = 1:49
        l2load[:,k] = block2[:,kk+9]
        k = k + 1
        kk = kk + 10
    end

    InputSDDPData.price = [peakprice,h6price,h8price,l6price,l2price]
    InputSDDPData.load = [peakload,h6load,h8load,l6load,l2load]

    return InputSDDPData
end

InputSDDPData = ImportLoadPriceData(InputSDDPData, block1, numSimulation, numStage5)