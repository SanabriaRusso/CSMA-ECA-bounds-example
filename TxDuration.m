function [Ts, load] = TxDuration(M, Nagg, Nc, Nbs, Ncr,L,MU,MS)

%802.11ac parameters
L = L * 8;
Nsc=52;

switch Nc
    case 1
        Nsc = 52;
        Nbs = 6;
        Ncr = 5/6;        
    case 2
        Nsc = 108;        
        Nbs = 6;
        Ncr = 3/4;
    case 4
        Nsc = 234;        
        Nbs = 4;
        Ncr = 3/4;
    case 8
        Nsc = 468;
        Nbs = 4;
        Ncr = 1/2;
    otherwise
        Nsc = 52*Nc;
        Nbs = 6;
        Ncr = 3/4;
end

 
SIFS = 10;
DIFS = 28;
SLOT = 9;
ASIFS = 2 * SLOT + SIFS;

T_symbol = 4;
T_PHY = 40 + 4 * (M-1);
 
L_SF = 16;
L_MH = 288;
L_MD = 16;
L_BACK = 256;
L_TAIL = 18;
 
L_DBPS = Nbs * Ncr * Nsc;
L_DBPS_ACK = Nbs * Ncr * 52; 

if(Nagg==1)
    Ts = T_PHY + fix((L_SF+(L_MH+L)+L_TAIL)/(MS*L_DBPS))*T_symbol + MU*(SIFS + T_PHY + ceil(L_BACK / L_DBPS_ACK)*T_symbol) + DIFS;    
else
    Ts = T_PHY + fix((L_SF+Nagg*(L_MD+L_MH+L)+L_TAIL)/(MS*L_DBPS))*T_symbol + MU*(SIFS + T_PHY + ceil(L_BACK / L_DBPS_ACK)*T_symbol) + DIFS;
end

Ts = ASIFS+Ts+SLOT
load = fix((L_SF+Nagg*(L_MD+L_MH+L)+L_TAIL))


end