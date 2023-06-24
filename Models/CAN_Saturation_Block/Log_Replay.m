%% Log and Replay CAN Messages
% This example shows you how to log and replay CAN messages using MathWorks
% Virtual CAN channels in Simulink(R). You can update this model to 
% connect to supported hardware on your system.

% Copyright 2011-2018 The MathWorks, Inc.

%%
% Load the saved CAN message from |sourceMsgs.mat| file from the examples
% folder. The file contains CAN messages representing a 90 second
% drive cycle around a test track. 
%
% Convert these messages to a format compatible with the CAN Replay block
% and save it to a separate file.
load Mule_log.mat
canMsgs = canMessageReplayBlockStruct(canExplorerMsgs_2023_Jun_15_154055);
save DriveReplay.mat canMsgs
whos

%% CAN Replay Model 
% This model contains:
%
% * A CAN Replay block that transmits to |MathWorks Virtual Channel 1|. 
% * A CAN Receive block that receives the messages on a CAN network,
% through |MathWorks Virtual Channel 2|. 
%
% The CAN Receive block is configured to block all extended IDs and allow
% only the |WheelSpeed| message with the standard ID |1200| to pass.
%
% <<../demoVNTSL_CANReplayAndLog_Model1.png>>
%

%%
% The Wheel Speeds subsystem unpacks the wheel speed information from
% the received CAN messages and plots them to a scope. The subsystem also 
% logs the messages to a file.
%
% <<../demoVNTSL_CANReplayAndLog_Model2.png>>
%

%% Visualize Wheel Speed Information
% The plot shows the wheel speed for all wheels for the duration of the
% test drive.
% 
% <<../demoVNTSL_CANReplayAndLog_Scope.png>>
%

%% Load the Logged Message File
% The CAN Log block creates a unique file each time you run the model. Use
% |dir| in the MATLAB Command Window to find the latest log file. 
dir WheelSpeeds*.mat
load WheelSpeeds_2011-May-03_020634.mat
whos

%% Convert Logged Messages
% Use |canMessageTimetable| to convert messages logged during the simulation to
% a timetable that you can use in the command window. 
%
% To access message signals directly, use the appropriate database file in
% the conversion along with |canSignalTimetable|.
db = canDatabase('VehicleInfo.dbc');
wheelSpeedMsgTimetable = canMessageTimetable(outMsgs, db);
wheelSpeedMsgTimetable(1:15, :)
wheelSpeedSignals = canSignalTimetable(wheelSpeedMsgTimetable);
wheelSpeedSignals(1:15, :)

%%
% MathWorks CAN Virtual channels were used for this example. You can however
% connect your models to other supported hardware.
