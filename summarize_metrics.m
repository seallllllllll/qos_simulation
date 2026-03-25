function summary = summarize_metrics(metrics, ~)

summary.total_generated = metrics.total_generated;
summary.total_delivered = metrics.total_delivered;
summary.total_dropped_ttl = metrics.total_dropped_ttl;
summary.total_duplicate_blocked = metrics.total_duplicate_blocked;

summary.p1_delivery_rate = safe_div(metrics.p1_delivered, metrics.p1_generated);
summary.p2_delivery_rate = safe_div(metrics.p2_delivered, metrics.p2_generated);
summary.p3_delivery_rate = safe_div(metrics.p3_delivered, metrics.p3_generated);
summary.track_delivery_rate = safe_div(metrics.track_delivered, metrics.track_generated);

summary.avg_p1_delay = safe_mean(metrics.p1_delays);
summary.avg_p2_delay = safe_mean(metrics.p2_delays);
summary.avg_p3_delay = safe_mean(metrics.p3_delays);
summary.avg_track_delay = safe_mean(metrics.track_delays);

summary.gate_confirmation_rate = safe_div(metrics.confirmed_gate_passages, metrics.actual_gate_passages);

end

function x = safe_div(a, b)
if b == 0
    x = 0;
else
    x = a / b;
end
end

function x = safe_mean(v)
if isempty(v)
    x = 0;
else
    x = mean(v);
end
end