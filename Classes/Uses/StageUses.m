% (c) Alvaro Sanchez Gonzalez 2014
classdef StageUses
    %STAGEUSES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        
        strings={'Position Delay Stage','Voltage Delay Stage','Discrete Positions', 'Beam Block or Pickoff Mirror','Rotating block','Intensity Control','Polarization Control','Ellipticity Control','External Control','Positioner3D','Iris','Positioner1D','CEP control'};
        names={'posdelay','voltagedelay','discrete', 'block','rotblock','intensity','polarization','ellipticity','external','pos3D','iris','pos1D','CEP'};
        extraParamInfo={'t_0 pos (um)','t_0 pos (V)','label1 pos1 label2 pos2 ...','[pos in , pos out](mm)','[pos in , pos out](deg)','100% Intensity Angle (deg) , Contrast (%)','Parallel Polarization Angle (deg)','Linear Polarization Angle (deg)','N/A','Positioner Class','Open (deg), Closed(deg), Open->Closed Direction (1/-1)','','N/A'};
        units={'fs','V','position','position','position','%','deg','deg','N/A','um','deg','um','mrad'};
        variable={'Delay Time','Delay Voltage','Position','Position','Position','Intensity','Polarization Angle','Ellipticity Angle','N/A','Position','Position','Position','CEP'};
        scannable={true,true,false,false,false,true,true,true,false,true,false,true,true};
        
    end
    
    methods (Static)
        function ind = getNameIndex(name)
            ind=find(ismember(StageUses.names,name));        
        end
        function name = getIndexName(index)
            name=StageUses.names{index};        
        end
        function unit = getNameUnits(name)
            unit=StageUses.units{find(ismember(StageUses.names,name))};
        end
        function extra = getNameExtraParamInfo(name)
            extra=StageUses.extraParamInfo{find(ismember(StageUses.names,name))};
        end
        function scannable = getNameScannable(name)
            scannable=StageUses.scannable{find(ismember(StageUses.names,name))};
        end
        function variable = getNameVariable(name)
            variable=StageUses.variable{find(ismember(StageUses.names,name))};
        end
    end
end

