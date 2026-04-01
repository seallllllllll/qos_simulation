categories = {'P1','P2','P3','TRACK'};

baseline2 = [0.9565, 1, 1, 1];
baseline3 = [0.9565, 1, 1, 1];
proposed  = [0.9638, 1, 1, 1];

rate_data = [baseline2; baseline3; proposed]';

figure;
bar(rate_data);
set(gca, 'XTickLabel', categories, 'FontSize', 12);
xlabel('Priority');
ylabel('Delivery Rate');
legend('FIFO (No Relay)','FIFO + Relay','QoS + Relay (Proposed)', 'Location', 'southeast');
title('Delivery Rate Comparison');
ylim([0.94 1.01]);
grid on;