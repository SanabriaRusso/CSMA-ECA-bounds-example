function throughput = eca_reference(nodes, CWmin, rate)	

	%Using 802.11g/n parameters
% 	PACKET_PAYLOAD = 8192;
%     MAC_HEADER = 272;
%     PHY_HEADER = 128;
%     ACK = 112 + PHY_HEADER;
%     CHANNEL_BITRATE = 54E6;	
% 	PROPAGATION_DELAY = 1E-6;
%     SLOT_TIME = 9E-6;
%     SIFS = 10E-6;
%     DIFS = 28E-6;
% 
%     Ts = (PHY_HEADER + MAC_HEADER + PACKET_PAYLOAD)/CHANNEL_BITRATE + SIFS + PROPAGATION_DELAY + ACK/(CHANNEL_BITRATE/2) + DIFS + PROPAGATION_DELAY
%    
    
    %Fixing the times according to Francesco's consideration of the differente PHY rates
    SLOT_TIME = 9;
    SIFS = 10;
    DIFS = 28;

    PACKET_PAYLOAD = 1470;
    ack_frame = 14;
    fcs = 4;
    data_rate = rate;
    ack_rate = data_rate;
    if rate > 24, ackrate = data_rate/2; end;

    frame = 24 + 8 + 20 + 8 + PACKET_PAYLOAD + fcs;
    
    ackframeduration = computeduration(ack_frame, ack_rate);
    dataframeduration = computeduration(frame, data_rate);
    
    Ts = dataframeduration + SIFS + ackframeduration + DIFS;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Algorithm starts here%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Bd = ceil(CWmin / 2);
	MAXSTAGE = 6;	
	
	if ((2^(MAXSTAGE))*Bd < nodes)
		fprintf('Quitting, range of nodes out of bounds\n');
		exit 0;
    end

	fprintf('***Deterministic Backoff\nBd = %d\n', Bd);
	
	cyclesToFit = nodes/Bd;
	fprintf('***Cycles: %.2f\n', cyclesToFit);
	
	base = fix(cyclesToFit);
	disrupt = cyclesToFit - base;

	%Number of users in lower backoff stages
	alpha = base*(Bd - ceil(disrupt*Bd));
	
	if base == 0
        alpha = nodes;
		alphaN = alpha;
		disrupt = 0;
	else
		alphaN = alpha / base;
    end

	fprintf('***Base: %d\n', base);

	fprintf('***Disrupt: %.3f\n', disrupt);
	
	%Nnumber of users in lower backoff stages
	fprintf('***Number of stations in lower backoff stages, Alpha: %d\n', alpha);
	
	%Number of users in an increased backoff stage
	if ((cyclesToFit > 0) && (cyclesToFit > base))
		disturbedCycles = base + 1;
		beta = disturbedCycles * ceil(disrupt*Bd);
		betaN = beta / disturbedCycles;
	else
		disturbedCycles = base;
        betaN = 0;
		beta = betaN;
    end

	fprintf('***Number of station in higher backoff stages, Beta: %d\n', beta);	
	

	%Array with the possible backoff stages
	x = 0:base;
	disruptStage = max(ceil(log2(nodes/Bd)), 0);
    if disrupt > 0
        stage = disruptStage - 1;
    else
        stage = disruptStage;
    end
    
    fprintf('***Higher backoff stage: %d\n', disruptStage);
    fprintf('******Lower backoff stage: %d\n', stage);
    
    
%     for i = x
% 		if (2^i)*Bd >= alpha
% 			fprintf('Found the lower backoff stage: ');
% 			if(i < MAXSTAGE)
% 				stage = i;
% 				disruptStage = stage + 1;
% 			else
% 				stage = MAXSTAGE;
% 				disruptStage = stage;
%             end
% 			fprintf('%d\n',int8(stage));
% 			break;
%         end
% 	end
    
    %Defining the goodput of alpha and beta nodes
	
    %baseTime is the time between two consecutive transmissions for alpha
    %nodes. That is, after all other alpha nodes have transmitted, plus
    %half the number of nodes at higher backoff stages (beta nodes); plus
    %the deterministic backoff.
    if nodes > 1
        baseTime = Ts*(alpha + (beta/2)) + SLOT_TIME*((2^stage) * Bd) 
    else
        baseTime = Ts + SLOT_TIME*((2^stage) * Bd)
    end
    
	Salpha = PACKET_PAYLOAD*8/baseTime;

	if(beta > 0)
        % Disrupt Time is the duration of two alpha node transmissions and all beta transmissions.
		% Then we add the empty slots for the expiration of the backoff

		disruptTime = Ts*(2*alpha + beta) + SLOT_TIME*((2^(disruptStage))* Bd);
		%Sbeta = (PHY_HEADER + MAC_HEADER + PACKET_PAYLOAD)/(Ts*(nodes-1)+SLOT_TIME*((2^(stage+1)*Bd)-(2*alpha+beta)));
		Sbeta = PACKET_PAYLOAD*8/disruptTime;

	else
		Sbeta = 0;
		disruptTime = 0;
    end

	fprintf('Throughput base: %e, Throughput disrupt: %e\n', Salpha, Sbeta);
	
	fprintf('Time base: %e, Time disrupt: %e\n', baseTime, disruptTime);

	throughput = (alpha*Salpha+beta*Sbeta)*1e6;

end
