%% LOAD THE TEXT.LOG FILE 
% Replace by the log file of interest.
% (Creates a 1 cell variable that holds the log file location) 
filename = 'C:\Users\maxju\Documents\Customer Support\Nagoya University\command_from _pc_log\candump-2023-05-08_104058.log';
%filename = 'C:\Users\maxju\Documents\Customer Support\Nagoya University\command_from _pc_log\candump-2023-05-08_103847.log';
%% READ COLUMNS OF DATA AS TEXT
% (Creates a 1 cell variable that holds the formatting information)
% For information, see the TEXTSCAN documentation
formatSpec = '%*7s%11s%*1s%5s%4s%*1s%2s%2s%2s%2s%2s%2s%2s%s%[^\n\r]';
%% OPEN TEXT FILE
fileID = fopen(filename,'r');
%% READ COLUMNS OF DATA ACCORDING TO THE FORMAT
% This call is based on the structure of the file used to generate this code. 
% If an error occurs for a different file, then filename is pointing to the
% wrong address.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);
%% REMOVE WHITE SPACE AROUND ALL CELL COLUMNS.
dataArray{4} = strtrim(dataArray{4});
dataArray{5} = strtrim(dataArray{5});
dataArray{6} = strtrim(dataArray{6});
dataArray{7} = strtrim(dataArray{7});
dataArray{8} = strtrim(dataArray{8});
dataArray{9} = strtrim(dataArray{9});
dataArray{10} = strtrim(dataArray{10});
dataArray{11} = strtrim(dataArray{11});
%% CLOSE THE TEXT FILE.
fclose(fileID);
%% CONVERT THE CONTENTS OF COLUMNS CONTAINING NUMERIC TEXT TO NUMBERS & REPLACE NON-NUMERIC TEXT WITH NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3]
    % Converts text in the input cell array to numbers. Replaced non-numeric text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
%% SPLIT DATA INTO NUMERIC AND STRING COLUMNS.
rawNumericColumns = raw(:, [1,2,3]);
rawStringColumns = string(raw(:, [4,5,6,7,8,9,10,11]));
%% REPLACE NON-NUMERIC CELLS WITH NaN.
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
%% CREATE OUTPUT VARIABLE.
candump = table;
candump.Time = cell2mat(rawNumericColumns(:, 1));
candump.Bus = cell2mat(rawNumericColumns(:, 2));
candump.Message = cell2mat(rawNumericColumns(:, 3));
candump.Byte0 = rawStringColumns(:, 1);
candump.Byte1 = rawStringColumns(:, 2);
candump.Byte2 = rawStringColumns(:, 3);
candump.Byte3 = rawStringColumns(:, 4);
candump.Byte4 = rawStringColumns(:, 5);
candump.Byte5 = rawStringColumns(:, 6);
candump.Byte6 = rawStringColumns(:, 7);
candump.Byte7 = rawStringColumns(:, 8);
%% CLEAR TEMPORARY VARIABLES
clearvars formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R;
%% CONVERT BYTE STRINGS TO NUMBERS (NOT NEEDED AS HEX2DEC NEEDS STRINGS).
%candump.Byte0=categorical(candump.Byte0)
%candump.Byte1=categorical(candump.Byte1)
%candump.Byte2=categorical(candump.Byte2)
%candump.Byte3=categorical(candump.Byte3)
%candump.Byte4=categorical(candump.Byte4)
%candump.Byte5=categorical(candump.Byte5)
%candump.Byte6=categorical(candump.Byte6)
%candump.Byte7=categorical(candump.Byte7)
%% CONVERT HEX BYTE STRINGS TO DECIMAL NUMBERS.
% each eteration of hexStr ->D -> candump converts a selected byte string into a decimal number, loading it into the candump.
% Clears the hexStr and D after.
hexStr=(candump.Byte0);
D=hex2dec(hexStr);
candump.Byte0=D;

hexStr=(candump.Byte1);
D=hex2dec(hexStr);
candump.Byte1=D;

hexStr=(candump.Byte2);
D=hex2dec(hexStr);
candump.Byte2=D;

hexStr=(candump.Byte3);
D=hex2dec(hexStr);
candump.Byte3=D;

hexStr=(candump.Byte4);
D=hex2dec(hexStr);
candump.Byte4=D;

hexStr=(candump.Byte5);
D=hex2dec(hexStr);
candump.Byte5=D;

hexStr=(candump.Byte6);
D=hex2dec(hexStr);
candump.Byte6=D;

hexStr=(candump.Byte7);
D=hex2dec(hexStr);
candump.Byte7=D;

