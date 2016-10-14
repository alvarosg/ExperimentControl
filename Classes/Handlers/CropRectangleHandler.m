% (c) Alvaro Sanchez Gonzalez 2014
classdef CropRectangleHandler<handle
    %BOXESHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rectangle
        path
    end
    
    methods
        function o = CropRectangleHandler(path)
            o.rectangle=[1 2000 1 2000];
            o.path=path; 
            o.loadFromFile(o.path);
        end
        function saveToFile(o,path)
            try
                rectangle=o.rectangle;
                save(path,'rectangle');
            catch
                disp('Failed to save crop rectangle position');
            end
        end
        function loadFromFile(o,path)
            try
                o.path=path;
                ld=load(path);
                o.rectangle=ld.rectangle;
                o.checkRectangle();                
            catch
                disp('Failed to locate crop rectangle file');
            end
        end


        function editRectangle(o,rect)
            o.rectangle=rect;
            o.checkRectangle();
            o.saveToFile(o.path);
        end
        function rect = getRectangle(o)
            rect = o.rectangle;
        end
        
        
        function checkRectangle(o)
            if(o.rectangle(1)>o.rectangle(2))
                aux=o.rectangle(1);
                o.rectangle(1)=o.rectangle(2);
                o.rectangle(2)=aux;
            end
            if(o.rectangle(3)>o.rectangle(4))
                aux=o.rectangle(3);
                o.rectangle(3)=o.rectangle(4);
                o.rectangle(4)=aux;
            end
        end
    end
end

