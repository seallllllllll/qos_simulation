clc; clear; close all;

%% =========================
%  QoS-based Smart Healthcare Transmission
%  Non-preemptive priority single-server queue
%% =========================

% 模擬時間
T_end = 100;   % seconds

% 裝置數量情境（依研究計畫）
device_list = [10 50 100];

% 服務能力（server rate, packets/sec）
% 可理解為 O-RAN 抽象化 scheduler + uplink server 的處理率
mu = 120;   % 你可自行調整，需確保總負載 < 1

% 每種資料每台裝置的生成參數
% High: Poisson arrival rate per device
lambda_high_per_dev = 0.08;  % ECG alert / sec / device

% Medium: periodic generation interval per device
T_medium = 1.0;              % Heart Rate 每秒1包

% Low: Poisson arrival rate per device
lambda_low_per_dev = 0.2;    % Health Log / sec / device

% 緩衝區大小（用來觀察 packet loss）
buffer_cap_high = 100;
buffer_cap_med  = 100;
buffer_cap_low  = 100;

% 是否啟用 QoS
policy_set = {'FIFO', 'PRIORITY'};

results = [];

for p = 1:length(policy_set)
    policy = policy_set{p};

    for d = 1:length(device_list)
        numDevices = device_list(d);

        % 聚合流量
        lambda_high = numDevices * lambda_high_per_dev;
        lambda_low  = numDevices * lambda_low_per_dev;

        % 產生封包事件
        pkts_high = generate_poisson_packets(lambda_high, T_end, 1, 1);   % class=1
        pkts_med  = generate_periodic_packets(numDevices, T_medium, T_end, 2, 2);
        pkts_low  = generate_poisson_packets(lambda_low, T_end, 3, 3);    % class=3

        % 合併
        packets = [pkts_high; pkts_med; pkts_low];
        packets = sortrows(packets, 1);  % 依 arrival time 排序

        % 執行模擬
        out = simulate_queue_nonpreemptive( ...
            packets, mu, policy, ...
            [buffer_cap_high, buffer_cap_med, buffer_cap_low], T_end);

        % 儲存結果
        row.policy = string(policy);
        row.devices = numDevices;

        row.lat_high = out.avgDelay(1);
        row.lat_med  = out.avgDelay(2);
        row.lat_low  = out.avgDelay(3);

        row.loss_high = out.lossRate(1);
        row.loss_med  = out.lossRate(2);
        row.loss_low  = out.lossRate(3);

        row.cdr_high = out.deliveryRate(1); % critical packet delivery rate

        results = [results; struct2table(row)];
    end
end

disp(results);

%% 畫圖：高優先級平均延遲
figure;
hold on;
for p = 1:length(policy_set)
    idx = strcmp(results.policy, policy_set{p});
    plot(results.devices(idx), results.lat_high(idx), '-o', 'LineWidth', 1.8);
end
xlabel('Number of Devices');
ylabel('Average Latency of High Priority (s)');
legend(policy_set, 'Location', 'northwest');
title('High Priority Average Latency Comparison');
grid on;

%% 畫圖：critical packet delivery rate
figure;
hold on;
for p = 1:length(policy_set)
    idx = strcmp(results.policy, policy_set{p});
    plot(results.devices(idx), results.cdr_high(idx), '-s', 'LineWidth', 1.8);
end
xlabel('Number of Devices');
ylabel('Critical Packet Delivery Rate');
legend(policy_set, 'Location', 'southwest');
title('Critical Packet Delivery Rate Comparison');
grid on;