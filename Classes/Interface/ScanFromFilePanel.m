classdef ScanFromFilePanel<handle
    properties
        parentC
        acquisitionControllerPanel
        stageControllerPanel
        metadataPanel
        pathOutput
        pathInstructionFile
        InstructionFile
        acqDevices
        stages
        scanRunning
        scanPaused
        LivePlot
        savenum
        
        InstructionsList
        pushLoadFile
        RunTimeText
        FoundDevicesText
        NonFoundDevicesText
        FoundStagesText
        NonFoundStagesText
        pushRun
        pushPause
        enterScanName
    end
    
    methods
        function o = ScanFromFilePanel(parentC,acquisitionControllerPanel,stageControllerPanel,metadataPanel,pathOutput)
            o.parentC = parentC;
            set(o.parentC,'CloseRequestFcn',@(s,e) delete(o))
            o.acquisitionControllerPanel = acquisitionControllerPanel;
            o.stageControllerPanel = stageControllerPanel;
            o.metadataPanel = metadataPanel;
            o.pathOutput = pathOutput;
            
            hbox_main = uiextrasX.HBox('Parent',parentC);
            defer(hbox_main)
            vbox_left = uiextrasX.VBox('Parent',hbox_main);
            panel_loadfile = uiextrasX.Panel('Parent',vbox_left);
            o.pushLoadFile = uicontrol('Parent',panel_loadfile,'Style','push','String','Load File','Callback',@(s,e) pushedLoadFile(o));
            vbox_instrlist = uiextrasX.VBox('Parent',vbox_left);
            InstrListText = uicontrol('Parent',vbox_instrlist,'Style','Text','String','Function Code:');
            o.InstructionsList = uicontrol('Parent',vbox_instrlist,'style','edit','enable','inactive','Max',25e3);
            
            vbox_right = uiextrasX.VBox('Parent',hbox_main);
            vbox_scanInfo = uiextrasX.VBox('Parent',vbox_right);
            o.RunTimeText = uicontrol('Parent',vbox_scanInfo,'style','text','String','Runtime: 0s');
            o.FoundDevicesText = uicontrol('Parent',vbox_scanInfo,'style','text','String','');
            o.NonFoundDevicesText = uicontrol('Parent',vbox_scanInfo,'style','text','String','');
            o.FoundStagesText = uicontrol('Parent',vbox_scanInfo,'style','text','String','');
            o.NonFoundStagesText = uicontrol('Parent',vbox_scanInfo,'style','text','String','');
            
            nameText = uicontrol('Parent',vbox_right,'style','text','String','Enter scan name:');
            o.enterScanName = uicontrol('Parent',vbox_right,'style','edit','String','Test','BackgroundColor',[1 1 1]);
            hbox_runpause = uiextrasX.HBox('Parent',vbox_right);
            o.pushRun = uicontrol('Parent',hbox_runpause,'style','push','String','Run','Callback',@(s,e) pushedRun(o),'enable','off');
            o.pushPause = uicontrol('Parent',hbox_runpause,'style','push','String','Pause','Callback',@(s,e) pushedPause(o),'enable','off');
            
            set(vbox_instrlist,'Sizes',[20 -1]);
            set(vbox_left,'Sizes',[50 -1]);
            set(vbox_right,'Sizes',[-1 20 35 50]);
            set(hbox_main,'Sizes',[450 200]);
            
            resume(hbox_main)
            
        end
        
        function pushedLoadFile(o)
            [fname,fpath] = uigetfile(fullfile(consortium_matlab_dir,'lib_chris','Beamline','Scan_Defs','InstructionFiles'));
            if fname
                o.pathInstructionFile = fullfile(fpath,fname);
                o.InstructionFile = load(o.pathInstructionFile);
                ok = retrieveDevices(o);
                updateInstructionsList(o)
                if ok
                    updateRunTime(o)
                    set(o.pushRun,'enable','on')
                else
                    set(o.pushRun,'enable','off')
                end
            end
        end
        
        function pushedRun(o)
            if o.scanRunning
                o.scanRunning = false;
                set(o.pushRun,'String','Run')
                set(o.pushPause,'enable','off')
            else
                set(o.pushRun,'String','Stop')
                set(o.pushPause,'enable','on')
                PerformScan(o)
                set(o.pushRun,'String','Run')
                set(o.pushPause,'enable','off')
            end
        end
        
        function pushedPause(o)
           if o.scanPaused
               o.scanPaused = false;
               set(o.pushPause,'String','Pause')
           else
               o.scanPaused = true;
               set(o.pushPause,'String','Resume')
           end
        end
        
        function updateInstructionsList(o)
            startdisp = findstr(o.InstructionFile.funct_code,'%STARTDISP');
            enddisp = findstr(o.InstructionFile.funct_code,'%ENDDISP');
            fctcode_todisplay = o.InstructionFile.funct_code(startdisp+12:enddisp-3);
            set(o.InstructionsList,'String',fctcode_todisplay,'HorizontalAlignment','left','FontName','Fixedwidth');
        end
        
        function updateRunTime(o)
            instrs = o.InstructionFile.instructions;
            runtime = 0; %ms
            o.savenum = 0;
            for ii = 1:length(instrs)
                switch instrs{ii}.type
                    case 'move'
                        if ischar(instrs{ii}.pos) %if pos is a string, this is a block moving - takes longer
                            runtime = runtime+2500;
                        else
                            runtime = runtime+500;
                        end
                    case 'acq'
                        runtime = runtime+max(o.acqDevices.(instrs{ii}.device).exposure,100);
                    case 'save'
                        o.savenum = o.savenum+1;
                    case 'wait'
                        runtime = runtime+instrs{ii}.waittime_s;
                    otherwise
                        warning(['Unknown runtime for instruction type "' instrs{ii}.type '"']);
                end
            end
            
            set(o.RunTimeText,'String',['Runtime: ' datestr(runtime/1000/60/60/24,'HH:MM:SS')])
        end
        
        function ok = retrieveDevices(o)
            init_acqdevs = o.acquisitionControllerPanel.initElements;
            required_acqdevs = o.InstructionFile.acq_dev;
            required_acqdevs{end+1} = 'stagespos';
            o.acqDevices = struct; 
            for ii = 1:length(required_acqdevs)
                for jj = 1:length(init_acqdevs)
                    if strcmp(required_acqdevs{ii},init_acqdevs{jj}.deviceController.deviceInfo.varname)
                        o.acqDevices.(required_acqdevs{ii}) = init_acqdevs{jj}.deviceController;
                        o.acqDevices.(required_acqdevs{ii}).resetBuffer;
                    end
                end
            end
            if ~isempty(o.acqDevices) && (length(fieldnames(o.acqDevices)) == length(required_acqdevs))
                set(o.FoundDevicesText,'String','Found all acqusition devices','ForegroundColor',[0 1 0])
                ok = true;
            else
                set(o.FoundDevicesText,'String','Did not find all acqusition devices!','ForegroundColor',[1 0 0])
                disp('Required acquisistion devices:')
                disp(required_acqdevs)
                disp('Found acquisition devices:')
                disp(fieldnames(o.acqDevices));
                ok = false;
            end
            
            required_stages = o.InstructionFile.stages;
            init_stages = o.stageControllerPanel.initElements;
            for ii = 1:length(o.InstructionFile.stages)
                for jj = 1:length(init_stages)
                    if ~strcmp(init_stages{jj}.stageController,'null')
                        if strcmp(required_stages{ii}, rem_spaces(init_stages{jj}.stageController.stageInfo.name))
                            o.stages.(required_stages{ii}) = init_stages{jj}.useController;
                        end
                    end
                end
            end
            if ~isempty(o.stages) && (length(fieldnames(o.stages)) == length(required_stages))
                set(o.FoundStagesText,'String','Found all stages','ForegroundColor',[0 1 0])
            else
                set(o.FoundStagesText,'String','Did not find all stages!','ForegroundColor',[1 0 0])
                disp('Required stages:')
                disp(required_stages)
                disp('Found stages:')
                disp(fieldnames(o.stages));
                ok  = false;
            end
           
        end
        
        function PerformScan(o)
           ETA = 0;
           ii = 1;
           saveindex = 1;
           devicefields = fieldnames(o.acqDevices);
           for jj = 1:length(devicefields)
               o.acqDevices.(devicefields{jj}).resetBuffer;
           end
           folderdate = datestr(now,'yyyymmdd');
           subfoldertime = datestr(now,'yyyymmdd_HHMMSS_');
           scanName = [subfoldertime get(o.enterScanName,'String')];
           mkdir(fullfile(o.pathOutput,folderdate,scanName));
           mkdir(fullfile(o.pathOutput,folderdate,scanName,'Instruction File'))
           copyfile(o.pathInstructionFile,fullfile(o.pathOutput,folderdate,scanName,'Instruction File'));
           scanparam = o.InstructionFile.scanparameters;
           save(fullfile(o.pathOutput,folderdate,scanName,[o.InstructionFile.scanparameters.scanName '_scanparam.mat']),'scanparam')
           
           if(~ishandle(o.metadataPanel.window))
               o.metadataPanel.plotWindow();
           end
           o.metadataPanel.setLabelPath(fullfile(o.pathOutput,folderdate,scanName),fullfile(o.pathOutput,folderdate,scanName,'metadata.mat'));
           o.metadataPanel.makeModal();
           
           instructions_since_last_save = cell(0);
           o.scanRunning = true;
           ETAtic = tic;
           while o.scanRunning
               instr = o.InstructionFile.instructions{ii};
               instructions_since_last_save{end+1} = instr;
               switch instr.type
                   case 'wait'
                       pause(instr.waittime_s);
                   case 'move'
                       o.stages.(instr.stage).setPosition(instr.pos);
                   case 'acq'
                       o.acqDevices.(instr.device).acquire;
                   case 'save'
                       o.acqDevices.stagespos.acquire;
                       for jj = 1:length(devicefields)
                           data.(devicefields{jj}) = o.acqDevices.(devicefields{jj}).retrieveReduced;
                           o.acqDevices.(devicefields{jj}).resetBuffer;
                       end
                       date = datestr(now,'yyyy-mm-dd HH:MM:SS');
                       info = instr.info;
                       save(fullfile(o.pathOutput,folderdate,scanName,num2str(saveindex)),'data','date','info','instructions_since_last_save')
                       instructions_since_last_save = cell(0);
                       ETA = toc(ETAtic)/saveindex*(o.savenum-saveindex);
                       updateLivePlot(o,data,saveindex,scanName,ETA)
                       saveindex = saveindex+1;
                       
                       while o.scanPaused
                           pause(0.5);
                       end
                   otherwise
                       set(o.pushRun,'String','Run')
                       set(o.pushPause,'enable','off')
                       error(['Unknown Instruction type "' instr.type '" at Instruction no ' num2str(ii)]);
               end
               ii = ii+1;
               if ii ==(length(o.InstructionFile.instructions)+1);
                   o.scanRunning = false;
               end
           end
           if ii ==(length(o.InstructionFile.instructions)+1);
                   disp('Scan done')
           else
               disp('Scan interrupted')
           end
        end
        
        function updateLivePlot(o,data,saveindex,scanName,ETA)
            if isfield(o.acqDevices,'webcam')
                if saveindex == 1
                    o.LivePlot.webcam.fig = figure('Numbertitle','off','name',[scanName ' WebCam marginals']);
                    o.LivePlot.webcam.xmarg.axes = subplot(2,1,1,'Parent',o.LivePlot.webcam.fig,'ydir','normal');
                    o.LivePlot.webcam.ymarg.axes = subplot(2,1,2,'Parent',o.LivePlot.webcam.fig,'ydir','normal');
                    o.LivePlot.webcam.xmarg.data = zeros(size(data.webcam.avg,2),o.savenum);
                    o.LivePlot.webcam.ymarg.data = zeros(size(data.webcam.avg,1),o.savenum);
                    o.LivePlot.webcam.xmarg.img = imagesc(1:o.savenum,1:size(data.webcam.avg,2),o.LivePlot.webcam.xmarg.data,'Parent',o.LivePlot.webcam.xmarg.axes);
                    o.LivePlot.webcam.ymarg.img = imagesc(1:o.savenum,1:size(data.webcam.avg,1),o.LivePlot.webcam.ymarg.data,'Parent',o.LivePlot.webcam.ymarg.axes);
                    o.LivePlot.webcam.xmarg.cbar = colorbar('peer',o.LivePlot.webcam.xmarg.axes);
                    o.LivePlot.webcam.ymarg.cbar = colorbar('peer',o.LivePlot.webcam.ymarg.axes);
                    ylabel(o.LivePlot.webcam.xmarg.axes,'X [px]')
                    title(o.LivePlot.webcam.xmarg.axes,'X Marginals (squared to correct \gamma = 0.5)')
                    ylabel(o.LivePlot.webcam.ymarg.axes,'Y [px]')
                    xlabel(o.LivePlot.webcam.ymarg.axes,'File index')
                    title(o.LivePlot.webcam.ymarg.axes,'Y Marginals (squared to correct \gamma = 0.5)')
                end
                o.LivePlot.webcam.xmarg.data(:,saveindex) =  sum(data.webcam.avg(:,:,1).^2,1)'; %(:,:,1) selects red pixels only 
                o.LivePlot.webcam.ymarg.data(:,saveindex) =  sum(data.webcam.avg(:,:,1).^2,2); %(all x, all y, first colour channel)
                set(o.LivePlot.webcam.xmarg.img,'CData',o.LivePlot.webcam.xmarg.data);
                set(o.LivePlot.webcam.xmarg.axes,'clim',[min(o.LivePlot.webcam.xmarg.data(o.LivePlot.webcam.xmarg.data~=0)),max(o.LivePlot.webcam.xmarg.data(o.LivePlot.webcam.xmarg.data~=0))]);
                set(o.LivePlot.webcam.ymarg.img,'CData',o.LivePlot.webcam.ymarg.data);
                set(o.LivePlot.webcam.ymarg.axes,'clim',[min(o.LivePlot.webcam.ymarg.data(o.LivePlot.webcam.ymarg.data~=0)),max(o.LivePlot.webcam.ymarg.data(o.LivePlot.webcam.ymarg.data~=0))]);
            end
            if isfield(o.acqDevices,'mcp')
                if saveindex == 1
                    o.LivePlot.mcpmarg.fig = figure('Numbertitle','off','name',scanName);
                    o.LivePlot.mcpmarg.ax = axes('Parent',o.LivePlot.mcpmarg.fig,'ydir','normal');
                    o.LivePlot.mcpmargs = zeros(size(data.mcp.avg,2),o.savenum);
                    o.LivePlot.mcpmargimg = imagesc(1:o.savenum,1:size(data.mcp.avg,2),o.LivePlot.mcpmargs,'Parent',o.LivePlot.mcpmarg.ax);
                    xlabel('File index')
                    ylabel('Energy [px]')
                    title({'MCP vertically integrated marginal',['ETA: ' datestr(now+ETA/3600/24,'HH:MM:SS')]})
                end
                o.LivePlot.mcpmargs(:,saveindex) =  sum(mean(data.mcp.avg,3),1)';
                set(o.LivePlot.mcpmargimg,'CData',o.LivePlot.mcpmargs);
                
            elseif isfield(o.acqDevices,'pixelfly') 
                if saveindex == 1
                    o.LivePlot.mcpmarg.fig = figure('Numbertitle','off','name',scanName);
                    o.LivePlot.mcpmarg.ax = axes('Parent',o.LivePlot.mcpmarg.fig,'ydir','normal');
                    o.LivePlot.mcpmargs = zeros(size(data.pixelfly.avg,1),o.savenum);
                    o.LivePlot.mcpmargimg = imagesc(1:o.savenum,1:size(data.pixelfly.avg,2),o.LivePlot.mcpmargs,'Parent',o.LivePlot.mcpmarg.ax);
                    xlabel('File index')
                    ylabel('Energy [px]')
                    title({'MCP horizontally integrated marginal',['ETA: ' datestr(now+ETA/3600/24,'HH:MM:SS')]})
                end
                if isempty(data.pixelfly.avg)
                    o.LivePlot.mcpmargs(:,saveindex) =  zeros(size(o.LivePlot.mcpmargs(:,saveindex)));
                else
                    o.LivePlot.mcpmargs(:,saveindex) =  sum(mean(data.pixelfly.avg,3),2);
                end
                set(o.LivePlot.mcpmargimg,'CData',o.LivePlot.mcpmargs);
            end
        end
        
        function delete(o)
            delete(o.parentC)
        end
    end
    
    
end