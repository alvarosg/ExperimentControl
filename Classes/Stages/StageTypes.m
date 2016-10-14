% (c) Alvaro Sanchez Gonzalez 2014
classdef StageTypes
    %STAGETYPES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)       
        names={'notused','thortrans','owis', 'thorrot','PIC843','FW102C','serialfine','piezo','smaract','nf8742','testtrans','testrot','testpiezo','CEP'};
        strings={'Not Used','Thorlabs Translation', 'Owis Stage', 'Thorlabs Rotation','PI C-843 ','Filter Wheel FW102C','Serial Port Fine','Piezo','SmarAct Multi Stage','New Focus 8742','Translation Test','Rotation Test','Piezo Test','CEP Control'};
        units={'um','um', 'um', 'deg','um','position','um','V','um','steps','um','deg','V','mrad'};
    end
    
    methods (Static)
        function ind = getNameIndex(name)
            ind=find(ismember(StageTypes.names,name));        
        end
        function name = getIndexName(index)
            name=StageTypes.names{index};        
        end
        function unit = getNameUnits(name)
            unit=StageTypes.units{find(ismember(StageTypes.names,name))};
        end
    end
end

