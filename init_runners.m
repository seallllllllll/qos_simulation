function runners = init_runners(params)

runners = struct([]);

for i = 1:params.num_runners
    speed = params.speed_mean + params.speed_std * randn;
    speed = min(max(speed, params.speed_min), params.speed_max);

    runners(i).id = i;
    runners(i).position = 0;
    runners(i).speed = speed;
    runners(i).finished = false;

    runners(i).ownBuffer = [];
    runners(i).relayBuffer = [];

    runners(i).seenGate = false(1, params.num_gates);       % physical passage
    runners(i).confirmedGate = false(1, params.num_gates);  % ACKed by gate
end

end