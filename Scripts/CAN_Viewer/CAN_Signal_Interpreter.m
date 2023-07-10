%% INTERPRETING THE SIGNALS AS PER PRIVATE.DBC (Byte Order, 2's Complement, Factor)
%STEER_ANGLE_1_CONTROL (16 bit, 0.1 Factor, Signed, Intel)
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

