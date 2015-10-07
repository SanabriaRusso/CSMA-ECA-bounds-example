function exportData(nodes, CWmin, load)

    x = 1:nodes;
    throughput = zeros(length(x));
    throughputFitted = zeros(length(x));
    maxAgThroughput = zeros(length(x));
    jfi = zeros(length(x));
    jfi_fit = zeros(length(x));
    jfimaxAg = zeros(length(x));

    for i = x
        [throughput(i), throughputFitted(i), maxAgThroughput(i), jfi(i), jfi_fit(i), jfimaxAg(i)] = eca_hys_fs(i, CWmin, load);
    end
    
    fileID = fopen('throughputModel-TON.txt', 'w');
    fprintf(fileID, '#1. nodeID, 2. throughput, 3. jfi, 4. throughputfit, 5. jfi_fit, 6. maxAgThroughput, 7. jfi_maxAg\n');
    
    for i = x
        fprintf(fileID, '%d %e %e %e %e %e %e\n', i, throughput(i), jfi(i), throughputFitted(i), jfi_fit(i), maxAgThroughput(i), jfimaxAg(i));   
    end
    
    fclose(fileID);

end