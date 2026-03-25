function pkt = create_packet(pkt_id, sourceRunner, carrierRunner, priority, type, genTime, ttl, gateTarget)

if nargin < 8
    gateTarget = -1;
end

pkt.id = pkt_id;
pkt.sourceRunner = sourceRunner;
pkt.carrierRunner = carrierRunner;
pkt.priority = priority;       % 1 / 2 / 3
pkt.type = type;               % 'P1','P2','P3','TRACK'
pkt.genTime = genTime;
pkt.ttl = ttl;
pkt.expireTime = genTime + ttl;
pkt.hopCount = 0;
pkt.copyCount = 1;
pkt.delivered = false;
pkt.gateTarget = gateTarget;
end