
d = consortium_matlab_dir;

if(strcmp(computer('arch'),'win32'))
    dllpath=fullfile(d, 'apps','SmarAct','lib','MCSControl.dll');
else
    dllpath=fullfile(d, 'apps','SmarAct','lib64','MCSControl.dll');
end

headerpath=fullfile(d, 'apps','SmarAct','include','MCSControl.h');


loadlibrary(dllpath,headerpath,'alias','SmarAct');


%%
mcsHandle=uint32(0);
[error mcsHandle]=calllib('SmarAct','SA_OpenSystem',mcsHandle,'usb:ix:0','sync')

%%
numChannels=uint32(0);
[error numChannels] = calllib('SmarAct','SA_GetNumberOfChannels',mcsHandle,numChannels)

%%
channel=0;
heldTime=60000;
positionRel=-1000000;
error = calllib('SmarAct','SA_GotoPositionRelative_S',mcsHandle,channel,positionRel,heldTime)

status=0;
while (status ~=4)
    [error status]=calllib('SmarAct','SA_GetStatus_S',mcsHandle, channel,status);
    pause(0.1);
end
pause(0.2);
position=0;
[error position] = calllib('SmarAct','SA_GetPosition_S',mcsHandle,channel,position)

%%
channel=0;
heldTime=60000;
positionAbs=0;
error = calllib('SmarAct','SA_GotoPositionAbsolute_S',mcsHandle,channel,positionAbs,heldTime)
status=0;
while (status ~=4)
    [error status]=calllib('SmarAct','SA_GetStatus_S',mcsHandle, channel,status);
    pause(0.1);
end
pause(0.2);
position=0;
[error position] = calllib('SmarAct','SA_GetPosition_S',mcsHandle,channel,position)

%%
[error]=calllib('SmarAct','SA_CloseSystem',mcsHandle)

%%
unloadlibrary('SmarAct');  


