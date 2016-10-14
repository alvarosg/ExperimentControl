% (c) Alvaro Sanchez Gonzalez 2014
classdef LivePlottingBoxes<LivePlotting
    %LIVEPLOTTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bLabels
        nBoxes
        bLines
        values                
    end
    
    methods
        function o=LivePlottingBoxes(parentC,scanVariableList,label,initialTime,dataTaker,deviceController)
            o = o@LivePlotting(parentC,scanVariableList,label,initialTime,dataTaker,deviceController);
                        
            sizes=zeros([1, length(o.scanVariableList)+1]);
            for i=1:length(o.scanVariableList)
                sizes(i)=length(o.scanVariableList{i}.positions);   
            end
            sizes(end)=o.imageAcquisitionDevice.boxesHand.count();
            o.values=zeros(sizes);
                       

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
                        
            o.updatePlot();
            drawnow
            
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
        
    end
    
end

