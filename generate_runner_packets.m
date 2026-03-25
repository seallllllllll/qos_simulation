function [runners, metrics] = generate_runner_packets(runners, params, t, metrics)

persistent global_pkt_id
if isempty(global_pkt_id)
    global_pkt_id = 0;
end

for i = 1:length(runners)

    % -------- P1 --------
    if rand < params.lambda_p1 * params.dt
        global_pkt_id = global_pkt_id + 1;
        pkt = create_packet(global_pkt_id, runners(i).id, runners(i).id, ...
            1, 'P1', t, params.ttl_p1);

        if length(runners(i).ownBuffer) < params.max_own_buffer
            runners(i).ownBuffer = [runners(i).ownBuffer, pkt];
            metrics.total_generated = metrics.total_generated + 1;
            metrics.p1_generated = metrics.p1_generated + 1;
        end
    end

    % -------- P2 --------
    if rand < params.lambda_p2 * params.dt
        global_pkt_id = global_pkt_id + 1;
        pkt = create_packet(global_pkt_id, runners(i).id, runners(i).id, ...
            2, 'P2', t, params.ttl_p2);

        if length(runners(i).ownBuffer) < params.max_own_buffer
            runners(i).ownBuffer = [runners(i).ownBuffer, pkt];
            metrics.total_generated = metrics.total_generated + 1;
            metrics.p2_generated = metrics.p2_generated + 1;
        end
    end

    % -------- P3 periodic --------
    if mod(t, params.p3_period) == 0
        global_pkt_id = global_pkt_id + 1;
        pkt = create_packet(global_pkt_id, runners(i).id, runners(i).id, ...
            3, 'P3', t, params.ttl_p3);

        if length(runners(i).ownBuffer) < params.max_own_buffer
            runners(i).ownBuffer = [runners(i).ownBuffer, pkt];
            metrics.total_generated = metrics.total_generated + 1;
            metrics.p3_generated = metrics.p3_generated + 1;
        end
    end

    % -------- TRACK by first entering gate coverage --------
    for g = 1:params.num_gates
        dist = abs(runners(i).position - params.gate_positions(g));

        if dist <= params.gate_radius && ~runners(i).seenGate(g)
            runners(i).seenGate(g) = true;
            metrics.actual_gate_passages = metrics.actual_gate_passages + 1;

            global_pkt_id = global_pkt_id + 1;
            pkt = create_packet(global_pkt_id, runners(i).id, runners(i).id, ...
                3, 'TRACK', t, params.ttl_track, g);

            if length(runners(i).ownBuffer) < params.max_own_buffer
                runners(i).ownBuffer = [runners(i).ownBuffer, pkt];
                metrics.total_generated = metrics.total_generated + 1;
                metrics.track_generated = metrics.track_generated + 1;
            end
        end
    end
end

end