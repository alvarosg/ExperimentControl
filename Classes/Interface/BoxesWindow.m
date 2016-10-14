% (c) Alvaro Sanchez Gonzalez 2014
classdef BoxesWindow<handle

    properties
        pushAddBefore
        pushAddAfter
        pushRemove
        pushPick
        pushPickAll
        pushColor
        checkBoxes
        
        comboBox
        editLabel
        editRight
        editLeft
        editTop
        editBottom
        parentC
        axis
        
        boxHand
        
        color
        shapes
        
        hg
    end
    
    methods
        function o = BoxesWindow(parentC,boxHand,axis)
            o.shapes={};
            o.color=[0 1 0];
            o.parentC=parentC;
            o.axis=axis;
            o.boxHand=boxHand;
            o.hg = uipanel('Parent',o.parentC,'Title','Set Boxes','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hgh =uigridcontainer('v0','Parent',o.hg,'Units','norm','Position',[0,0,1,1],'GridSize',[1,5], 'HorizontalWeight',[2,2,1,1,1]);
            hghv1 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv2 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv3 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv4 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv5 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv1h1 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv1h2 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv2h1 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv2h2 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv3h1 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv3h2 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv4h1 = uiflowcontainer('v0','Parent',hghv4,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv4h2 = uiflowcontainer('v0','Parent',hghv4,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
           
                          
                  
            uicontrol('Parent',hghv1h1,'style','text','string','Current Box');
            o.comboBox=uicontrol('Parent',hghv1h1,'style','popupmenu','BackgroundColor','white');
            set(o.comboBox,'Callback',@(s,e)changedCombo(o,s,e))
            
            o.pushAddBefore=uicontrol('Parent',hghv1h2,'style','push','string','Add Before');
            set(o.pushAddBefore,'Callback',@(s,e)pushedAddBefore(o,s,e))
            o.pushAddAfter=uicontrol('Parent',hghv1h2,'style','push','string','Add After');
            set(o.pushAddAfter,'Callback',@(s,e)pushedAddAfter(o,s,e))
            o.pushRemove=uicontrol('Parent',hghv1h2,'style','push','string','Remove');
            set(o.pushRemove,'Callback',@(s,e)pushedRemove(o,s,e))
            
            uicontrol('Parent',hghv2h1,'style','text','string','Label')
            o.editLabel=uicontrol('Parent',hghv2h1,'style','edit','BackgroundColor','white');
            set(o.editLabel,'Callback',@(s,e)changedEdit(o,s,e))
            
            o.pushPickAll=uicontrol('Parent',hghv2h2,'style','push','string','Pick All');
            set(o.pushPickAll,'Callback',@(s,e)pushedPickAll(o,s,e))
            o.pushPick=uicontrol('Parent',hghv2h2,'style','push','string','Pick');
            set(o.pushPick,'Callback',@(s,e)pushedPick(o,s,e))
            
            uicontrol('Parent',hghv3h1,'style','text','string','Left')
            o.editLeft=uicontrol('Parent',hghv3h1,'style','edit','BackgroundColor','white');
            set(o.editLeft,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv4h1,'style','text','string','Right')
            o.editRight=uicontrol('Parent',hghv4h1,'style','edit','BackgroundColor','white');
            set(o.editRight,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv3h2,'style','text','string','Top')
            o.editTop=uicontrol('Parent',hghv3h2,'style','edit','BackgroundColor','white');
            set(o.editTop,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv4h2,'style','text','string','Bottom')
            o.editBottom=uicontrol('Parent',hghv4h2,'style','edit','BackgroundColor','white');
            set(o.editBottom,'Callback',@(s,e)changedEdit(o,s,e))
            
            
            o.checkBoxes=uicontrol('Parent',hghv5,'style','check','string','Draw Boxes','Value',true);
            set(o.checkBoxes,'Callback',@(s,e)drawBoxes(o))
            
            o.pushColor=uicontrol('Parent',hghv5,'style','push','string','');
            set(o.pushColor,'Callback',@(s,e)pushedColor(o,s,e))
                       
            %jModel = javax.swing.SpinnerNumberModel(24,20,35,1);            
            %o.spinNumBox=javax.swing.JSpinner(jModel);
            %jhSpinner = javacomponent(o.spinNumBox, [140,30,60,20], hghv1h1);
            %set(o.spinNumBox,'StateChangedCallback',@(s,e)numBoxesChanged(o,s,e))
            updateBoxes(o,true);
        end      
        
        function pushedAddBefore(o,s,e)
            i=get(o.comboBox,'Value');
            pushedAddIndex(o,s,e,i);
            set(o.comboBox,'Value',i);
            updateBoxes(o,true);
        end
        
        function pushedAddAfter(o,s,e)
            if(o.boxHand.count()==0)
                i=0;
            else
                i=get(o.comboBox,'Value');
            end
            pushedAddIndex(o,s,e,i+1);
            set(o.comboBox,'Value',max([i+1 1]));
            updateBoxes(o,true);
        end
        
        function pushedAddIndex(o,s,e,ind)
            label=get(o.editLabel,'String');
            rect(1)=str2num(get(o.editLeft,'String'));
            rect(2)=str2num(get(o.editRight,'String'));
            rect(3)=str2num(get(o.editTop,'String'));
            rect(4)=str2num(get(o.editBottom,'String'));
            o.boxHand.addBoxInd(ind,rect,label);
            updateBoxes(o,true);
        end
        
        function pushedPick(o,s,e)
            if(o.boxHand.count()>0)                
                i=get(o.comboBox,'Value');
                o.pickBox(i);                
            end            
        end
        
        function pickBox(o,ind)
            oldFig=gcf;
            oldAxes=get(gcf,'CurrentAxes');
            axes(o.axis);
            boxes=o.boxHand.getBoxes();
            label=boxes{ind}.string;      
            label_text=[num2str(ind) ' - ' label];
            rect=boxes{ind}.rect;    
            textH=text(2,20,label_text,'Color',o.color,'FontSize',40);
            [rect(1),rect(3)] = ginput(1);
            [rect(2),rect(4)] = ginput(1);
            rect=round(rect);
            delete(textH);
            o.boxHand.editBox(ind,rect,label);
            figure(oldFig);
            try
                axes(oldAxes);
            catch
            end
            o.updateBoxes(true);
        end
        
        function pushedPickAll(o,s,e)            
            if(o.boxHand.count()>0)
                for i=1:o.boxHand.count();
                    o.pickBox(i);                                      
                end               
            end            
        end
        
        function pushedColor(o,s,e)
            color=uisetcolor;      
            if (length(color)==3)
                o.color=color;
                updateBoxes(o,true);
            end           
        end
        
        
        function pushedRemove(o,s,e)
            i=get(o.comboBox,'Value');
            o.boxHand.removeBoxInd(i)
            set(o.comboBox,'Value',max([i-1 1]));
            updateBoxes(o,true);
        end
        
        function changedCombo(o,s,e)
            updateBoxes(o,false);
        end
        
        function changedEdit(o,s,e)
            label=get(o.editLabel,'String');
            rect(1)=str2num(get(o.editLeft,'String'));
            rect(2)=str2num(get(o.editRight,'String'));
            rect(3)=str2num(get(o.editTop,'String'));
            rect(4)=str2num(get(o.editBottom,'String'));
            i=get(o.comboBox,'Value');
            o.boxHand.editBox(i,rect,label)
            
            updateBoxes(o,true);
        end
        
        function updateBoxes(o,updateDrawing)
            boxes=o.boxHand.getBoxes();
            if(o.boxHand.count()>0)
                for i=1:o.boxHand.count();
                    labels{i}=[num2str(i) ' - ' boxes{i}.string];
                end
                set(o.comboBox,'String',labels);

                i=get(o.comboBox,'Value');
                set(o.editLabel,'String',boxes{i}.string);
                set(o.editLeft,'String',num2str(boxes{i}.rect(1)));
                set(o.editRight,'String',num2str(boxes{i}.rect(2)));
                set(o.editTop,'String',num2str(boxes{i}.rect(3)));
                set(o.editBottom,'String',num2str(boxes{i}.rect(4)));
            else
                set(o.comboBox,'String','(empty)');
            end
            
            set(o.hg,'Title',sprintf('Set Boxes (%s)',o.boxHand.path));
            
            if updateDrawing
                o.drawBoxes();
            end
            set(o.pushColor,'BackgroundColor',o.color);
        end
        
        function drawBoxes(o)
            oldFig=gcf;
            oldAxes=get(gcf,'CurrentAxes');
            axes(o.axis)
                        
            o.deleteBoxes();
            
            if(get(o.checkBoxes,'Value'))            
                boxes=o.boxHand.getBoxes();
                if(o.boxHand.count()>0)
                    for i=1:o.boxHand.count();
                        label=boxes{i}.string;
                        label_text=[num2str(i) ' - ' label];
                        rect=boxes{i}.rect;
                        o.shapes{2*(i-1)+1}=rectangle('Position',[rect(1),rect(3),rect(2)-rect(1)+1,rect(4)-rect(3)+1],'LineWidth',3, 'EdgeColor',o.color);
                        o.shapes{2*(i-1)+2}=text(rect(1),rect(3)-30,label_text,'Color',o.color,'FontSize',10);
                    end
                end            
            end
            
            figure(oldFig);
            try
                axes(oldAxes);
            catch
            end                       
        end
        
        function deleteBoxes(o)
            for i=1:length(o.shapes);
                delete(o.shapes{i})
            end
            o.shapes={};
        end
    end
    
end

