% (c) Alvaro Sanchez Gonzalez 2014
classdef SpectrumPlotWindow<handle
    %SPECTRUMPLOTWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller;
        spectrum;
        checkContinuous;
        textPeakPosition;
        textError;
        plotWl;
        plotTime;
        lineWl;
        lineTime;
        tim;
        window
    end
    
    methods
        function o=SpectrumPlotWindow(controller)
            o.controller=controller;
            
            %Create the timer
            o.tim = timer('StartDelay', 0.1, 'Period', 0.2, 'TasksToExecute', Inf, 'ExecutionMode', 'fixedSpacing');
            o.tim.TimerFcn = {@(s,e)timerTriggered(o,s,e)};            
            
            o.window=figure('name',o.controller.deviceInfo.name,'NumberTitle','off','position',[200 50 700 700]);
            set(o.window, 'menubar', 'none','toolbar','figure');            
            set(o.window,'DeleteFcn',@(s,e)closedWindow(o,s,e));
            
            hgh = uigridcontainer('v0','Parent',o.window,'Units','norm','Position',[0,0,1,1],'GridSize',[1,1]);            
            hghv1 = uigridcontainer('v0','Parent',hgh,'Units','norm','Position',[0,0,1,1],'GridSize',[3,1], 'VerticalWeight',[0.6 0.8 19]);
            
            hghv1h1 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,3], 'HorizontalWeight',[2 1 1]);            
            o.textError = uicontrol('Parent',hghv1,'style','text','string','','ForegroundColor',[1 0 0],'FontSize',15);
            hghv1h2 = uigridcontainer('v0','Parent',hghv1,'Units','norm','Position',[0,0,1,1],'GridSize',[1,2], 'HorizontalWeight',[1 1]);
            hghv1h2p1 = uipanel('Parent',hghv1h2,'Position',[0,0,1,1], 'BorderType','none');
            hghv1h2p2 = uipanel('Parent',hghv1h2,'Position',[0,0,1,1], 'BorderType','none');
                        
            o.checkContinuous=uicontrol('Parent',hghv1h1,'style','check','string','Continuous:');
            set(o.checkContinuous,'Callback',@(s,e)checkedContinuous(o,s,e))
            
            uicontrol('Parent',hghv1h1,'style','text','string','Peak position (fs):');
            o.textPeakPosition=uicontrol('Parent',hghv1h1,'style','text');
            
            o.plotWl=axes('Parent',hghv1h2p1,'Position',[0.05,0.1,0.9,0.85]);
            xlabel(o.plotWl,'wavelength (nm)')
            ylabel(o.plotWl,'intensity (au)')
            o.plotTime=axes('Parent',hghv1h2p2,'Position',[0.05,0.1,0.9,0.85]);
            xlabel(o.plotTime,'time (fs)')
            ylabel(o.plotTime,'intensity (au)')
            
            o.lineWl=line([0 1],[0 0],'Color',[0 0 0],'Parent',o.plotWl);
            o.lineTime=line([0 1],[0 0],'Color',[0 0 0],'Parent',o.plotTime);
        end
        
        function checkedContinuous(o,s,e)
            if get(o.checkContinuous,'Value')==1
                start(o.tim);
            else
                stop(o.tim);
            end
        end
        
        function refresh(o)
            try
                o.controller.resetBuffer();
                o.controller.acquisition();  
                o.spectrum=o.controller.retrieve();            
                o.updatePlot();
                set(o.textError,'String','');
            catch
                set(o.textError,'String','Communication Error');
            end
        end
        
        function updatePlot(o)
            
            wlExp=o.spectrum.wl';
            signal=o.spectrum.avg';
        
            c=300; %nm/fs
            wExp=fliplr(2*pi*c./wlExp);
            dw=wExp(2)-wExp(1);
            wN=min(wExp):dw:max(wExp);
            tmaxN=pi/dw;
            tN=linspace(-tmaxN,tmaxN,length(wN));

            spect=interp1(wExp,fliplr(signal),wN,'linear');

            timeDomain=fftshift(ifft(ifftshift(spect)));

            % Locating the position of the maximum
            [maxVal, maxInd]=max(abs(timeDomain.*(tN>300)));
            center=tN(maxInd(1));
            set(o.textPeakPosition,'String',num2str(center));
        
            set(o.lineWl,'XData',wlExp,'YData',signal);
            set(o.lineTime,'XData',tN,'YData',abs(timeDomain));
                
        end
        
        function timerTriggered(o,s,e)
            o.refresh();            
        end
        
        function closedWindow(o,s,e)         
            o.delete();
        end
        
        function delete(o)
            stop(o.tim);
            delete(o.tim);
            if(ishandle(o.window))
                delete(o.window);
            end
        end
    end
    
end

