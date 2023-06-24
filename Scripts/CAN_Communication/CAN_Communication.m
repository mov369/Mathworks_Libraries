%% VIEW AVAILABLE CAN/CAN FD CHANNELS
canChannelList

%%Create a CAN Channel (canChannel) to receive messages by specifying the
%%vendor name, device name, and device channel index
rxCh = canChannel("Mathworks","Virtual 1", 2);
%% *get()* command shows information on all channel properties in the command window
get(rxCh)
%%  *start()* command sets the channel online
start(rxCh);
%% TRANSMIT MESSAGES
% *type filename* displays the contents of the specified file in the MATLAB® Command Window.
type generateMsgs
% generateMsgs function creates CAN messages using canMessage and transmits them using transmit 
% at various periodic rates. It generates traffic on the CAN bus for demonstration purposes.
% run the generateMsgs function to transmit messages for the example
generateMsgs();
%% RECEIVE MESSAGES
% Once generateMsgs completes, receive all available messages from the
% channel using the *receive()* function
rxMsg = receive(rxCh, Inf, "OutputFormat","timetable");
% *head* extracts the first few rows of received messages for preview
head(rxMsg)
%% STOPPING THE CHANNEL
% *stop()* sets the channel offline
stop(rxCh);
%% ANALYSE RECEIVED MESSAGES
plot(rxMsg.Time, rxMsg.ID, "x")
ylim([0 2047])
xlabel("Timestamp")
ylabel("CAN Identifier")