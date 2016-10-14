% (c) Alvaro Sanchez Gonzalez 2014
classdef NewFocus8742MultiStageClass<AbstractMultiStageClass
    %THORTRANSSTAGECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller
        data
        serial
        strDeviceKey
    end
    
    methods
        function o = NewFocus8742MultiStageClass(stageInfo) 
            o = o@AbstractMultiStageClass(stageInfo);
            o.serial=o.stageInfo.serial;
            o.initialize;
        end
  
        function initialize(o)
            o.dim=0;
            
            NewFocus8742MultiStageClass.loadDllLibrary();
            
            o.controller=uint32(0);
            o.controller=NewFocus.Picomotor.CmdLib8742(false, 1000, []);
            o.strDeviceKey=sprintf('8742 %s',o.serial);

            error=0;
            if(error~=0)
                disp('Error initializing the Controller 8742, try unplugging and plugging it back');
            else
                o.dim=4;
            end               
            
            for i=1:o.dim
                bStatus = o.controller.SetZeroPosition(o.strDeviceKey, int32(i));
            end
            o.updatePosition();
        end
        function destroy(o)
            bStatus=o.controller.Close(o.strDeviceKey);
            delete(o.controller)
        end
        function outPosition=gotoPosition(o,position,dim)
            positionAbs=int32(position);
            bStatus = o.controller.AbsoluteMove (o.strDeviceKey,  int32(dim), positionAbs);
            finished=0;
            while (~finished)
                position=0;
                [bStatus, position] = o.controller.GetPosition(o.strDeviceKey,  int32(dim), 0);           
                pause(0.05);
                if(position==positionAbs)
                    finished=1;
                end
            end
            pause(0.15);
            position=0;
            [bStatus, position] = o.controller.GetPosition(o.strDeviceKey,  int32(dim), 0); 
            outPosition=position;
        end
        
        function updatePosition(o)
            o.pos=[];
            for i=1:o.dim
                [bStatus, position] = o.controller.GetPosition(o.strDeviceKey,  int32(i), 0);
                o.pos(i)=position;
            end            
        end
               
        function minPos=minPosition(o)
            for i=1:o.dim
                if (i==1)
                    minPos(i)=-Inf; 
                end 
            end
        end
        function maxPos=maxPosition(o)
            for i=1:o.dim
                if (i==1)
                    maxPos(i)=Inf; 
                end
            end
        end
        
        function home(o)
        end
        
    end
    methods(Static)
        function loadDllLibrary()
            d = consortium_matlab_dir;
                        
            if(strcmp(computer('arch'),'win32'))
                dllpath=fullfile(d, 'apps','NewFocus8742','x86','CmdLib.dll');
            else
                dllpath=fullfile(d, 'apps','NewFocus8742','x64','CmdLib.dll');
            end   
            
            NET.addAssembly(dllpath);            
        end
        
        function serials=listConnectedSerials()
            
            NewFocus8742MultiStageClass.loadDllLibrary();            
            c=NewFocus.Picomotor.CmdLib8742(false, 1000, []);
            devicekeys=c.GetDeviceKeys();
            
            serials={};
            for i=1:devicekeys.Length
                str=devicekeys(i).char;
                serials{i}=str(6:end);
            end
        end
    end    
end

