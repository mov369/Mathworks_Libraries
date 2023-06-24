function generateMsgs()
% generateMsgs Creates and transmits CAN messages for demo purposes.
%
%   generateMsgs periodically transmits multiple CAN messages at various
%   periodic rates with changing message data.
%

% Copyright 2008-2016 The MathWorks, Inc.

    % Create the messages to send using the canMessage function. The 
    % identifier, an indication of standard or extended type, and the data
    % length is given for each message.
    msgTx100 = canMessage(100, false, 0);
    msgTx200 = canMessage(200, false, 2);
    msgTx400 = canMessage(400, false, 4);
    msgTx600 = canMessage(600, false, 6);
    msgTx800 = canMessage(800, false, 8); 

    % Create a CAN channel on which to transmit.
    txCh = canChannel('MathWorks', 'Virtual 1', 1);

    % Register each message on the channel at a specified periodic rate.
    transmitPeriodic(txCh, msgTx100, 'On', 0.500);
    transmitPeriodic(txCh, msgTx200, 'On', 0.250);
    transmitPeriodic(txCh, msgTx400, 'On', 0.125);
    transmitPeriodic(txCh, msgTx600, 'On', 0.050);
    transmitPeriodic(txCh, msgTx800, 'On', 0.025);
    
    % Start the CAN channel.
    start(txCh);
    
    % Run for several seconds incrementing the message data regularly.
    for ii = 1:50
        % Increment the message data bytes.
        msgTx200.Data = msgTx200.Data + 1;
        msgTx400.Data = msgTx400.Data + 1;
        msgTx600.Data = msgTx600.Data + 1;
        msgTx800.Data = msgTx800.Data + 1;
        
        % Wait for a time period.
        pause(0.100);
    end

    % Stop the CAN channel.
    stop(txCh);
end
