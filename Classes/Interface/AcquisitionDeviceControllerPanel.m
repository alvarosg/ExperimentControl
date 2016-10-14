% (c) Alvaro Sanchez Gonzalez 2014
classdef AcquisitionDeviceControllerPanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        acquisitionDevicesHand       
         
        pushInitialize
        pushClose
        controlContainer
        comboStage
        
        initialized
        initElements
      
    end
    
    methods
        function o = AcquisitionDeviceControllerPanel(parentC,acquisitionDevicesHand)
            o.parentC=parentC;
            o.acquisitionDevicesHand=acquisitionDevicesHand;
            hp = uipanel('Parent',o.parentC,'Title','Acquisition Devices','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hghv1 = uigridcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'GridSize',[2,1], 'VerticalWeight',[1 20]);
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[4,2,1]);
            o.controlContainer = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[7,1]);
            
            o.comboStage=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboStage,'Callback',@(s,e)comboChanged(o,s,e))
            
            o.pushInitialize=uicontrol('Parent',hghv1h1,'style','push','string','Open/Show');
            set(o.pushInitialize,'Callback',@(s,e)pushedInitialize(o,s,e))
            
            o.pushClose=uicontrol('Parent',hghv1h1,'style','push','string','Close');
            set(o.pushClose,'Callback',@(s,e)pushedClose(o,s,e))
            
            devices=o.acquisitionDevicesHand.getDevices();
            if(o.acquisitionDevicesHand.count()>0)
                for i=1:o.acquisitionDevicesHand.count();
                    names{i}=[num2str(i) ' - ' devices{i}.name];
                end
            end
            
            set(o.comboStage,'string',names);
            
            %The stage position devices recorder is created automatically
            pushedInitialize(o,0,0);
            
            update(o);
        end
        
        function pushedClose(o,s,e)
            index=get(o.comboStage,'Value');
            
            if(~isempty(find(o.initialized==index)))
                pos=find(o.initialized==index);                
                if(~strcmp(o.initElements{pos}.panels,'null'))
                    delete(o.initElements{pos}.panels);
                end
                
                try
                    delete(o.initElements{pos}.deviceController);
                    delete(o.initElements{pos}.panels); %29/07/2015 changed order of these two lines C.Brahms            
                catch
                    
                end
                o.initElements(pos)=[];   
                o.initialized(pos)=[];
            end           
            update(o);
        end
        
        function pushedInitialize(o,s,e)
            index=get(o.comboStage,'Value');
            device=o.acquisitionDevicesHand.getDevice(index);
            
            if(isempty(find(o.initialized==index)))
                pos=length(o.initialized)+1;
                o.initialized(pos)=index;                                                               
                o.initElements{pos}.deviceController='null';
                o.initElements{pos}.panels='null';
                o.initElements{pos}.acquire=true;
            else
                pos=find(o.initialized==index);
            end
                                               
            if(strcmp(o.initElements{pos}.deviceController,'null') || ~o.initElements{pos}.deviceController.isStillValid())                                   
                if(~strcmp(o.initElements{pos}.panels,'null'))
                    delete(o.initElements{pos}.panels);
                end
                o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',device.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                if(strcmp(device.type,'webcam'))                      
                    o.initElements{pos}.deviceController=WebCamAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);   
                elseif(strcmp(device.type,'beamprofiler'))                      
                    o.initElements{pos}.deviceController=BeamProfilerAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);                 
                elseif(strcmp(device.type,'avt'))                      
                    o.initElements{pos}.deviceController=AVTViewerAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
                elseif(strcmp(device.type,'pixelfly'))
                    o.initElements{pos}.deviceController=PixelFlyViewerAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
                elseif(strcmp(device.type,'andorCCD'))
                    o.initElements{pos}.deviceController=ANDORViewerAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
                elseif(strcmp(device.type,'avtbp'))
                    o.initElements{pos}.deviceController=AVTBeamProfilerAcquisitionDevice(device);
                    ImageAcquisitionDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
                elseif(strcmp(device.type,'oceanremotespect'))
                    o.initElements{pos}.deviceController=OceanOpticsRemoteSpectrometerAcquisitionDevice(device);
                    RemoteDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
                elseif(strcmp(device.type,'pfeiffer'))                      
                    o.initElements{pos}.deviceController=PfeifferMaxiGaugeAcquisitionDevice(device);
                    RemoteDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);  
                elseif(strcmp(device.type,'tektronixvol'))                      
                    o.initElements{pos}.deviceController=TektronixTDS620AVoltageAcquisitionDevice(device);
                    LocalDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);  
                elseif(strcmp(device.type,'tektronixwave'))                      
                    o.initElements{pos}.deviceController=TektronixTDS620AWaveformAcquisitionDevice(device);
                    LocalDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);                  
                elseif(strcmp(device.type,'stagespositions'))  
                    delete(o.initElements{pos}.panels); 
                    o.initElements{pos}.deviceController=StagesPositionRecorderAcquisitionDevice(device,getappdata(0,'StageControllerPanel'));
                    o.initElements{pos}.panels='null';
                elseif(strcmp(device.type,'oceanspect'))
                    o.initElements{pos}.deviceController = OOSpectrometerAcquisitionDevice(device);
                    LocalDevicePanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);
%                     OOSpectPanel(o.initElements{pos}.panels,o.initElements{pos}.deviceController,o.acquisitionDevicesHand);

                end                
            else
                o.initElements{pos}.deviceController.show();                
            end
            update(o);
        end
       
        function comboChanged(o,s,e)
            o.update();
        end
        
        function update(o)
            index=get(o.comboStage,'Value');
            if(isempty(find(o.initialized==index)))
                %set(o.pushInitialize,'String','Open');
            else
                %set(o.pushInitialize,'String','Disconnect');
            end
        end
        
        function delete(o)
            for(i=1:length(o.initialized))
                delete(o.initElements{i}.deviceController);
            end
        end
    end
end

