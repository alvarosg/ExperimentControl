% (c) Alvaro Sanchez Gonzalez 2014
classdef SetScanPanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        variablePanel
        acquisitionPanel
        pushRun
         
        textTotalSteps
        textTotalTime
        editLabel
        editNumber
        checkRef
        
        updateList
        
        scan
        dataLabeler
        
        metadataPanel
      
    end
    
    methods
        function o = SetScanPanel(parentC,stageControllerPanel,acquisitionControllerPanel,dataLabeler,metadataPanel)
            set(parentC,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            o.parentC=parentC;
            o.metadataPanel=metadataPanel;
            o.dataLabeler=dataLabeler;
                        
            hgh1 = uigridcontainer('v0','Parent',parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[4 2 1]);
            o.variablePanel=SetScanVariablePanel(hgh1,stageControllerPanel);
            o.variablePanel.addUpdateList(o);
            
            o.acquisitionPanel=SetScanAcquisitionPanel(hgh1,acquisitionControllerPanel);
            o.acquisitionPanel.addUpdateList(o);
            hgv1v1 = uigridcontainer('v0','Parent',hgh1,'Units','norm','Position',[0,0,1,1],'GridSize',[10,1], 'VerticalWeight',[2,1,1,1,1,1,1,1,1,4]);

            o.pushRun=uicontrol('Parent',hgv1v1,'style','push','string','Run');
            set(o.pushRun,'Callback',@(s,e)pushedRun(o,s,e))
            
            uicontrol('Parent',hgv1v1,'style','text','string','Number of steps:');
            o.textTotalSteps=uicontrol('Parent',hgv1v1,'style','text');
            
            uicontrol('Parent',hgv1v1,'style','text','string','Time:');
            o.textTotalTime=uicontrol('Parent',hgv1v1,'style','text');
            
            uicontrol('Parent',hgv1v1,'style','text','string','Label:');
            o.editLabel=uicontrol('Parent',hgv1v1,'style','edit','BackgroundColor','white');
            set(o.editLabel,'Callback',@(s,e)editedLabel(o,s,e))
            
            %uicontrol('Parent',hgv1v1,'style','text','string','Number:');
            %o.editNumber=uicontrol('Parent',hgv1v1,'style','edit','BackgroundColor','white');
            %set(o.editNumber,'Callback',@(s,e)editedNumber(o,s,e))
            
            o.checkRef=uicontrol('Parent',hgv1v1,'style','check','string',' Auto No IR Reference:');
            set(o.checkRef,'Callback',@(s,e)checkedRef(o,s,e))            
           
            update(o,true)
        end
        
        function checkedRef(o,s,e)
            setappdata(0,'NoIRRef',get(o.checkRef,'Value'));
        end
        
        function editedLabel(o,s,e)
            o.dataLabeler.setLabel(get(o.editLabel,'string'));
            update(o,true);
        end
        
        function editedNumber(o,s,e)
            o.dataLabeler.setNumber(str2num(get(o.editNumber,'string')));
            update(o,true);
        end
        
        function pushedRun(o,s,e)            
            if(strcmp(get(o.pushRun,'string'),'Run'))
                if(length(o.variablePanel.addedElements)>0)
                    set(o.pushRun,'string','Stop');
                    
                    
                    totalTime=0;
                    %Find the total time from waiting devices
                    for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                        if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                                strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'wait'))
                            shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(2);
                            totalTime=totalTime+shots*o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.getExposure();
                        end
                    end
                    
%                     totalTime=max([totalTime,1000]);
                    
                    %Set the exposure time for the non wait devices to the
                    %appropiate time (Actually half the appropriate time)
                    for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                        if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                                strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'nowait'))
                            shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(2);
                            o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.setExposure(totalTime/shots*0.5);
                        end
                    end
                    
                    
                    for i=1:length(o.variablePanel.addedElements)
                        scanVariableList{i}=o.variablePanel.addedElements{length(o.variablePanel.addedElements)-i+1}.scanVariable;
                    end
                    dataTaker=DataTaker(o.acquisitionPanel.acquisitionControllerPanel,false);
                    o.scan=ScanPerformer(scanVariableList,dataTaker,o.dataLabeler);
                    
                    if(~ishandle(o.metadataPanel.window))
                        o.metadataPanel.plotWindow();  
                    end
                    o.metadataPanel.setLabelPath(o.dataLabeler.getCurrentLabel(),fullfile(o.dataLabeler.getCurrentFullPathFolder(),'metadata.mat'));
                    o.metadataPanel.makeModal();
                    
                    ScanParametersSaver.SaveToFile(scanVariableList,fullfile(o.dataLabeler.getCurrentFullPathFolder(),'scanparameters.mat'));
                                        
                    o.scan.start();
                    delete(dataTaker);                    
                    update(o,true);
                    set(o.pushRun,'string','Run');
                    delete(o.scan);
                    
                end
            else
                set(o.pushRun,'string','Run');
                o.scan.stop();                
            end
        end
                     
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            
            set(o.editLabel,'string',o.dataLabeler.getLabel());
            %set(o.editNumber,'string',o.dataLabeler.getNumber());

            if(length(o.variablePanel.addedElements))
                totalSteps=1;
                for i=1:length(o.variablePanel.addedElements)
                    totalSteps=totalSteps*o.variablePanel.addedElements{i}.scanVariable.steps();
                end
            else
                totalSteps=0;
            end
            set(o.textTotalSteps,'string',num2str(totalSteps));
            
            time=0;
            for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                        strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'wait'))
                    shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(2);
                    time=time+shots*o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.getExposure();
                end
            end
            
            set(o.textTotalTime,'string',secs2hms(time*totalSteps/1000));
            
            if(~isempty(getappdata(0,'NoIRRef')) && getappdata(0,'NoIRRef')==true)
                set(o.checkRef,'Value',true);
            else
                set(o.checkRef,'Value',false);
            end
            
            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
            
        end
        
        function closedWindow(o,s,e)          
            o.delete()
        end
        
        function delete(o)
            delete(o.variablePanel)
            delete(o.acquisitionPanel)
        end
    end
end

