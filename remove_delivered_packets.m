function runner = remove_delivered_packets(runner, delivered_ids)

if isempty(delivered_ids)
    return;
end

keep = true(1, length(runner.ownBuffer));
for k = 1:length(runner.ownBuffer)
    if any(delivered_ids == runner.ownBuffer(k).id)
        keep(k) = false;
    end
end
runner.ownBuffer = runner.ownBuffer(keep);

keep = true(1, length(runner.relayBuffer));
for k = 1:length(runner.relayBuffer)
    if any(delivered_ids == runner.relayBuffer(k).id)
        keep(k) = false;
    end
end
runner.relayBuffer = runner.relayBuffer(keep);

end