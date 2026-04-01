function params = init_marathon_params()

params.race_length = 21.0975 * 1000;   % meters
params.dt = 1.0;                       % second
params.T_end = 3 * 3600;               % 3 hours

params.scheduler_type = 'FIFO';   % 'PRIORITY' or 'FIFO'
params.relay_enable = false;           % true or false

params.num_runners = 240;
params.gate_positions = [0, 3500, 7000, 10500, 14000, 17500, 21097.5];
params.num_gates = length(params.gate_positions);
params.gate_radius = 20;               % meters
params.gate_mu = 0.5;                    % packets/sec per runner contact
params.peer_range = 8;                 % meters
% Priority generation
params.lambda_p1 = 5e-5;               % rare event per sec
params.lambda_p2 = 2e-4;               % abnormal event per sec
params.p3_period = 15;                 % every 15 sec
params.track_periodic_enable = false;  % track 改由 gate entry event 觸發


% TTL
params.ttl_p1 = 20 * 60;               % 20 min
params.ttl_p2 = 30 * 60;               % 30 min
params.ttl_p3 = 60 * 60;               % 60 min
params.ttl_track = 30 * 60;            % 30 min

% Relay
params.max_hops_p1 = 3;
params.max_copies_p1 = 3;

% Buffer sizes
params.max_own_buffer = 100;
params.max_relay_buffer = 100;

% Runner speed distribution (m/s)
params.speed_mean = 3.2;
params.speed_std = 0.5;
params.speed_min = 2.0;
params.speed_max = 5.5;

end