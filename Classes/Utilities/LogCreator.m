% (c) Alvaro Sanchez Gonzalez 2014
classdef LogCreator<handle
    %LOGCREATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        path
    end
    
    methods
        function o=LogCreator(path)
            o.path=path;
            if(~exist(o.path,'dir'))
                mkdir(o.path);
            end
        end
        
        function addEntry(o,string)
            
            c=clock;
            dateString=datestr(c,'yyyymmdd');
            
            if(~exist(fullfile(o.path,dateString),'dir'))
                mkdir(fullfile(o.path,dateString));
            end                        
            filename=sprintf('%s.log',dateString);
            file=fopen(fullfile(o.path,dateString,filename),'a');
            fprintf(file,'[%s] %s\r\n',datestr(c,'yyyy-mm-dd HH:MM:SS'),string);
            fclose(file);                   
        end
    end
    
end

