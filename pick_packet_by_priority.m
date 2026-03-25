function idx = pick_packet_by_priority(buffer)

if isempty(buffer)
    idx = [];
    return;
end

best_idx = 1;

for k = 2:length(buffer)
    a = buffer(k);
    b = buffer(best_idx);

    if a.priority < b.priority
        best_idx = k;
    elseif a.priority == b.priority
        if a.genTime < b.genTime
            best_idx = k;
        end
    end
end

idx = best_idx;
end