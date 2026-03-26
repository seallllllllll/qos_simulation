function [runners, gates, metrics] = gate_exchange(runners, gates, params, t, metrics)

for g = 1:length(gates)
    for i = 1:length(runners)

        dist = abs(runners(i).position - gates(g).position);

        if dist <= gates(g).radius

            contactTime = max(1, floor((2 * gates(g).radius) / max(runners(i).speed, 0.1)));
            maxTx = contactTime * gates(g).mu;

            uploadBuffer = [runners(i).relayBuffer, runners(i).ownBuffer];
            delivered_ids_now = [];

            txCount = 0;
            while ~isempty(uploadBuffer) && txCount < maxTx
                idx = pick_packet(uploadBuffer, params.scheduler_type);
                pkt = uploadBuffer(idx);

                if any(gates(g).delivered_ids == pkt.id)
                    uploadBuffer(idx) = [];
                    continue;
                end

                % gate 成功收到
                gates(g).delivered_ids = [gates(g).delivered_ids, pkt.id];
                delivered_ids_now = [delivered_ids_now, pkt.id];

                delay = t - pkt.genTime;
                metrics.total_delivered = metrics.total_delivered + 1;

                switch pkt.type
                    case 'P1'
                        metrics.p1_delivered = metrics.p1_delivered + 1;
                        metrics.p1_delays(end+1) = delay;
                    case 'P2'
                        metrics.p2_delivered = metrics.p2_delivered + 1;
                        metrics.p2_delays(end+1) = delay;
                    case 'P3'
                        metrics.p3_delivered = metrics.p3_delivered + 1;
                        metrics.p3_delays(end+1) = delay;
                    case 'TRACK'
                        metrics.track_delivered = metrics.track_delivered + 1;
                        metrics.track_delays(end+1) = delay;

                        source_id = pkt.sourceRunner;
                        gate_id = pkt.gateTarget;
                        if gate_id > 0 && ~runners(source_id).confirmedGate(gate_id)
                            runners(source_id).confirmedGate(gate_id) = true;
                            metrics.confirmed_gate_passages = metrics.confirmed_gate_passages + 1;
                        end
                end

                uploadBuffer(idx) = [];
                txCount = txCount + 1;
            end

            runners(i) = remove_delivered_packets(runners(i), delivered_ids_now);
        end
    end
end

end