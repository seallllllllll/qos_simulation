function gates = init_gates(params)

gates = struct([]);

for g = 1:params.num_gates
    gates(g).id = g;
    gates(g).position = params.gate_positions(g);
    gates(g).radius = params.gate_radius;
    gates(g).mu = params.gate_mu;

    % 已送達的 packet ID
    gates(g).delivered_ids = [];
end

end