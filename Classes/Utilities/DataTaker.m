% (c) Alvaro Sanchez Gonzalez 2014
classdef DataTaker<handle
    %DATASAVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        acquisitionControllerPanel
        enabled
        enabledCount
        enabledShots
        enabledWait
        enabledWaitCount
        enabledWaitShots
        enabledNoWait
        enabledNoWaitCount
        enabledNoWaitShots
        multipleNShots
        lastData
        single
        progressBar
        
    end
    
    methods
        function o=DataTaker(acquisitionControllerPanel,single)
            o.progressBar=waitbar(0,'Progress');
            o.acquisitionControllerPanel=acquisitionControllerPanel;
            o.enabledCount=0;
            o.single=single;
            o.enabledWaitCount=0;
            o.enabledNoWaitCount=0;
            for i=1:length(acquisitionControllerPanel.initialized)
                if(acquisitionControllerPanel.initElements{i}.acquire)
                    o.enabledCount=o.enabledCount+1;
                    o.enabled(o.enabledCount)=i;
                    if(single)
                        shots=o.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(1);
                    else
                        shots=o.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(2);
                    end
                    o.enabledShots(o.enabledCount)=shots;
                    if(strcmp(AcquisitionTypes.getNameMode(o.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'nowait'))
                        o.enabledNoWaitCount=o.enabledNoWaitCount+1;
                        o.enabledNoWait(o.enabledNoWaitCount)=i;
                        o.enabledNoWaitShots(o.enabledNoWaitCount)=shots;
                    else
                        o.enabledWaitCount=o.enabledWaitCount+1;
                        o.enabledWait(o.enabledWaitCount)=i;
                        o.enabledWaitShots(o.enabledWaitCount)=shots;
                    end
                    
                end
            end
            
            %Get a multiple of the number of shots for every device
            o.multipleNShots=1;
            
            for i=1:o.enabledCount
                o.multipleNShots=o.multipleNShots*o.enabledShots(i);
            end                                   
        end
        function TakeData(o,path)
            MessageSystem.get().printMessage('ACQUISITION',sprintf('Started %s',path),true);  
            data={};
            %Reset the buffers
            for i=1:o.enabledCount
                o.acquisitionControllerPanel.initElements{o.enabled(i)}.deviceController.resetBuffer();
            end
            
            %Start acquiring
            for t=1:o.multipleNShots
                if(ishandle(o.progressBar))
                    waitbar((t-1)/o.multipleNShots,o.progressBar,'Progress:');
                else
                    o.progressBar=waitbar((t-1)/o.multipleNShots,'Progress:');
                end
                for i=1:o.enabledWaitCount
                    if(rem(t-1,o.multipleNShots/o.enabledWaitShots(i))==0)
                        o.acquisitionControllerPanel.initElements{o.enabledWait(i)}.deviceController.acquire();
                    end
                end
                
                for i=1:o.enabledNoWaitCount
                    if(rem(t,o.multipleNShots/o.enabledNoWaitShots(i))==0)
                        o.acquisitionControllerPanel.initElements{o.enabledNoWait(i)}.deviceController.acquire();
                    end
                end
            end
            
            %Get the buffers
            for i=1:o.enabledCount
                if(o.single)
                    buffer=o.acquisitionControllerPanel.initElements{o.enabled(i)}.deviceController.retrieve();
                else
                    buffer=o.acquisitionControllerPanel.initElements{o.enabled(i)}.deviceController.retrieveReduced();
                end
                varname=o.acquisitionControllerPanel.initElements{o.enabled(i)}.deviceController.deviceInfo.varname;
                eval(sprintf('data.%s=buffer;',varname));
            end
            
            date=datestr(clock,'yyyy-mm-dd HH:MM:SS');
            
            save(path,'data','date');
            o.lastData=data;         
            MessageSystem.get().printMessage('ACQUISITION',sprintf('Finished %s',path),true);  
        end
        
        function delete(o)
            if(ishandle(o.progressBar))
                delete(o.progressBar);
            end
        end
    end
    
end

