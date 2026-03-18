function out = simulate_queue_nonpreemptive(packets, mu, policy, bufferCaps, T_end)
% packets columns:
% [arrival_time, class_id, priority, packet_id]
%
% class_id / priority:
% 1 = High, 2 = Medium, 3 = Low

serviceMean = 1 / mu;

% 三個 class queue
Q{1} = [];
Q{2} = [];
Q{3} = [];

% 統計
generated = zeros(1,3);
dropped   = zeros(1,3);
served    = zeros(1,3);
delaySum  = zeros(1,3);

% 事件索引
i = 1;
N = size(packets,1);

% server state
serverBusy = false;
t = 0;
nextDeparture = inf;
currentPkt = [];

while true
    nextArrival = inf;
    if i <= N
        nextArrival = packets(i,1);
    end

    % 下一個事件時間
    t_next = min(nextArrival, nextDeparture);

    if isinf(t_next)
        break;
    end

    t = t_next;

    %% 1) 先處理 departure
    if abs(t - nextDeparture) < 1e-12
        cls = currentPkt(2);
        served(cls) = served(cls) + 1;
        delaySum(cls) = delaySum(cls) + (t - currentPkt(1));

        serverBusy = false;
        nextDeparture = inf;
        currentPkt = [];
    end

    %% 2) 再處理 arrival（同時到達也可全部收進來）
    while i <= N && abs(packets(i,1) - t) < 1e-12
        pkt = packets(i,:);
        cls = pkt(2);
        generated(cls) = generated(cls) + 1;

        if length(Q{cls}) < bufferCaps(cls)
            Q{cls} = [Q{cls}; pkt];
        else
            dropped(cls) = dropped(cls) + 1;
        end
        i = i + 1;
    end

    %% 3) 若 server 空閒，依 policy 選下一個封包
    if ~serverBusy
        pkt = [];
        switch upper(policy)
            case 'FIFO'
                pkt = pick_fifo(Q);
            case 'PRIORITY'
                pkt = pick_priority(Q);
            otherwise
                error('Unknown policy');
        end

        if ~isempty(pkt)
            cls = pkt(2);
            % 從對應 queue 移除第一筆
            Q{cls}(1,:) = [];

            currentPkt = pkt;
            st = exprnd(serviceMean);  % exponential service time
            nextDeparture = t + st;
            serverBusy = true;
        end
    end
end

% 剩餘 queue 可視為未完成，但不算送達
avgDelay = nan(1,3);
for c = 1:3
    if served(c) > 0
        avgDelay(c) = delaySum(c) / served(c);
    end
end

lossRate = zeros(1,3);
deliveryRate = zeros(1,3);

for c = 1:3
    if generated(c) > 0
        lossRate(c) = dropped(c) / generated(c);
        deliveryRate(c) = served(c) / generated(c);
    else
        lossRate(c) = 0;
        deliveryRate(c) = 0;
    end
end

out.avgDelay = avgDelay;
out.lossRate = lossRate;
out.deliveryRate = deliveryRate;
out.generated = generated;
out.dropped = dropped;
out.served = served;
end

%% ===== helper functions =====
function pkt = pick_priority(Q)
% non-preemptive priority: High > Medium > Low
pkt = [];
for c = 1:3
    if ~isempty(Q{c})
        pkt = Q{c}(1,:);
        return;
    end
end
end

function pkt = pick_fifo(Q)
pkt = [];
bestTime = inf;
bestClass = -1;

for c = 1:3
    if ~isempty(Q{c})
        if Q{c}(1,1) < bestTime
            bestTime = Q{c}(1,1);
            bestClass = c;
        end
    end
end

if bestClass ~= -1
    pkt = Q{bestClass}(1,:);
end
end