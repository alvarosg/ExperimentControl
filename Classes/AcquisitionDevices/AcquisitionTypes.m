% (c) Alvaro Sanchez Gonzalez 2014
classdef AcquisitionTypes
    %STAGETYPES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)       
        names={'avt','avtbp','beamprofiler', 'webcam','oceanspect','oceanremotespect','pfeiffer','tektronixvol','tektronixwave','stagespositions','pixelfly','andorCCD'};        
        strings={'AVT Viewer','AVT Beam Profiler','Webcam Beam Profiler', 'Webcam','Ocean Optics Spectrometer','Remote Ocean Optics Spectrometer','Pfeiffer MaxiGauge Pressures','Tektronix Voltage','Tektronix Waveform','Position of the Stages','Pixelfly Viewer','ANDOR Viewer'};
        format={'image','image','image', 'image','spectrum','spectrum','pressures','voltage','waveform','positions','image','image'};
        mode={'wait','wait','wait', 'wait','wait','nowait','nowait','nowait','nowait','nowait','wait','wait'};
        extraParamInfo={'Boxes File,Crop File','Boxes File,Crop File','Boxes File,Crop File', 'Boxes File,Crop File','N/A','IP','Port','Channels','Channels','N/A','Boxes File,Crop File','Boxes File,Crop File'};
    end
    
    methods (Static)
        function ind = getNameIndex(name)
            ind=find(ismember(AcquisitionTypes.names,name));        
        end
        function name = getIndexName(index)
            name=AcquisitionTypes.names{index};        
        end
        function format = getNameFormat(name)
           format=AcquisitionTypes.format{find(ismember(AcquisitionTypes.names,name))};
        end
        function mode = getNameMode(name)
            mode=AcquisitionTypes.mode{find(ismember(AcquisitionTypes.names,name))};
        end
        
        function extra = getNameExtraParamInfo(name)
            extra=AcquisitionTypes.extraParamInfo{find(ismember(AcquisitionTypes.names,name))};
        end
    end
    
end

