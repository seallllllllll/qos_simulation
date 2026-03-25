function [runners, metrics] = peer_relay_exchange(runners, params, metrics)

for i = 1:length(runners)-1
    for j = i+1:length(runners)

        if abs(runners(i).position - runners(j).position) <= params.peer_range

            % i -> j
            [runners(j), metrics] = relay_from_one_to_one(runners(i), runners(j), params, metrics);

            % j -> i
            [runners(i), metrics] = relay_from_one_to_one(runners(j), runners(i), params, metrics);
        end
    end
end

end

function [dstRunner, metrics] = relay_from_one_to_one(srcRunner, dstRunner, params, metrics)

candidatePkts = [srcRunner.ownBuffer, srcRunner.relayBuffer];

for k = 1:length(candidatePkts)
    pkt = candidatePkts(k);

    if ~strcmp(pkt.type, 'P1')
        continue;
    end

    if pkt.hopCount >= params.max_hops_p1
        continue;
    end

    if pkt.copyCount >= params.max_copies_p1
        continue;
    end

    if runner_has_packet(dstRunner, pkt.id)
        metrics.total_duplicate_blocked = metrics.total_duplicate_blocked + 1;
        continue;
    end

    if length(dstRunner.relayBuffer) >= params.max_relay_buffer
        continue;
    end

    newPkt = pkt;
    newPkt.carrierRunner = dstRunner.id;
    newPkt.hopCount = pkt.hopCount + 1;
    newPkt.copyCount = pkt.copyCount + 1;

    dstRunner.relayBuffer = [dstRunner.relayBuffer, newPkt];
end

end