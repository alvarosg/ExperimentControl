% (c) Alvaro Sanchez Gonzalez 2014
classdef CropRectangleWindow<handle

    properties

        pushPick    
        pushColor
        editRight
        editLeft
        editTop
        editBottom
        checkRectangle
        parentC
        axis
        
        rectangleHand
        shapes
        color
        hg
    end
    
    methods
        function o = CropRectangleWindow(parentC,rectangleHand,axis)
            o.shapes={};
            o.color=[1 0 0];
            o.parentC=parentC;
            o.axis=axis;
            o.rectangleHand=rectangleHand;
            o.hg = uipanel('Parent',o.parentC,'Title','Set Crop Rectangle','FontSize',12,'Position',[0.01 0.01 0.99 0.99]);
            hgh = uigridcontainer('v0','Parent',o.hg,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[2,2,1]);
            hghv1 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv2 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv3 = uiflowcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'FlowDirection','TopDown');
            hghv1h1 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv1h2 = uiflowcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
           
            hghv2h1 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv2h2 = uiflowcontainer('v0','Parent',hghv2,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
            hghv3h1 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            hghv3h2 = uiflowcontainer('v0','Parent',hghv3,'Units','norm','Position',[0,0,1,1],'FlowDirection','LeftToRight');
            
                                                  
            uicontrol('Parent',hghv1h1,'style','text','string','Left')
            o.editLeft=uicontrol('Parent',hghv1h1,'style','edit','BackgroundColor','white');
            set(o.editLeft,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv2h1,'style','text','string','Right')
            o.editRight=uicontrol('Parent',hghv2h1,'style','edit','BackgroundColor','white');
            set(o.editRight,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv1h2,'style','text','string','Top')
            o.editTop=uicontrol('Parent',hghv1h2,'style','edit','BackgroundColor','white');
            set(o.editTop,'Callback',@(s,e)changedEdit(o,s,e))
            uicontrol('Parent',hghv2h2,'style','text','string','Bottom')
            o.editBottom=uicontrol('Parent',hghv2h2,'style','edit','BackgroundColor','white');
            set(o.editBottom,'Callback',@(s,e)changedEdit(o,s,e))
            
            o.checkRectangle=uicontrol('Parent',hghv3h1,'style','check','string','Draw Rectangle','Value',true);
            set(o.checkRectangle,'Callback',@(s,e)drawRectangle(o))
            
            o.pushPick=uicontrol('Parent',hghv3h2,'style','push','string','Pick');
            set(o.pushPick,'Callback',@(s,e)pushedPick(o,s,e))                        
            
            o.pushColor=uicontrol('Parent',hghv3h2,'style','push','string','');
            set(o.pushColor,'Callback',@(s,e)pushedColor(o,s,e))
                                    
            %jModel = javax.swing.SpinnerNumberModel(24,20,35,1);            
            %o.spinNumBox=javax.swing.JSpinner(jModel);
            %jhSpinner = javacomponent(o.spinNumBox, [140,30,60,20], hghv1h1);
            %set(o.spinNumBox,'StateChangedCallback',@(s,e)numBoxesChanged(o,s,e))
            o.updateBoxes(true);
        end      
        

        
        function pushedPick(o,s,e)             

            oldFig=gcf;
            oldAxes=get(gcf,'CurrentAxes');
            f=get(o.axis,'Parent');

            %set(0, 'CurrentFigure', f);
            %set(f, 'CurrentAxes', o.axis);
            axes(o.axis);
            rect=o.rectangleHand.getRectangle();   
            textH=text(2,20,'Crop Rectangle','Color',o.color,'FontSize',40);
            [rect(1),rect(3)] = ginput(1);
            [rect(2),rect(4)] = ginput(1);
            delete(textH);
            rect=round(rect);
            o.rectangleHand.editRectangle(rect);
            figure(oldFig);
            try
                axes(oldAxes);
            catch
            end
            o.updateBoxes(true);                        
        end
        
 
        function pushedColor(o,s,e)
            color=uisetcolor;      
            if (length(color)==3)
                o.color=color;
                updateBoxes(o,true);
            end
        end
        
 
        function changedEdit(o,s,e)
            rect(1)=str2num(get(o.editLeft,'String'));
            rect(2)=str2num(get(o.editRight,'String'));
            rect(3)=str2num(get(o.editTop,'String'));
            rect(4)=str2num(get(o.editBottom,'String'));
            o.rectangleHand.editRectangle(rect)            
            updateBoxes(o,true);
        end
        
        function updateBoxes(o,updateDrawing)
            rect=o.rectangleHand.getRectangle();
            set(o.editLeft,'String',num2str(rect(1)));
            set(o.editRight,'String',num2str(rect(2)));
            set(o.editTop,'String',num2str(rect(3)));
            set(o.editBottom,'String',num2str(rect(4)));
            
            set(o.hg,'Title',sprintf('Set Crop Rectangle (%s)',o.rectangleHand.path));

            if updateDrawing
                o.drawRectangle();
            end
            set(o.pushColor,'BackgroundColor',o.color);
        end
        
        function drawRectangle(o)
            oldFig=gcf;
            oldAxes=get(gcf,'CurrentAxes');
            %f=get(o.axis,'Parent');
            %set(0, 'currentfigure', f);  %# for figures
            %set(f, 'currentaxes', o.axis);
            axes(o.axis);
            
            o.deleteRectangle();
            
            if(get(o.checkRectangle,'Value'))            
            	rect=o.rectangleHand.getRectangle(); 
                o.shapes{1}=rectangle('Position',[rect(1),rect(3),rect(2)-rect(1)+1,rect(4)-rect(3)+1],'LineWidth',3, 'EdgeColor',o.color);            
            end

            figure(oldFig);
            try
                axes(oldAxes);
            catch
            end
        end
        
        function deleteRectangle(o)
            for i=1:length(o.shapes);
                delete(o.shapes{i})
            end
            o.shapes={};
        end
    end
    
end

