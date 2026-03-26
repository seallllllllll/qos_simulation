function idx = pick_packet(buffer, scheduler_type)

if isempty(buffer)
    idx = [];
    return;
end

switch upper(scheduler_type)
    case 'FIFO'
        % 最早進 buffer / 最早生成的先送
        genTimes = [buffer.genTime];
        [~, idx] = min(genTimes);

    case 'PRIORITY'
        idx = pick_packet_by_priority(buffer);

    otherwise
        error('Unknown scheduler_type: %s', scheduler_type);
end

end