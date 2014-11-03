function duration = duration80211n(load, aggregation, BACKduration)
    LDBPS = 256;
    TSYM = 4;
    SLOT_TIME = 9; %was 16
    SIFS = 10; %was 9
    DIFS = 28; %was 34

    duration = 32 + ceil((16 + (2^aggregation) * (32 + (load*8) + 288) + 6) / LDBPS) * TSYM + SIFS + BACKduration + DIFS + SLOT_TIME;
end