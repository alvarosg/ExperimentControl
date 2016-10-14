% (c) Alvaro Sanchez Gonzalez 2014
classdef LivePlottingProfile<LivePlotting
    %LIVEPLOTTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        values
        imageplotted
    end
    
    methods
        function o=LivePlottingProfile(parentC,scanVariableList,label,initialTime,dataTaker,deviceController)
            o = o@LivePlotting(parentC,scanVariableList,label,initialTime,dataTaker,deviceController);
                        
            sizes=zeros([1, length(o.scanVariableList)+1]);
            for i=1:length(o.scanVariableList)
                sizes(i)=length(o.scanVariableList{i}.positions);   
            end
            
            rectangle=o.imageAcquisitionDevice.cropHand.rectangle;
            
            sizes(end)=rectangle(2)-rectangle(1)+1;
            o.values=zeros(sizes);
            
            o.imageplotted=imagesc([0,1],[rectangle(1),rectangle(2)],[0,0;0,0],'Parent',o.plotAxis);
            set(o.plotAxis,'YDir','normal')
            ylabel(o.plotAxis,'Projected axis (Pix)')        
            ylim(o.plotAxis,[rectangle(1),rectangle(2)])
            colorbar('peer',o.plotAxis)
                     
            o.setCombosPoints();
            o.updateSelection();
            o.updatePlot();
            
            drawnow
            
        end
                
        function updatePlot(o)
            
            selection=num2cell(o.selection);
            currentVariable=get(o.comboVariable,'Value');
            selection{currentVariable}=':';
            selection{length(selection)+1}=':';
            selection{length(selection)}=':';
            
            data=o.values(selection{:});         
                        
            set(o.imageplotted,'XData',o.scanVariableList{currentVariable}.positions,'CData',squeeze(data)');
                     
            drawnow
        end
                
        function addPoint(o,indices)
            %To access like(values(indicesCell(1),indicesCell(2),...indicesCell(n),:)
            
            setCombosPoints(o)
            indicesOrdered=ScanVariable.StagesIteration2PositionIndices(indices,o.scanVariableList);
            indicesCell=num2cell(indicesOrdered);
            indicesCell{length(indicesCell)+1}=':';
            projection=o.imageAcquisitionDevice.projectionSlice();
            o.values(indicesCell{:})=projection;
            
            
            o.updateSteps(indices);
            o.updatePlot();
            pause(1);
            
        end
        
        
    end
    
end