clearvars hexStr D; 
%% HEX TO BINARY.
%{
hexStr=(candump.Byte0)
D=dec2bin(hexStr)
candump.Byte0=D

hexStr=(candump.Byte1)
D=dec2bin(hexStr)
candump.Byte1=D

hexStr=(candump.Byte2)
D=dec2bin(hexStr)
candump.Byte2=D

hexStr=(candump.Byte3)
D=dec2bin(hexStr)
candump.Byte3=D

hexStr=(candump.Byte4)
D=dec2bin(hexStr)
candump.Byte4=D

hexStr=(candump.Byte5)
D=dec2bin(hexStr)
candump.Byte5=D

hexStr=(candump.Byte6)
D=dec2bin(hexStr)
candump.Byte6=D

hexStr=(candump.Byte7)
D=dec2bin(hexStr)
candump.Byte7=D

clearvars hexStr D;
%}
%% SPLIT CAN0_private AND CAN1_private INTO SEPARATE TABLES.
can0_customer = candump;
toDelete=can0_customer.Bus>0;
can0_customer(toDelete,:)=[];

can1_private = candump;
toDelete=can1_private.Bus<1;
can1_private(toDelete,:)=[];

clearvars toDelete;
%% MESSAGE EXTRACTION.
% Extracting Message GCU_B_Customer_Control_1 (x114)
Message_GCU_B_Customer_Control_1=can1_private;
toDelete=Message_GCU_B_Customer_Control_1.Message~=114;
Message_GCU_B_Customer_Control_1(toDelete,:)=[];
clearvars toDelete;

% Extracting Message SCU_A_Data_1_Control (x20)
Message_SCU_A_Data_1_Control=can1_private;
toDelete=Message_SCU_A_Data_1_Control.Message~=20;
Message_SCU_A_Data_1_Control(toDelete,:)=[];
clearvars toDelete;

% Extracting Message SCU_AB_Control_B (x70)
Message_SCU_AB_Control_B=can1_private;
toDelete=Message_SCU_AB_Control_B.Message~=70;
Message_SCU_AB_Control_B(toDelete,:)=[];
clearvars toDelete;

% Extracting Message GCU_A_Data_1 (x101)
Message_GCU_A_Data_1 = can1_private;
toDelete = Message_GCU_A_Data_1.Message~=101;
Message_GCU_A_Data_1(toDelete,:)=[];
clearvars toDelete;

% Extracting Message GCU_B_Data_2 (x112)
Message_GCU_B_Data_2 = can1_private;
toDelete = Message_GCU_B_Data_2.Message~=112;
Message_GCU_B_Data_2(toDelete,:)=[];
clearvars toDelete;
%% SIGNAL EXTRACTION.
% Extracting Signal Steer_Angle_1_Control
Steer_Angle_1_Control=Message_SCU_A_Data_1_Control;
Steer_Angle_1_Control(:,[6,7,8,9,10,11])=[];

% Extracting Signal Steer_Angle_2
Steer_Angle_2 = Message_GCU_A_Data_1;
Steer_Angle_2(:,[6,7,8,9,10,11])=[];

% Extracting Signal Steer_Request
Steer_Request = Message_GCU_B_Customer_Control_1;
Steer_Request(:,[4,5,7,8,9,10,11])=[];

% Extracting Automation signals (Torque & Steer Automation Granted)
Automation = Message_SCU_AB_Control_B;
Automation(:,[4,5,6,8,9,10,11])=[];

% Extracting Signal Steer_Target
Steer_Target = Message_SCU_AB_Control_B;
Steer_Target(:,[4,5,7,8,9,10,11])=[];

