% (c) Alvaro Sanchez Gonzalez 2014
classdef SmarActMultiStageClass<AbstractMultiStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        data
        serial
    end
    
    methods
        function o = SmarActMultiStageClass(stageInfo) 
            o = o@AbstractMultiStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            o.dim=0;
            d = consortium_matlab_dir;
            if(strcmp(computer('arch'),'win32'))
                dllpath=fullfile(d, 'apps','SmarAct','lib','MCSControl.dll');
            else
                dllpath=fullfile(d, 'apps','SmarAct','lib64','MCSControl.dll');
            end
            headerpath=fullfile(d, 'apps','SmarAct','include','MCSControl.h');
            loadlibrary(dllpath,headerpath,'alias','SmarAct');    
            
            o.controller=uint32(0);
            [error o.controller]=calllib('SmarAct','SA_OpenSystem',o.controller,o.serial,'sync');
            
            if(error~=0)
                disp('Error initializing the SmarAct stage, try unplugging and plugging it back');
            else
                o.dim=3;
                o.updatePosition();
            end               
        end
        function destroy(o)
            [error]=calllib('SmarAct','SA_CloseSystem',o.controller);
            unloadlibrary('SmarAct');  
        end
        function outPosition=gotoPosition(o,position,dim)
            heldTime=60000;
            positionAbs=int32(position*1e3);
            error = calllib('SmarAct','SA_GotoPositionAbsolute_S',o.controller,uint32(dim-1),positionAbs,heldTime);
            status=0;
            finished=0;
            while (~finished)
            %while (status ~=4)
                %[error status]=calllib('SmarAct','SA_GetStatus_S',o.controller, uint32(dim-1),status);
                position=0;
                [error position] = calllib('SmarAct','SA_GetPosition_S',o.controller,uint32(dim-1),position);            
                pause(0.05); %0.05
                if(abs(position-positionAbs)<1000)
                    finished=1;
                end
            end
            pause(0.15);
            position=0;
            [error position] = calllib('SmarAct','SA_GetPosition_S',o.controller,uint32(dim-1),position);
            outPosition=double(position)*1e-3;
        end
        
        function updatePosition(o)
            position=0;
            o.pos=[];
            for i=1:o.dim
                [error position] = calllib('SmarAct','SA_GetPosition_S',o.controller,i-1,position);
                o.pos(i)=double(position)*1e-3;
            end            
        end
               
        function minPos=minPosition(o)
            for i=1:o.dim
                if (i==1)
                    minPos(i)=-20*1e3; 
                elseif (i==2)
                    minPos(i)=-25*1e3; 
                elseif (i==3)
                    minPos(i)=-72000;
                end 
            end
        end
        function maxPos=maxPosition(o)
            for i=1:o.dim
                if (i==1)
                    maxPos(i)=20*1e3; 
                elseif (i==2)
                    maxPos(i)=25*1e3; 
                elseif (i==3)
                    maxPos(i)=72000;
                end 
            end
        end
        
        function home(o)
        end
    end    
end

