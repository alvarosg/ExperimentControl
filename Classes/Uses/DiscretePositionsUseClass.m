% (c) Alvaro Sanchez Gonzalez 2014
classdef DiscretePositionsUseClass<AbstractUseClass
    %POSITIONDELAYUSECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        positions
        labels
    end
    
    methods
        function o = DiscretePositionsUseClass(stageInfo,stageController,stagesHand)
            o = o@AbstractUseClass(stageInfo,stageController,stagesHand);
            aux=textscan(o.stageInfo.extraparam,'%s %d',[2,Inf]);
            o.labels=aux{1};
            o.positions=aux{2};
        end
        
        function stagePosition=varPos2stagePos(o,varPosition)
            %Convert in or out to position           
            ind=find(strcmp(o.labels,varPosition),1);
            if(~isempty(ind))
                stagePosition=o.positions(ind);
            else
                error('Unknown position! Check where you are trying to move');
            end
        end
        
        function varPosition=stagePos2varPos(o,stagePosition)
            
            precision=10.^(floor(log10(double(max(o.positions))))-2);    
            
            ind=[];
            posns = double(o.positions);
            for i=1:length(posns)
                if(stagePosition <= (posns(i)+precision/2) && stagePosition >= (posns(i)-precision/2))
                    ind=i;
                    break;
                end
            end
            
            if(~isempty(ind))
                varPosition=o.labels{ind};
            else
                varPosition='intermediate';
            end
        end

        function save(o,ind)
            o.positions(ind)=o.stageController.position();
            newparam='';
            for i=1:length(o.labels)
                newparam=sprintf('%s %s %d',newparam,o.labels{i},o.positions(i));
            end
            o.stagesHand.setExtraParamByName(o.stageInfo.name,newparam);
            o.stageInfo.extraparam=newparam;
            o.stageController.stageInfo.extraparam=newparam;
        end
    end   
end

