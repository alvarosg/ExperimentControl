% (c) Alvaro Sanchez Gonzalez 2014
classdef ScanPerformer<handle
    %SCANPERFORMER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scanVariableList
        dataTaker
        dataLabeler
        stageIteration
        maxStageIteration
        livePlottingBoxes
        livePlottingProfile
        initialPos
        nLoops
        running
        path
    end
    
    methods
        function o = ScanPerformer(scanVariableList,dataTaker,dataLabeler)
            o.scanVariableList=scanVariableList;            
            o.dataTaker=dataTaker;
            o.dataLabeler=dataLabeler;
            o.nLoops=length(o.scanVariableList);
            o.stageIteration=ones([o.nLoops 1]);
            for stageInd=1:o.nLoops
                o.maxStageIteration(stageInd)=o.scanVariableList{stageInd}.steps();
            end
            o.path=o.dataLabeler.getFullPathFolder();    
            
            o.livePlottingBoxes={};
            o.livePlottingProfile={};
            count=0;
            for i=1:length(o.dataTaker.enabled)
                deviceInfo=o.dataTaker.acquisitionControllerPanel.initElements{o.dataTaker.enabled(i)}.deviceController.deviceInfo;
                controller=o.dataTaker.acquisitionControllerPanel.initElements{o.dataTaker.enabled(i)}.deviceController;
                if(strcmp(AcquisitionTypes.getNameFormat(deviceInfo.type),'image') && controller.boxesHand.count()>0)
                    count=count+1;
                    fig=figure('name',sprintf('%s: %s boxes',o.dataLabeler.getCurrentLabel(),deviceInfo.name),'NumberTitle','off','position',[200 50 1200 700]);
                    set(fig, 'menubar', 'none','toolbar','figure');
                    o.livePlottingBoxes{count}=LivePlottingBoxes(fig,o.scanVariableList,sprintf('%s: %s boxes',o.dataLabeler.getCurrentLabel(),deviceInfo.name),clock,dataTaker,controller);  
                    fig=figure('name',sprintf('%s: %s profiles',o.dataLabeler.getCurrentLabel(),deviceInfo.name),'NumberTitle','off','position',[200 50 1200 700]);
                    set(fig, 'menubar', 'none','toolbar','figure');
                    o.livePlottingProfile{count}=LivePlottingProfile(fig,o.scanVariableList,sprintf('%s: %s boxes',o.dataLabeler.getCurrentLabel(),deviceInfo.name),clock,dataTaker,controller);   
                end
            end                        
        end
        
        function o = start(o)
            MessageSystem.get().printMessage('SCAN',sprintf('Started %s',o.path),true);              
            o.running=true;
            o.saveInitialPositions();
            o.setStartPosition();
            increased=true;
            while(increased && o.running)
                o.acquire();
                ExtraAcquisition.AcquireExtra(o.dataLabeler,o.stageIteration,o.maxStageIteration);
                increased = o.incrementLoop(o.nLoops);
            end
            o.setInitialPositions();
            MessageSystem.get().printMessage('SCAN',sprintf('Finished %s',o.path),true);  
            MessageSystem.get().ResetSecondOutput();  
        end
        
        function o= stop(o)
            o.running=false;
        end
        
        function increased = incrementLoop(o,stageInd)
            %If I can increment this counter, I do it
            if(o.stageIteration(stageInd)<o.maxStageIteration(stageInd))
                o.stageIteration(stageInd)=o.stageIteration(stageInd)+1;
                o.scanVariableList{stageInd}.setPositionIndex(o.stageIteration(stageInd));
                increased=true;  
            %If I cannot, I reset it to the initial value
            else
                o.stageIteration(stageInd)=1;
                o.scanVariableList{stageInd}.setPositionIndex(o.stageIteration(stageInd));
                % And increment the immediately outer one
                if(stageInd>1)                    
                    increased=o.incrementLoop(stageInd-1);
                %Unless this is the most external one, in which case I just
                %stop
                else
                    increased=false;
                end  
            end
        end
        
        function setStartPosition(o)
            for i=1:o.nLoops
                o.scanVariableList{i}.setPositionIndex(o.stageIteration(i));
            end
        end
        
        function acquire(o)
            indicesOrder=ScanVariable.StagesIteration2PositionIndices(o.stageIteration,o.scanVariableList);
            name=sprintf('%i_',indicesOrder);
            name=name(1:end-1);
            name=strcat(name,'.mat');
            
            o.dataTaker.TakeData(fullfile(o.path,name));
            
            areas={};
            for i=1:length(o.livePlottingBoxes)
                o.livePlottingBoxes{i}.addPoint(o.stageIteration);
                eval(sprintf('areas.%s.areas=o.livePlottingBoxes{i}.values;',o.livePlottingBoxes{i}.imageAcquisitionDevice.deviceInfo.varname));
                eval(sprintf('areas.%s.boxes=o.livePlottingBoxes{i}.imageAcquisitionDevice.boxesHand.boxes;',o.livePlottingBoxes{i}.imageAcquisitionDevice.deviceInfo.varname));
                o.livePlottingBoxes{i}.printScreen(fullfile(o.path,sprintf('%sboxes.png',o.livePlottingProfile{i}.imageAcquisitionDevice.deviceInfo.varname)))
            end
                        
            if(~isempty(areas))
                save(fullfile(o.path,'areas.mat'),'areas'); 
            end
            
            profiles={};
            for i=1:length(o.livePlottingProfile)
                o.livePlottingProfile{i}.addPoint(o.stageIteration);
                eval(sprintf('profiles.%s.profiles=o.livePlottingProfile{i}.values;',o.livePlottingProfile{i}.imageAcquisitionDevice.deviceInfo.varname));
                eval(sprintf('profiles.%s.rectangle=o.livePlottingProfile{i}.imageAcquisitionDevice.cropHand.rectangle;',o.livePlottingProfile{i}.imageAcquisitionDevice.deviceInfo.varname));
                o.livePlottingProfile{i}.printScreen(fullfile(o.path,sprintf('%sprofiles.png',o.livePlottingProfile{i}.imageAcquisitionDevice.deviceInfo.varname)))
            end
                        
            if(~isempty(profiles))
                save(fullfile(o.path,'profiles.mat'),'profiles'); 
            end
        end
        
        function saveInitialPositions(o)
            for i=1:o.nLoops
                o.initialPos{i}=o.scanVariableList{i}.controller.position();
            end
        end
        function setInitialPositions(o)
            for i=1:o.nLoops
                o.scanVariableList{i}.controller.setPosition(o.initialPos{i});
            end
        end            
    end    
end

