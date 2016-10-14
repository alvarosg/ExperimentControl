% (c) Alvaro Sanchez Gonzalez 2014, Allan Johnson 2016 (am I doing this
% right?)
classdef RemoteCEPLockStageClass<AbstractStageClass
    %RemoteCEPLockStageClass Summary of this class goes here
    %   to control the CEP of the idler by remotely connecting to a session
    %   of CEPslowloop and feeding it commands.
    
    properties
        ip
        tcpObj
    end
    
    methods
        function o = RemoteCEPLockStageClass(stageInfo) 
            o = o@AbstractStageClass(stageInfo);
            o.initialize;
        end
  
        function initialize(o)
            %o.setExtraParam(o.deviceInfo.extraparam)
            o.ip=o.stageInfo.serial;
            try
            o.tcpObj=MOIP.connect('client',o.ip,30001);
            catch ME
                if (strcmp(ME.identifier,'instrument:fopen:opfailed'))
                sprintf('Failed to connect, is server running?')
                
                sprintf('Attempting to connect again')
                reconnect(o);
                end
               sprintf('Failed to connect, is server running?')
               sprintf('Make sure both computers can access network - connect to L drive')
               rethrow(ME)
            end
%            fprintf(o.serialObj,o.cmds.AbsMode);
        end
        
        function destroy(o)
            fclose(o.tcpObj);
            delete(o.controller);
        end
        
        function outPosition=gotoPosition(o,position)
            MOIP.eval(o.tcpObj,sprintf('slow_loop.h.targetCEP.sp.value=%d',position),true);
            %MOIP.eval(o.tcpObj,'remoteSpectrometer.resetRollingAvePushed();',true);
            outPosition = o.pos;
        end
  
        function updatePosition(o)
            o.pos=MOIP.eval(o.tcpObj,'slow_loop.h.targetCEP.sp.value',true);
        end
        
        function reconnect(o)
            o.tcpObj=MOIP.connect('client',o.ip);
            % get position again
            o.pos=MOIP.eval(o.tcpObj,'slow_loop.h.targetCEP.sp.value',true);
        end
        
        function minPos=minPosition(o)
            minPos=-2*pi;            
        end
        function maxPos=maxPosition(o)
            maxPos=2*pi;   
        end
        function home(o)
        % can't home CEP
        end
    end    
end

