function duration = duration80211n(load, aggregation, BACKduration)
    LDBPS = 256;
    TSYM = 4;
    SLOT_TIME = 16; %was 9
    SIFS = 9; %was 10
    DIFS = 34; %was 28

    duration = 32 + fix((16 + (2^aggregation) * (32 + (load*8) + 288) + 6) / LDBPS) * TSYM + SIFS + BACKduration + DIFS + SLOT_TIME;
    


end