% Extracting Steer_Angle_1_Monitor
Steer_Angle_1_Monitor = Message_GCU_B_Data_2;
Steer_Angle_1_Monitor(:,[6,7,8,9,10,11])=[];
%% INTERPRETING THE SIGNALS AS PER PRIVATE.DBC (Byte Order, 2's Complement, Factor)
%STEER_ANGLE_1_CONTROL
%Combining Byte0 and Byte1 of of Steer_Angle_1_Control signal
%And then flip the sign for values over 3276.7 for Steer_Angle_1_Control signal
Steer_Angle_1_Control.Actual = ((Steer_Angle_1_Control.Byte1*256)+Steer_Angle_1_Control.Byte0);
h=height(Steer_Angle_1_Control);
for i=1:h
    if Steer_Angle_1_Control{i,"Actual"} > 32767
        Steer_Angle_1_Control{i,"Actual"} = Steer_Angle_1_Control{i,"Actual"}-65536;
    end
end
for i=1:h
    Steer_Angle_1_Control{i,"Actual"} = Steer_Angle_1_Control{i,"Actual"}/10;
end
clearvars h;

%STEER_ANGLE_1_MONITOR
%Combining Byte0 and Byte1 of of Steer_Angle_1_Control signal
%And then flip the sign for values over 3276.7 for Steer_Angle_1_Control signal
Steer_Angle_1_Monitor.Actual = ((Steer_Angle_1_Monitor.Byte1*256)+Steer_Angle_1_Monitor.Byte0);
h=height(Steer_Angle_1_Monitor);
for i=1:h
    if Steer_Angle_1_Monitor{i,"Actual"} > 32767
        Steer_Angle_1_Monitor{i,"Actual"} = Steer_Angle_1_Monitor{i,"Actual"}-65536;
    end
end
for i=1:h
    Steer_Angle_1_Monitor{i,"Actual"} = Steer_Angle_1_Monitor{i,"Actual"}/10;
end
clearvars h;

%STEER_ANGLE_2
%Combining Byte0 and Byte1 of of Steer_Angle_1_Control signal
%And then flip the sign for values over 3276.7 for Steer_Angle_1_Control signal
Steer_Angle_2.Actual = ((Steer_Angle_2.Byte1*256)+Steer_Angle_2.Byte0);
h=height(Steer_Angle_2);
for i=1:h
    if Steer_Angle_2{i,"Actual"} > 32767
        Steer_Angle_2{i,"Actual"} = Steer_Angle_2{i,"Actual"}-65536;
    end
end
for i=1:h
    Steer_Angle_2{i,"Actual"} = Steer_Angle_2{i,"Actual"}/10;
end
clearvars h;

%STEER_REQUEST
%Copying Byte2 into another column for reformatting
%And then flip the sign for values of 127 for Steer_Request signal
Steer_Request.Actual = Steer_Request.Byte2;
h=height(Steer_Request);
for i=1:h
    if Steer_Request{i,"Actual"} > 127
        Steer_Request{i,"Actual"} = Steer_Request{i,"Actual"}-256;
    end
end
clearvars i h;


% STEER_TARGET
% Copying Byte2 into another column for reformatting
% And then flip the sign for values of 127 for Steer_Request signal
Steer_Target.Actual = Steer_Target.Byte2;
h=height(Steer_Target);
for i = 1:h
       if Steer_Target{i,"Actual"} > 127
           Steer_Target{i,"Actual"} = Steer_Target{i,"Actual"} - 256;
       end
end
clearvars i h;
%% PLOTTING THE SIGNALS.
x1 = Automation.Time;
x2 = Steer_Request.Time;
x3 = Steer_Target.Time;
x4 = Steer_Angle_1_Control.Time;
x5 = Steer_Angle_1_Monitor.Time;
x6 = Steer_Angle_2.Time;

y1 = Automation.Byte3;
y2 = Steer_Request.Actual;
y3 = Steer_Target.Actual;
y4 = Steer_Angle_1_Control.Actual;
y5 = Steer_Angle_1_Monitor.Actual;
y6 = Steer_Angle_2.Actual;

plot(x1,y1, 'b-o','MarkerIndices',1:1:length(Automation.Byte3),'MarkerEdgeColor','magenta','MarkerFaceColor',[1 0 1],'MarkerSize', 2,'Color','m');
hold on;

plot(x2, y2,'r-square','MarkerIndices',1:1:length(Steer_Request.Actual),'MarkerEdgeColor','blue','MarkerFaceColor',[0 0 1],'MarkerSize', 2,'Color','b');
hold on;

plot(x3, y3,'r-diamond','MarkerIndices',1:1:length(Steer_Target.Actual),'MarkerEdgeColor','cyan','MarkerFaceColor',[0 1 1],'MarkerSize', 2,'Color','c');
hold on;

plot(x4, y4,'r-+','MarkerIndices',1:1:length(Steer_Angle_1_Control.Actual),'MarkerEdgeColor','green','MarkerFaceColor',[0 1 0],'MarkerSize', 2,'Color','g');
title(filename,'Interpreter','none');

plot(x5, y5,'r-^','MarkerIndices',1:1:length(Steer_Angle_1_Monitor.Actual),'MarkerEdgeColor',[0 .5 0],'MarkerFaceColor',[0 .5 0],'MarkerSize', 2,'Color',[0 .5 0]);
title(filename,'Interpreter','none');

plot(x6, y6,'r-^','MarkerIndices',1:1:length(Steer_Angle_2.Actual),'MarkerEdgeColor',[0 .2 0],'MarkerFaceColor',[0 .2 0],'MarkerSize', 2,'Color',[0 .2 0]);
title(filename,'Interpreter','none');

xlabel('Time (s)');
ylabel('Units (as per Private.dbc');
legend({'Automation [on/off]','Steer_Request [%]','Steer_Target [%]','Steer_Angle_1_Control [%]', 'Steer_Angle_1_Monitor', 'Steer_Angle_2 [%]'},'Interpreter','none')
xtickangle(45)
grid on
grid minor

clearvars x1 x2 x3 x4 x5 x6 y1 y2 y3 y4 y5 y6;
%% EXTRACTING THE DIFFERENCE.
%Dif = Steer_Request.Actual - Steer_Angle_1_Control.Actual;
%Dif = Steer_Request(:,"Actual") - Steer_Angle_1_Control(:,"Actual");

%difference2= addvars(difference, T2);
%difference.Actual=Steer_Angle_1_Control.Actual;
%difference.Properties.Variablenames{3}={'Steer_Actual'};

%difference=Steer_Angle_1_Control(:,"Actual");
%% PLOTTING THE DIFFERENCE. 
difference=Steer_Request;
difference(:,[2,3,4])=[];
difference = renamevars(difference,"Actual","Steer_Request");

%% CHANGE TABLE COLUMNS VARIABLE NAMES.
T2 = Steer_Angle_1_Control;
T2(:,[1,2,3,4,5])=[];


