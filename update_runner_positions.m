function runners = update_runner_positions(runners, params, ~)

for i = 1:length(runners)
    if ~runners(i).finished
        runners(i).position = runners(i).position + runners(i).speed * params.dt;

        if runners(i).position >= params.race_length
            runners(i).position = params.race_length;
            runners(i).finished = true;
        end
    end
end

end