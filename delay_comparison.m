% Data
categories = {'P1','P2','P3','TRACK'};

baseline2 = [323.9394, 390.8753, 405.9263, 245.1562];
baseline3 = [322.1136, 390.8732, 405.9455, 242.9178];
proposed  = [284.7744, 360.4125, 406.0764, 242.9225];

% Combine data (transpose for grouped bar)
delay_data = [baseline2; baseline3; proposed]';

% Plot
figure;
bar(delay_data);

% Axis settings
set(gca, 'XTickLabel', categories, 'FontSize', 12);
xlabel('Priority');
ylabel('Average Delay (s)');

% Legend and title
legend('FIFO (No Relay)','FIFO + Relay','QoS + Relay (Proposed)', 'Location', 'northwest');
title('Average Delivery Delay Comparison');

% Grid
grid on;

% Optional: set figure size
set(gcf, 'Position', [100, 100, 800, 500]);

% Save figure (optional)
saveas(gcf, 'average_delay_comparison.png');