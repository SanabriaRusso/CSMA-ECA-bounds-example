function jfi = computeJFI(nodesAtHighStage, high, nodesAtLowStage, low)

    rates = 1:nodesAtHighStage + nodesAtLowStage;
    
    ratesHigh = 1:nodesAtHighStage;
    
    for i = ratesHigh
        ratesHigh(i) = high;
    end;
    
    if nodesAtLowStage ~= 0
        ratesLow = 1:nodesAtLowStage;
        for j = ratesLow
            ratesLow(j) = low;
        end;
    
    else
        ratesLow = 0;
    end;
    
    rates = horzcat(ratesHigh, ratesLow);
    
    jfi_num = (sum(rates))^2;
    jfi_denom = (nodesAtHighStage + nodesAtLowStage)*sum(rates.^2);
    
    jfi = jfi_num / jfi_denom;
    
end