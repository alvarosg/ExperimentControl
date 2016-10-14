% (c) Alvaro Sanchez Gonzalez 2014
classdef ExperimentControlWindow<handle
    %MAINWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        stageControllerPanel
        acquisitionControllerPanel
        stagesHand
        acquisitionDevicesHand
        pushScan
        pushSingle
        pushScanFromFile
        pathOutput
        pathConfig
        
        pushReset
        log
        messageSystem
        dataLabeler
        
        
        metadataPanel
        figScan
        figSingle
        figScanFromFile
        
    end
    
    methods
        function o=ExperimentControlWindow(parentC,pathConfig,pathOutput)
            o.pathOutput=pathOutput;
            o.pathConfig=pathConfig;
            o.messageSystem=MessageSystem();
            o.log=LogCreator(o.pathOutput);
            o.messageSystem.SetLog(o.log);
            o.figScan=-1;
            o.figSingle=-1;
            
            o.messageSystem.printMessage('EXPERIMENTCONTROL',sprintf('Opened'),true);
                        
            set(parentC,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            o.parentC=parentC;
            o.dataLabeler=DataLabeler(o.pathOutput);
            o.stagesHand=StagesListHandler(fullfile(o.pathConfig,'Stages.mat'));
            o.acquisitionDevicesHand=AcquisitionDeviceListHandler(fullfile(o.pathConfig,'AcquisitionDevices.mat'));
            o.metadataPanel=MetadataPanel(MetadataListHandler('C:/config/MetadataFields.mat'));
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[5 3]);            
            o.stageControllerPanel=StageControllerPanel(hgh,o.stagesHand);
            setappdata(0,'StageControllerPanel',o.stageControllerPanel);
            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[3,1], 'VerticalWeight',[9.5 0.5 1]);
            
            
            o.acquisitionControllerPanel=AcquisitionDeviceControllerPanel(hghv1,o.acquisitionDevicesHand);
            setappdata(0,'AcquisitionControllerPanel',o.acquisitionControllerPanel);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[10 1]);
            messageText=uicontrol('Parent',hghv1h1,'style','text','FontSize',10);
            o.messageSystem.SetMainOutput(messageText);
            o.pushReset=uicontrol('Parent',hghv1h1,'style','push','string','Reset');
            set(o.pushReset,'Callback',@(s,e)pushedReset(o,s,e))
            
            
            
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 1]);
            
            o.pushSingle=uicontrol('Parent',hghv1h2,'style','push','string','Save Single Set');
            set(o.pushSingle,'Callback',@(s,e)pushedSingle(o,s,e))
            
            o.pushScan=uicontrol('Parent',hghv1h2,'style','push','string','Run Scan');
            set(o.pushScan,'Callback',@(s,e)pushedScan(o,s,e))
            o.pushScanFromFile=uicontrol('Parent',hghv1h2,'style','push','string','Run Scan From File');
            set(o.pushScanFromFile,'Callback',@(s,e)pushedScanFromFile(o,s,e))
                        
        end
        
        function pushedReset(o,s,e)
            MessageSystem.get().ResetError();
        end
        
        function pushedScan(o,s,e)
            if (length(o.stageControllerPanel.initElements)>0 && length(o.acquisitionControllerPanel.initElements)>0)
                if (ishandle(o.figScan))
                    delete(o.figScan);
                end
                o.figScan=figure('name','Set Scan','NumberTitle','off','position',[200 50 750 450]);
                set(o.figScan, 'menubar', 'none');
                SetScanPanel(o.figScan,o.stageControllerPanel,o.acquisitionControllerPanel,o.dataLabeler,o.metadataPanel);
            end
        end
        
        function pushedSingle(o,s,e)
            if (length(o.acquisitionControllerPanel.initElements)>0)
                if (ishandle(o.figSingle))
                    delete(o.figSingle);
                end
                o.figSingle=figure('name','Save Single Set of Variables','NumberTitle','off','position',[200 50 300 450]);
                set(o.figSingle, 'menubar', 'none');
                SaveSinglePanel(o.figSingle,o.acquisitionControllerPanel,o.dataLabeler,o.metadataPanel);
            end
        end
        
        function pushedScanFromFile(o,s,e)
            if ishandle(o.figScanFromFile)
                delete(o.figScanFromFile)
            end
            o.figScanFromFile = figure('name','Perform Scan From File','NumberTitle','off','position',[200 50 650 550],'menubar','none');
            ScanFromFilePanel(o.figScanFromFile,o.acquisitionControllerPanel,o.stageControllerPanel,o.metadataPanel,o.pathOutput);
        end
        
        function closedWindow(o,s,e)          
            o.delete();
        end
        
        function delete(o)
            o.messageSystem.printMessage('EXPERIMENTCONTROL',sprintf('Closed'),true);
            delete(o.stageControllerPanel)
            delete(o.acquisitionControllerPanel)
            delete(o.messageSystem);
            delete(o.log); 
            if (ishandle(o.figSingle))
                delete(o.figSingle);
            end
            if (ishandle(o.figScan))
                delete(o.figScan);
            end
            if (isvalid(o.metadataPanel))
                delete(o.metadataPanel);
            end
        end
    end
end

