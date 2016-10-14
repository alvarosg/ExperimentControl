% (c) Alvaro Sanchez Gonzalez 2014
classdef MetadataPanel<handle
    %STAGECONTROLLERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        window
        metadataHand 
        path
        label
        
        hp
        
        editFields
        
        pushSave
         

        
        updateList
      
    end
    
    methods
        function o = MetadataPanel(metadataHand)
            o.metadataHand=metadataHand;
            o.label='label';
            o.path='path';
            o.window=-1;
                        
            update(o,true);
        end         
        
        
        function plotWindow(o)
            o.window=figure('name','Metadata','NumberTitle','off','position',[200 50 750 450]);
            set(o.window, 'menubar', 'none');
            set(o.window,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            o.hp = uipanel('Parent',o.window,'Title',sprintf('Metadata for %s',o.label),'FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hgv1 = uiflowcontainer('v0','Parent',o.hp,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
             
            
            fields=o.metadataHand.fields;
            for i=1:o.metadataHand.count()
                hgv1h = uiflowcontainer('v0','Parent',hgv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
                uicontrol('Parent',hgv1h,'style','text','string',fields{i}.name)
                o.editFields{i}=uicontrol('Parent',hgv1h,'style','edit','BackgroundColor','white');
            end  
            
            o.pushSave=uicontrol('Parent',hgv1,'style','push','string','Save');
            set(o.pushSave,'Callback',@(s,e)pushedSave(o,s,e))
            
            update(o,true);            
        end
        
        function setLabelPath(o,label,path)
            o.label=label;
            o.path=path;
            set(o.hp,'Title',sprintf('Metadata for %s',o.label));
            update(o,true);
        end
        
        function pushedSave(o,s,e)
            metadata={};
            metadata.time.value=datestr(clock);
            metadata.time.name='Date';
            
            fields=o.metadataHand.fields;
            for i=1:o.metadataHand.count()
                value=get(o.editFields{i},'string');
                name=fields{i}.name;
                eval(sprintf('metadata.%s.name=name;',fields{i}.varname));
                eval(sprintf('metadata.%s.value=value;',fields{i}.varname));
            end
                        
            save(o.path,'metadata');            
            set(o.hp,'Title',sprintf('Metadata for %s (Saved %s)',o.label,datestr(clock)));
            set(o.window, 'WindowStyle', 'normal');
        end
        
        function closedWindow(o,s,e)
            o.window=-1;
        end
        
        function makeModal(o,s,e)
            set(o.window, 'WindowStyle', 'modal');
        end
         
        function addUpdateList(o,element)
            o.updateList{length(o.updateList)+1}=element;
        end
         
        function update(o,updateAll)

            if(updateAll)
                for i=1:length(o.updateList)
                    o.updateList{i}.update(false);
                end
            end
        end
        
        function delete(o)
            if (ishandle(o.window))
                delete(o.window);
            end
        end
    end
end

