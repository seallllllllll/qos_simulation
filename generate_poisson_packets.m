function packets = generate_poisson_packets(lambda, T_end, classId, priority)
% packets columns:
% [arrival_time, class_id, priority, packet_id]

if lambda <= 0
    packets = zeros(0,4);
    return;
end

t = 0;
k = 0;
arrivals = [];

while true
    dt = exprnd(1/lambda);   % exponential inter-arrival
    t = t + dt;
    if t > T_end
        break;
    end
    k = k + 1;
    arrivals(k,1) = t; %#ok<AGROW>
end

n = length(arrivals);
packets = [arrivals(:), ...
           classId * ones(n,1), ...
           priority * ones(n,1), ...
           (1:n)'];
end