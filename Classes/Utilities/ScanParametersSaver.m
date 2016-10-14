% (c) Alvaro Sanchez Gonzalez 2014
classdef ScanParametersSaver
    %DATASAVER Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods (Static)
        function SaveToFile(scanVariableList,path)
            scanparameters={};
            scanparameters.dim=length(scanVariableList);
            for i=1:length(scanVariableList)
                scanparameters.variables{i}.usepositions=scanVariableList{i}.positions;
                scanparameters.variables{i}.usescanorder=scanVariableList{i}.scanOrder;
                scanparameters.variables{i}.useunits=StageUses.getNameUnits(scanVariableList{i}.controller.stageInfo.use);
                scanparameters.variables{i}.stagepositions=scanVariableList{i}.controller.varPos2stagePos(scanVariableList{i}.positions);
                scanparameters.variables{i}.stagepositions
                scanparameters.variables{i}.stageunits=StageTypes.getNameUnits(scanVariableList{i}.controller.stageInfo.type);
                if(strcmp(scanparameters.variables{i}.stageunits,'N/A'))
                    scanparameters.variables{i}.stageunits=scanparameters.variables{i}.useunits;
                end                
                scanparameters.variables{i}.stageInfo=scanVariableList{i}.controller.stageInfo;                
            end            
            scanparameters.date=datestr(clock);                                    
            save(path,'scanparameters');                                                      
        end        
    end    
end

