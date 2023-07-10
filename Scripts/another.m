%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\maxju\Documents\Customer Support\Monash University\env200 log file2.log
%
% To extend the code to different selected data or a different text file, generate a function instead of a script.

% Auto-generated by MATLAB on 2023/07/06 09:49:33

%% Initialize variables.
filename = 'C:\Users\maxju\Documents\Customer Support\Monash University\env200 log file2.log';
startRow = 15;

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%13s%*3*s%*5s%3s%*2*s%*2s%3s%3s%3s%3s%3s%3s%3s%3s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If an error occurs for a different file, try regenerating the code from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false);

%% Remove white space around all cell columns.
dataArray{1} = strtrim(dataArray{1});
dataArray{2} = strtrim(dataArray{2});

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[3,4,5,6,7,8,9,10]
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


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [3,4,5,6,7,8,9,10]);
rawStringColumns = string(raw(:, [1,2]));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
env200logfile2 = table;
env200logfile2.Time = rawStringColumns(:, 1);
env200logfile2.VarName4 = rawStringColumns(:, 2);
env200logfile2.VarName7 = cell2mat(rawNumericColumns(:, 1));
env200logfile2.Byte0 = cell2mat(rawNumericColumns(:, 2));
env200logfile2.Byte1 = cell2mat(rawNumericColumns(:, 3));
env200logfile2.Byte2 = cell2mat(rawNumericColumns(:, 4));
env200logfile2.Byte3 = cell2mat(rawNumericColumns(:, 5));
env200logfile2.Byte4 = cell2mat(rawNumericColumns(:, 6));
env200logfile2.Byte5 = cell2mat(rawNumericColumns(:, 7));
env200logfile2.Byte6 = cell2mat(rawNumericColumns(:, 8));

%% Clear temporary variables
clearvars filename startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R;
%% 
hexStr=(candump.Byte0);
D=hex2dec(hexStr);
candump.Byte0=D;

%{
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
%
