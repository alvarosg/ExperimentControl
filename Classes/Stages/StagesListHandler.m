% (c) Alvaro Sanchez Gonzalez 2014
classdef StagesListHandler<handle
    %BOXESHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stages
        path
        extraParamInfo
    end
    
    methods
        function o = StagesListHandler(path)
            o.stages={};
            o.path=path; 
            o.loadFromFile(o.path);
        end
        function saveToFile(o,path)
            try
                stages=o.stages;
                save(path,'stages');
            catch
                disp('Failed to save stages list');
            end
        end
        function loadFromFile(o,path)
            try
                ld=load(path);
                o.stages=ld.stages;
            catch
                disp('Failed to locate stages file');
            end
        end
        function addStage(o,name,serial,type,use,extraparam)
            stage.name=name;
            stage.serial=serial;
            stage.type=type;
            stage.use=use;
            stage.extraparam=extraparam;
            o.stages=[o.stages {stage}];
            o.saveToFile(o.path);
        end
        function addStageInd(o,ind,name,serial,type,use,extraparam)
            if ind<=length(o.stages)+1
                stage.name=name;
                stage.serial=serial;
                stage.type=type;
                stage.use=use;
                stage.extraparam=extraparam;
                o.stages={o.stages{1:ind-1} stage o.stages{ind:end}};
            end
            o.saveToFile(o.path);
        end
        function removeStageInd(o,ind)
            if(ind==1)
                o.stages={o.stages{2:end}};
            elseif(ind==length(o.stages))
                o.stages={o.stages{1:ind-1}};
            else
                o.stages={o.stages{[1:ind-1 ind+1:end]}};
            end
            o.saveToFile(o.path);
        end
        function editStage(o,ind,name,serial,type,use,extraparam)
            if ind<=length(o.stages)
                o.stages{ind}.name=name;
                o.stages{ind}.serial=serial;
                o.stages{ind}.type=type;
                o.stages{ind}.use=use;
                o.stages{ind}.extraparam=extraparam;
            end
            o.saveToFile(o.path);
        end
        function stages = getStages(o)
            stages = o.stages;
        end
        
        function stages = getStage(o,ind)
            stages = o.stages{ind};
        end
        
        function c = count(o)
            c=length(o.stages);
        end
        
        function setExtraParamByName(o,name,extraparam)
            for i=1:length(o.stages)
                if(strcmp(name,o.stages{i}.name))
                    o.stages{i}.extraparam=extraparam;
                    o.saveToFile(o.path);
                    break;
                end
            end
        end
    end
end

