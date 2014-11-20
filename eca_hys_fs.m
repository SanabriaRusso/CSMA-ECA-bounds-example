function [Throughput, ThroughputFitted, maxAgThroughput, JFI, JFI_fit, JFImaxAg] = eca_hys_fs(nodes, CWmin, load)

maxAg = 5;
Bd = ceil(CWmin / 2);
maxCycle = 2^maxAg * Bd;

if nodes > (2^maxAg) * Bd
    fprintf('Too many nodes\n');
    return;
end

if nodes <= Bd
    highStage = 0;
    lowStage = 0;
    nodesAtLowStage = 0;
    low = 0;
    nodesAtHighStage = nodes;
    cycleLength = Bd;
    aggregationHigh = 0;
    aggregationLow = 0;
else
    highStage = ceil(log2(nodes/Bd)); 
    cycleLength = 2^highStage * Bd;
    nodesAtHighStage = nodes - (cycleLength - nodes);
    nodesAtLowStage = nodes - nodesAtHighStage;
    aggregationHigh = highStage;
    lowStage = max(highStage - 1, 0);
    if lowStage == 0
        aggregationLow = 0;
    else
        aggregationLow = lowStage;
    end;
end;

%Fixing the times according to Francesco's 
SLOT_TIME = 9; %was 16
PACKET_PAYLOAD = load;

%Frame duration according to Channel.hh in the simulator
LDBPS = 256;
TSYM = 4;
blockAckframeduration = 32 + fix((16 + 256 + 6)/LDBPS) * TSYM;

dataframedurationHighStage = duration80211n(PACKET_PAYLOAD,aggregationHigh,blockAckframeduration);
TsHigh = dataframedurationHighStage;


%Transmission duration for nodes at low backoff stage according to
%Channel.hh in the simulator
dataframedurationLowStage = duration80211n(PACKET_PAYLOAD,aggregationLow,blockAckframeduration);
TsLow = dataframedurationLowStage;

high = (2^aggregationHigh)*PACKET_PAYLOAD*8 / (TsHigh * nodesAtHighStage + (2 * nodesAtLowStage * TsLow) + SLOT_TIME*(cycleLength - nodes));
low = (2^aggregationLow)*PACKET_PAYLOAD*8 / (TsLow * nodesAtLowStage + (TsHigh *  nodesAtHighStage/2));
%low = (2^aggregationLow)*PACKET_PAYLOAD*8 / (TsLow * nodesAtLowStage + (TsHigh *  nodesAtHighStage/2)+ SLOT_TIME*((2^lowStage * Bd) - nodes));

%Total throughput
Throughput = double((high*(nodesAtHighStage) + low*(nodesAtLowStage))*1e6);


%Using the maximum backoff stage for the cycle length and aggregation
dataframedurationFit = duration80211n(PACKET_PAYLOAD,maxAg,blockAckframeduration);
fit = (2^maxAg)*PACKET_PAYLOAD*8 / (dataframedurationFit * nodes + SLOT_TIME*(maxCycle - nodes));

ThroughputFitted = double((fit * nodes)*1e6);


%With maximum aggregation
dataframedurationHighStageMaxAg = duration80211n(PACKET_PAYLOAD,maxAg,blockAckframeduration);
dataframedurationLowStageMaxAg = dataframedurationHighStageMaxAg;

TsHighMaxAg = dataframedurationHighStageMaxAg;
TsLowMaxAg = dataframedurationLowStageMaxAg;

highMaxAg = (2^maxAg)*PACKET_PAYLOAD*8 / (TsHighMaxAg * nodesAtHighStage + (2 * nodesAtLowStage * TsLowMaxAg) + SLOT_TIME*(cycleLength-nodes));
lowMaxAg = (2^maxAg)*PACKET_PAYLOAD*8 / (TsLowMaxAg * nodesAtLowStage + (TsHighMaxAg *  nodesAtHighStage/2));
%lowMaxAg = (2^maxAg)*PACKET_PAYLOAD*8 / (TsLowMaxAg * nodesAtLowStage + (TsHighMaxAg *  nodesAtHighStage/2)+ SLOT_TIME*((2^lowStage * Bd) - nodes));

maxAgThroughput = double((highMaxAg*(nodesAtHighStage) + lowMaxAg*(nodesAtLowStage))*1e6);


%Computing JFI
JFI = computeJFI(nodesAtHighStage, high, nodesAtLowStage, low);
JFI_fit = computeJFI(nodes, fit, 0, 0);
JFImaxAg = computeJFI(nodesAtHighStage, highMaxAg, nodesAtLowStage, lowMaxAg);

end