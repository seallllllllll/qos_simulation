function packets = generate_periodic_packets(numDevices, period, T_end, classId, priority)
% 每台裝置固定週期送封包，可加小抖動避免完全重疊
arrivals = [];

for dev = 1:numDevices
    offset = rand * period;  % 隨機起始相位
    t = offset:period:T_end;
    arrivals = [arrivals; t(:)]; %#ok<AGROW>
end

arrivals = sort(arrivals);
n = length(arrivals);

packets = [arrivals(:), ...
           classId * ones(n,1), ...
           priority * ones(n,1), ...
           (1:n)'];
end