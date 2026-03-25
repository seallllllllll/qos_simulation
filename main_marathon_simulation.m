clc; clear; close all;
rng(42);

params  = init_marathon_params();
runners = init_runners(params);
gates   = init_gates(params);

metrics.total_generated = 0;
metrics.total_delivered = 0;
metrics.total_dropped_ttl = 0;
metrics.total_duplicate_blocked = 0;

metrics.p1_generated = 0;
metrics.p2_generated = 0;
metrics.p3_generated = 0;
metrics.track_generated = 0;

metrics.p1_delivered = 0;
metrics.p2_delivered = 0;
metrics.p3_delivered = 0;
metrics.track_delivered = 0;

metrics.p1_delays = [];
metrics.p2_delays = [];
metrics.p3_delays = [];
metrics.track_delays = [];

metrics.actual_gate_passages = 0;
metrics.confirmed_gate_passages = 0;

t_vec = 0:params.dt:params.T_end;

for ti = 1:length(t_vec)
    t = t_vec(ti);

    % 1) 更新位置
    runners = update_runner_positions(runners, params, t);

    % 2) 產生封包
    [runners, metrics] = generate_runner_packets(runners, params, t, metrics);

    % 3) 跑者間 relay（只傳 P1）
    [runners, metrics] = peer_relay_exchange(runners, params, metrics);

    % 4) 進 gate 上傳
    [runners, gates, metrics] = gate_exchange(runners, gates, params, t, metrics);

    % 5) 移除 TTL 過期封包
    [runners, metrics] = remove_expired_packets(runners, t, metrics);
end

summary = summarize_metrics(metrics, params);

disp('===== Marathon Simulation Summary =====');
disp(summary);

figure;
bar([summary.p1_delivery_rate, summary.p2_delivery_rate, summary.p3_delivery_rate, summary.track_delivery_rate]);
set(gca, 'XTickLabel', {'P1','P2','P3','TRACK'});
ylabel('Delivery Rate');
title('Delivery Rate by Priority');
grid on;

figure;
bar([summary.avg_p1_delay, summary.avg_p2_delay, summary.avg_p3_delay, summary.avg_track_delay]);
set(gca, 'XTickLabel', {'P1','P2','P3','TRACK'});
ylabel('Average Delay (s)');
title('Average Delivery Delay');
grid on;