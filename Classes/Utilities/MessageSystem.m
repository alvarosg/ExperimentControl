% (c) Alvaro Sanchez Gonzalez 2014
classdef MessageSystem<handle
    %MESSAGESYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    

    
    properties
        logCreator
        mainOutput
        secondOutput
        error
        oldColorSecond
        oldColorMain
    end
    
    methods
        
        function o=MessageSystem()
            setappdata(0,'MessageSystem',o);
            o.mainOutput=-1;
            o.secondOutput={};
            o.oldColorSecond={};
            o.error=false;
            o.logCreator=[];
            
        end
        
        function SetLog(o,logCreator)
            o.logCreator=logCreator;
        end
        
        function SetMainOutput(o,mainOutput)
            o.mainOutput=mainOutput;
            o.oldColorMain=get(o.mainOutput,'BackgroundColor');
        end
        
        function AddSecondOutput(o,secondOutput)
            o.secondOutput={o.secondOutput{:},secondOutput};
            o.oldColorSecond={o.oldColorSecond{:},get(secondOutput,'BackgroundColor')};
        end
        
        function ResetSecondOutput(o)
            o.secondOutput={};
            o.oldColorSecond={};
        end
        
        function printMessage(o,type,string,addLog)
            if(addLog)
                if(~isempty(o.logCreator) && isvalid(o.logCreator))
                    o.logCreator.addEntry(sprintf('%s: %s',type,string));
                end
            end
                        
            if(o.error==false)               
                c=clock;
                message=sprintf('[%s] %s\r\n',datestr(c,'HH:MM:SS'),sprintf('%s: %s',type,string));
                if (ishandle(o.mainOutput))
                    set(o.mainOutput,'string',message);
                end
                for i=1:length(o.secondOutput)
                    if (ishandle(o.secondOutput{i}))
                        set(o.secondOutput{i},'string',message);
                    end
                end
                
                if(strcmp(type,'ERROR'))
                    o.error=true;
                    if (ishandle(o.mainOutput))
                        o.oldColorMain=get(o.mainOutput,'BackgroundColor');
                    	set(o.mainOutput,'BackgroundColor',[1 0 0]);
                    end
                    for i=1:length(o.secondOutput)
                        if (ishandle(o.secondOutput{i}))
                            o.oldColorSecond{i}=get(o.secondOutput{i},'BackgroundColor');
                            set(o.secondOutput{i},'BackgroundColor',[1 0 0]);
                        end
                    end
                end
                
                drawnow
            end
        end
        function ResetError(o)
            o.error=false;
            if (ishandle(o.mainOutput))
                set(o.mainOutput,'BackgroundColor',o.oldColorMain);
                set(o.mainOutput,'string','');
            end
            for i=1:length(o.secondOutput)
                if (ishandle(o.secondOutput{i}))
                    set(o.secondOutput{i},'BackgroundColor',o.oldColorSecond{i});
                    set(o.secondOutput{i},'string','');
                end
            end
        end
    end
    
    methods (Static) 
        function messsageSystem=get()        
            messsageSystem=getappdata(0,'MessageSystem');
            if(isempty(messsageSystem) || ~isvalid(messsageSystem))
                messsageSystem=MessageSystem();
            end
        end
    end
    
end

