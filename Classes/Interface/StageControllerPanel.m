% (c) Alvaro Sanchez Gonzalez 2014
classdef StageControllerPanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentC
        stagesHand       
         
        pushInitialize
        controlContainer
        controlContainerInOut
        comboStage
        
        initialized
        initElements
      
    end
    
    methods
        function o = StageControllerPanel(parentC,stagesHand)
            o.parentC=parentC;
            o.stagesHand=stagesHand;
            hp = uipanel('Parent',o.parentC,'Title','Stages','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hghv1 = uigridcontainer('v0','Parent',hp,'Units','norm','Position',[0,0,1,1],'GridSize',[2,1], 'VerticalWeight',[1 20]);
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[5,3]);
            
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[5,3]);
            
            o.controlContainer = uigridcontainer('v0','Parent',hghv1h2,'Units','norm','Position',[0,0,1,1],'GridSize',[7,1]);
            o.controlContainerInOut = uigridcontainer('v0','Parent',hghv1h2,'Units','norm','Position',[0,0,1,1],'GridSize',[7,1]);
            
            o.comboStage=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboStage,'Callback',@(s,e)comboChanged(o,s,e))
            
            o.pushInitialize=uicontrol('Parent',hghv1h1,'style','push','string','Initialize');
            set(o.pushInitialize,'Callback',@(s,e)pushedInitialize(o,s,e))
            
            stages=o.stagesHand.getStages();
            names={};
            if(o.stagesHand.count()>0)
                for i=1:o.stagesHand.count();
                    names{i}=[num2str(i) ' - ' stages{i}.name];
                end
            end
            
            set(o.comboStage,'string',names);
            
            update(o)
        end
        
        function pushedInitialize(o,s,e,ind)
            index=get(o.comboStage,'Value');
            if(isempty(find(o.initialized==index)))
                pos=length(o.initialized)+1;
                o.initialized(pos)=index;                               
                stage=o.stagesHand.getStage(index);                
                
                if(strcmp(stage.type,'testtrans'))
                    o.initElements{pos}.stageController=TranslationTestStageClass(stage);
                elseif(strcmp(stage.type,'testrot'))
                    o.initElements{pos}.stageController=RotationTestStageClass(stage);
                elseif(strcmp(stage.type,'thorrot'))
                    o.initElements{pos}.stageController=ThorlabsRotationStageClass(stage);                
                elseif(strcmp(stage.type,'FW102C'))
                    o.initElements{pos}.stageController=ThorlabsFW102CStageClass(stage);
                elseif(strcmp(stage.type,'thortrans'))
                    o.initElements{pos}.stageController=ThorlabsTranslationStageClass(stage);
                elseif(strcmp(stage.type,'PIC843'))
                    o.initElements{pos}.stageController=PIC843TranslationStageClass(stage);
                elseif(strcmp(stage.type,'serialfine'))
                    o.initElements{pos}.stageController=SerialFineTranslationStageClass(stage);
                elseif(strcmp(stage.type,'piezo'))
                    o.initElements{pos}.stageController=PiezoStageClass(stage);
                elseif(strcmp(stage.type,'testpiezo'))
                    o.initElements{pos}.stageController=PiezoTestStageClass(stage);
                elseif(strcmp(stage.type,'owis'))
                    o.initElements{pos}.stageController=OWISTranslationStageClass(stage);
                elseif(strcmp(stage.type,'CEP'))
                    o.initElements{pos}.stageController=RemoteCEPLockStageClass(stage);
                elseif(strcmp(stage.type,'notused'))
                    o.initElements{pos}.stageController='null';
                else
                    o.initElements{pos}.stageController='null';
                end                
                if(strcmp(stage.use,'posdelay'))
                    o.initElements{pos}.useController=PositionDelayUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);          
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'voltagedelay'))
                    o.initElements{pos}.useController=VoltageDelayUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'block'))
                    o.initElements{pos}.useController=InOutUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainerInOut,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageInOutControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'rotblock'))
                    o.initElements{pos}.useController=InOutRotUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainerInOut,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageInOutControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                    o.initElements{pos}.panelClass.useControllerPanel.pushedIn; %set to in position
                elseif(strcmp(stage.use,'discrete'))
                    o.initElements{pos}.useController=DiscretePositionsUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainerInOut,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageDiscretePositionsControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'intensity'))
                    o.initElements{pos}.useController=IntensityUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);  
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                    o.initElements{pos}.useController.setPosition(100);
                elseif(strcmp(stage.use,'polarization'))
                    o.initElements{pos}.useController=PolarizationUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);  
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                    o.initElements{pos}.useController.setPosition(0);
                elseif(strcmp(stage.use,'ellipticity'))
                    o.initElements{pos}.useController=EllipticityUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);   
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                    o.initElements{pos}.useController.setPosition(0);  
                elseif(strcmp(stage.use,'iris'))
                    o.initElements{pos}.useController=IrisUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);   
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageIrisControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'pos1D'))
                    o.initElements{pos}.useController=Positioner1DUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'CEP'))
                    o.initElements{pos}.useController=Positioner1DUseClass(stage,o.initElements{pos}.stageController,o.stagesHand);
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=StageVariableControlPanel(o.initElements{pos}.panels,o.initElements{pos}.stageController,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'pos3D'))
                    %Crate an instance of the class indicated in the
                    %extraparameter
                    command=sprintf('o.initElements{pos}.useController=%s(stage,o.stagesHand);',stage.extraparam);
                    eval(command); 
                    o.initElements{pos}.panels=uipanel('Parent',o.controlContainer,'Title',stage.name,'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
                    o.initElements{pos}.panelClass=Positioner3DControlPanel(o.initElements{pos}.panels,o.initElements{pos}.useController);
                elseif(strcmp(stage.use,'external'))
                    o.initElements{pos}.useController={};  
                    o.initElements{pos}.panels={};
                    o.initElements{pos}.panelClass={};
                else
                    o.initElements{pos}.useController='null';
                end
                
                if(~isempty(o.initElements{pos}.panelClass))
                    o.initElements{pos}.panelClass.stageControllerPanel.update(true);
                end
                
            else
                pos=find(o.initialized==index);
                try
                delete(o.initElements{pos}.stageController);
                delete(o.initElements{pos}.panels);
                delete(o.initElements{pos}.panelClass);                
                delete(o.initElements{pos}.useController);
                catch
                end
                try
                    o.initElements(pos)=[];                       
                catch
                end
                try
                    o.initialized(pos)=[];
                catch
                end
            end
            update(o);
        end
       
        function comboChanged(o,s,e)
            o.update();
        end
        
        function update(o)
            index=get(o.comboStage,'Value');
            if(isempty(find(o.initialized==index)))
                set(o.pushInitialize,'String','Initialize');
            else
                set(o.pushInitialize,'String','Disconnect');
            end
        end
        
        function delete(o)
            for(i=1:length(o.initialized))
                delete(o.initElements{i}.stageController);
                delete(o.initElements{i}.useController);                
            end
        end        
    end
end

