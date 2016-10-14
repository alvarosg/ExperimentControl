% (c) Alvaro Sanchez Gonzalez 2014
classdef SaveSinglePanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        acquisitionPanel
        pushSave
         
        editLabel
        editNumber
        
        updateList
        
        scan
        dataLabeler
        
        metadataPanel
        textTotalTime
      
    end
    
    methods
        function o = SaveSinglePanel(parentC,acquisitionControllerPanel,dataLabeler,metadataPanel)
            set(parentC,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            o.parentC=parentC;
            o.metadataPanel=metadataPanel;
            o.dataLabeler=dataLabeler;
                        
            hgh1 = uigridcontainer('v0','Parent',parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[2 1]);
            
            o.acquisitionPanel=SetScanAcquisitionPanel(hgh1,acquisitionControllerPanel);
            o.acquisitionPanel.addUpdateList(o);
            hgv1v1 = uigridcontainer('v0','Parent',hgh1,'Units','norm','Position',[0,0,1,1],'GridSize',[10,1], 'VerticalWeight',[2,1,1,1,1,1,1,1,1,4]);

            o.pushSave=uicontrol('Parent',hgv1v1,'style','push','string','Run');
            set(o.pushSave,'Callback',@(s,e)pushedSave(o,s,e))            
            
            uicontrol('Parent',hgv1v1,'style','text','string','Time:');
            o.textTotalTime=uicontrol('Parent',hgv1v1,'style','text');
            
            uicontrol('Parent',hgv1v1,'style','text','string','Label:');
            o.editLabel=uicontrol('Parent',hgv1v1,'style','edit','BackgroundColor','white');
            set(o.editLabel,'Callback',@(s,e)editedLabel(o,s,e))
            
            %uicontrol('Parent',hgv1v1,'style','text','string','Number:');
            %o.editNumber=uicontrol('Parent',hgv1v1,'style','edit','BackgroundColor','white');
            %set(o.editNumber,'Callback',@(s,e)editedNumber(o,s,e))
            
           
            update(o,true)
        end
        
        function editedLabel(o,s,e)
            o.dataLabeler.setLabel(get(o.editLabel,'string'));
            update(o,true);
        end
        
        function editedNumber(o,s,e)
            o.dataLabeler.setNumber(str2num(get(o.editNumber,'string')));
            update(o,true);
        end
        
        function pushedSave(o,s,e)    
            
            totalTime=0;
            %Find the total time from waiting devices
            for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                        strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'wait'))
                    shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(1);
                    totalTime=totalTime+shots*o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.getExposure();
                end
            end

            %Set the exposure time for the non wait devices to the
            %appropiate time (Actually half the appropriate time)
            for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                        strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'nowait'))
                    shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(1);
                    o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.setExposure(totalTime/shots*0.5);
                end
            end
            
            dataTaker=DataTaker(o.acquisitionPanel.acquisitionControllerPanel,true);
            name=fullfile(o.dataLabeler.getFullPathFolder(),'data.mat');
            
            if(~ishandle(o.metadataPanel.window))
                o.metadataPanel.plotWindow();  
            end
            o.metadataPanel.setLabelPath(o.dataLabeler.getCurrentLabel(),fullfile(o.dataLabeler.getCurrentFullPathFolder(),'metadata.mat'));
            o.metadataPanel.makeModal();
            
            dataTaker.TakeData(name);
            delete(dataTaker);                    
            update(o,true);
        end
                     
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
        
        function update(o,updateAll)
            
            set(o.editLabel,'string',o.dataLabeler.getLabel());
            %set(o.editNumber,'string',o.dataLabeler.getNumber());
            
            time=0;
            for i=1:length(o.acquisitionPanel.acquisitionControllerPanel.initElements)
                if(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.acquire && ...
                        strcmp(AcquisitionTypes.getNameMode(o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.type),'wait'))
                    shots=o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.deviceInfo.shots(1);
                    time=time+shots*o.acquisitionPanel.acquisitionControllerPanel.initElements{i}.deviceController.getExposure();
                end
            end
            
            set(o.textTotalTime,'string',secs2hms(time/1000));
            
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
            delete(o.acquisitionPanel)
        end
    end
end

