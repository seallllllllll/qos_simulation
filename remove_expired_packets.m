function [runners, metrics] = remove_expired_packets(runners, t, metrics)

for i = 1:length(runners)

    keep = true(1, length(runners(i).ownBuffer));
    for k = 1:length(runners(i).ownBuffer)
        if runners(i).ownBuffer(k).expireTime <= t
            keep(k) = false;
            metrics.total_dropped_ttl = metrics.total_dropped_ttl + 1;
        end
    end
    runners(i).ownBuffer = runners(i).ownBuffer(keep);

    keep = true(1, length(runners(i).relayBuffer));
    for k = 1:length(runners(i).relayBuffer)
        if runners(i).relayBuffer(k).expireTime <= t
            keep(k) = false;
            metrics.total_dropped_ttl = metrics.total_dropped_ttl + 1;
        end
    end
    runners(i).relayBuffer = runners(i).relayBuffer(keep);
end

end