% (c) Alvaro Sanchez Gonzalez 2014
classdef BoxesHandler<handle
    %BOXESHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        boxes
        path
    end
    
    methods
        function o = BoxesHandler(path)
            o.boxes={};
            o.path=path; 
            o.loadFromFile(o.path);
        end
        function saveToFile(o,path)
            try               
                boxes=o.boxes;
                save(path,'boxes');
            catch
                disp('Failed to save box positions');
            end
        end
        function loadFromFile(o,path)
            try     
                o.path=path;
                ld=load(path);
                o.boxes=ld.boxes;
                o.checkBoxes();                
            catch
                disp('Failed to locate boxes file');
            end
        end
        function addBox(o,rect,string)
            box.string=string;
            box.rect=rect;
            o.boxes=[o.boxes {box}];
            o.checkBoxes();
            o.saveToFile(o.path);
        end
        function addBoxInd(o,ind,rect,string)
            if ind<=length(o.boxes)+1
                box.string=string;
                box.rect=rect;
                o.boxes={o.boxes{1:ind-1} box o.boxes{ind:end}};
            end
            o.checkBoxes();
            o.saveToFile(o.path);
        end
        function removeBoxInd(o,ind)
            if(ind==1)
                o.boxes={o.boxes{2:end}};
            elseif(ind==length(o.boxes))
                o.boxes={o.boxes{1:ind-1}};
            else
                o.boxes={o.boxes{[1:ind-1 ind+1:end]}};
            end
            o.saveToFile(o.path);
        end
        function editBox(o,ind,rect,string)
            if ind<=length(o.boxes)
                o.boxes{ind}.string=string;
                o.boxes{ind}.rect=rect;
            end
            o.checkBoxes();
            o.saveToFile(o.path);
        end
        function boxes = getBoxes(o)
            boxes = o.boxes;
        end
        
        function c = count(o)
            c=length(o.boxes);
        end
        
        function checkBoxes(o)
            for i=1:length(o.boxes)
                if(o.boxes{i}.rect(1)>o.boxes{i}.rect(2))
                    aux=o.boxes{i}.rect(1);
                    o.boxes{i}.rect(1)=o.boxes{i}.rect(2);
                    o.boxes{i}.rect(2)=aux;
                end
                if(o.boxes{i}.rect(3)>o.boxes{i}.rect(4))
                    aux=o.boxes{i}.rect(3);
                    o.boxes{i}.rect(3)=o.boxes{i}.rect(4);
                    o.boxes{i}.rect(4)=aux;
                end
            end
        end
    end
end

