% (c) Alvaro Sanchez Gonzalez 2014
classdef DataLabeler<handle
    %DATALABELER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        label
        number
        date
        path
        pathFolder=''
    end
    
    methods
        function o=DataLabeler(path)            
            o.path=path;
            o.label='Test';
            o.number=1;
            
            if(~exist(path,'dir'))
                mkdir(path)
            end          
        end
        
        function setLabel(o,label)
            o.label=label;
            o.correctNumber();
        end
        
        function label=getLabel(o)
            label=o.label;
        end
        
        function number=getNumber(o)
            o.correctNumber();
            number=o.number;
        end
        
        function label=getFullLabel(o)
            o.correctNumber();
            label=sprintf('%s_%s_%s',o.date,o.number,o.label);
        end   
        
        function label=getCurrentLabel(o)
            label=sprintf('%s_%s',o.number,o.label);
        end 
        
        function path=getCurrentFullPathFolder(o)                        
            path=fullfile(o.path,o.date,sprintf('%s_%s_%s',o.date,o.number,o.label));           
        end
        
        function path=getFullPathFolder(o)           
            o.correctNumber();
            path=fullfile(o.path,o.date,sprintf('%s_%s_%s',o.date,o.number,o.label));
            if(~exist(path,'dir'))
                mkdir(path)
            end            
        end
        
        function correctNumber(o)
            c=clock;
            o.date=datestr(c,'yyyymmdd');
            
            if(~exist(fullfile(o.path,o.date),'dir'))
                mkdir(fullfile(o.path,o.date))
            end  
            
            o.number=datestr(c,'HHMMSS');
            while(exist(fullfile(o.path,o.date,sprintf('%s_%s_%s',o.date,o.number,o.label),'dir')))                
                o.number=datestr(c,'HHMMSS');
            end
        end         
    end
    
end

