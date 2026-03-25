function tf = runner_has_packet(runner, pkt_id)

tf = false;

for k = 1:length(runner.ownBuffer)
    if runner.ownBuffer(k).id == pkt_id
        tf = true;
        return;
    end
end

for k = 1:length(runner.relayBuffer)
    if runner.relayBuffer(k).id == pkt_id
        tf = true;
        return;
    end
end

end