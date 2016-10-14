% (c) Alvaro Sanchez Gonzalez 2014
classdef LivePlotting<handle
    %LIVEPLOTTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scanVariableList
        label
        bLabels
        nBoxes
        bLines

        
        initialTime
        imageAcquisitionDevice
        dataTaker
        values
        parentC
        plotAxis
        comboVariable
        labelsPoints
        combosPoints
        stageNames
        var
        
        selection
        textVariableSteps
        textStep
        textTimeRemaining
        
        
    end
    
    methods
        function o=LivePlotting(parentC,scanVariableList,label,initialTime,dataTaker,deviceController)
            set(parentC,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            o.parentC=parentC;
            o.scanVariableList=scanVariableList;
            o.label=label;
            o.initialTime=initialTime;
            o.dataTaker=dataTaker;
            o.imageAcquisitionDevice=deviceController;
            
            o.labelsPoints={};
            o.combosPoints={};
            
            sizes=zeros([1, length(o.scanVariableList)+1]);
            o.stageNames={};
            for i=1:length(o.scanVariableList)
                sizes(i)=length(o.scanVariableList{i}.positions);   
                o.stageNames{i}=o.scanVariableList{i}.controller.stageInfo.name;
                o.var{i}.units=StageUses.getNameUnits(o.scanVariableList{i}.controller.stageInfo.use);
                o.var{i}.variable=StageUses.getNameVariable(o.scanVariableList{i}.controller.stageInfo.use);
                o.var{i}.labels={};
                for j=1:length(o.scanVariableList{i}.positions)
                    o.var{i}.labels{j}=sprintf('%g %s',o.scanVariableList{i}.positions(j),o.var{i}.units);
                end
                o.selection(i)=1;
            end
            sizes(end)=o.imageAcquisitionDevice.boxesHand.count();
            o.values=zeros(sizes);
                       
            
            
            hgh = uigridcontainer('v0','Parent',o.parentC,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1]);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[4,1], 'VerticalWeight',[1 0.5 11.5 max(2,length(o.scanVariableList))]);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1]);
            textStatus=uicontrol('Parent',hghv1,'style','text','FontSize',10);
            MessageSystem.get().SetSecondOutput(textStatus);
            hghv1h2 = uipanel('Parent',hghv1,'Position',[0,0,1,1], 'BorderType','none');
            hghv1h3 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[1 1 1]);
            
            o.plotAxis=axes('Parent',hghv1h2,'Position',[0.05,0.1,0.9,0.85]);
            
            hghv1h3v1 = uigridcontainer('v0','Parent',hghv1h3,'Units','norm','Position',[0,0,1,1],'GridSize',[length(o.scanVariableList),3],'HorizontalWeight',[2 1 1], 'VerticalWeight',ones([1,(length(o.scanVariableList))]));
            hghv1h3v2 = uigridcontainer('v0','Parent',hghv1h3,'Units','norm','Position',[0,0,1,1],'GridSize',[2,2], 'VerticalWeight',[1 1], 'HorizontalWeight',[1 1]);
            hghv1h3v3 = uigridcontainer('v0','Parent',hghv1h3,'Units','norm','Position',[0,0,1,1],'GridSize',[length(o.scanVariableList),2],'HorizontalWeight',[1 1], 'VerticalWeight',[2 ones([(length(o.scanVariableList)-1),1])]);
            
            uicontrol('Parent',hghv1h1,'style','text','FontSize',24,'string',o.label)
            
            for i=1:(length(o.scanVariableList))
                o.textVariableSteps{i}.name=uicontrol('Parent',hghv1h3v1,'style','text','FontSize',10,'HorizontalAlignment','Left','string',sprintf('%s:',o.stageNames{i}));
                o.textVariableSteps{i}.steps=uicontrol('Parent',hghv1h3v1,'style','text','FontSize',10,'HorizontalAlignment','Left');
                o.textVariableSteps{i}.curr=uicontrol('Parent',hghv1h3v1,'style','text','FontSize',10,'HorizontalAlignment','Left');                
            end
            
            uicontrol('Parent',hghv1h3v2,'style','text','FontSize',16,'HorizontalAlignment','Left','string','Step:');
            o.textStep=uicontrol('Parent',hghv1h3v2,'style','text','FontSize',16);
            uicontrol('Parent',hghv1h3v2,'style','text','FontSize',16,'HorizontalAlignment','Left','string','Time Remaining:');
            o.textTimeRemaining=uicontrol('Parent',hghv1h3v2,'style','text','FontSize',16);
            
            uicontrol('Parent',hghv1h3v3,'style','text','FontSize',10,'string','Variable for the plot:')
            o.comboVariable=uicontrol('Parent',hghv1h3v3,'style','popupmenu','BackgroundColor','white','FontSize',10,'string',o.stageNames);
            set(o.comboVariable,'Callback',@(s,e)changedVariable(o,s,e))
            set(o.comboVariable,'Value',length(o.scanVariableList));
                        
            for i=1:(length(o.scanVariableList)-1)
                o.labelsPoints{i}=uicontrol('Parent',hghv1h3v3,'style','text','FontSize',10);
                o.combosPoints{i}=uicontrol('Parent',hghv1h3v3,'style','popupmenu','BackgroundColor','white','FontSize',10);
                set(o.combosPoints{i},'Callback',@(s,e)changedSelection(o,s,e))
            end
            
            o.nBoxes=o.imageAcquisitionDevice.boxesHand.count();
            if(o.nBoxes>0)
                boxes=o.imageAcquisitionDevice.boxesHand.getBoxes();
                color=jet(o.nBoxes);
                for i=1:o.nBoxes;
                    o.bLabels{i}=[num2str(i) ' - ' boxes{i}.string];
                    o.bLines{i}=line([0 1],[0 0],'Color',color(i,:),'Parent',o.plotAxis);
                end
                legend(o.plotAxis,o.bLabels,'Location','NorthEast')
            end
            
            o.initialTime=clock;
            
            o.setCombosPoints();
            o.updateSelection();
            o.updateSteps(ones([(length(o.scanVariableList)),1]));
            o.updatePlot();
            drawnow
            
        end
        
        function setCombosPoints(o)                        
            counter=0;
            currentVariable=get(o.comboVariable,'Value');
            for i=1:length(o.scanVariableList)
                if(i~=currentVariable)
                    counter=counter+1;
                    set(o.labelsPoints{counter},'string',o.stageNames{i});
                    set(o.combosPoints{counter},'string',o.var{i}.labels);
                    set(o.combosPoints{counter},'Value',o.selection(i));
                end
            end       
            
            xlabel(o.plotAxis,sprintf('%s (%s)',o.var{currentVariable}.variable,o.var{currentVariable}.units));
        end
        
        function updatePlot(o)
            
            selection=num2cell(o.selection);
            currentVariable=get(o.comboVariable,'Value');
            selection{currentVariable}=':';
            selection{length(selection)+1}=':';
            
            for i=1:o.nBoxes
                selection{length(selection)}=i;
                data=o.values(selection{:});
                set(o.bLines{i},'XData',o.scanVariableList{currentVariable}.positions,'YData',data(:));
            end
           
            drawnow
        end
        
        function updateSelection(o)
            counter=0;
            currentVariable=get(o.comboVariable,'Value');
            for i=1:length(o.scanVariableList)
                if(i~=currentVariable)
                    counter=counter+1;
                    o.selection(i)=get(o.combosPoints{counter},'Value');
                end
            end  
        end
        
        function updateSteps(o,indices)
            
            indicesOrder=ScanVariable.StagesIteration2PositionIndices(indices,o.scanVariableList);
            
            for i=1:length(o.scanVariableList)
                set(o.textVariableSteps{i}.steps,'string',sprintf('%4i/%4i',indices(i),length(o.scanVariableList{i}.positions)));
                set(o.textVariableSteps{i}.curr,'string',sprintf('(%g %s)',o.scanVariableList{i}.positions(indicesOrder(i)),o.var{i}.units));               
            end  
            
            totalSteps=1;
            currentStep=0;
            indices(end)=indices(end)+1;
            for i=length(o.scanVariableList):-1:1
                currentStep=currentStep+(indices(i)-1)*totalSteps;
                totalSteps=totalSteps*length(o.scanVariableList{i}.positions);                
            end 
            
            set(o.textStep,'string',sprintf('%4i/%4i',currentStep,totalSteps));
            timeRemaining=etime(clock,o.initialTime)*((totalSteps-currentStep)/currentStep);
            set(o.textTimeRemaining,'string',sprintf('%s',secs2hms(timeRemaining)));
            
            
        end
        
        function changedSelection(o,s,e)
            o.updateSelection();
            o.updatePlot();
        end
        
        function changedVariable(o,s,e)
            o.setCombosPoints();
            o.updateSelection();            
            o.updatePlot();
        end
        
        function addPoint(o,indices)
            %To access like(values(indicesCell(1),indicesCell(2),...indicesCell(n),:)
            
            setCombosPoints(o)
            indicesOrdered=ScanVariable.StagesIteration2PositionIndices(indices,o.scanVariableList);
            indicesCell=num2cell(indicesOrdered);
            indicesCell{length(indicesCell)+1}=':';
            areas=o.imageAcquisitionDevice.areaBoxes();
            o.values(indicesCell{:})=areas;
            
            o.updateSteps(indices);
            o.updatePlot();
            pause(1);
            
        end
        
        function saveMatrix(path)
            
        end
        
        function closedWindow(o,s,e)          
            o.delete()
        end
    end
    
end

