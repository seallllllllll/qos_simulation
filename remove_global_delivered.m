function buffer = remove_global_delivered(buffer, global_delivered_ids)

if isempty(buffer) || isempty(global_delivered_ids)
    return;
end

ids = [buffer.id];
keep = ~ismember(ids, global_delivered_ids);
buffer = buffer(keep);

end