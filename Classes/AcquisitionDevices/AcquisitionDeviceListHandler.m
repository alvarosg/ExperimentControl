% (c) Alvaro Sanchez Gonzalez 2014
classdef AcquisitionDeviceListHandler<handle
    %BOXESHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        devices
        path
    end
    
    methods
        function o = AcquisitionDeviceListHandler(path)
            o.devices={};
            o.path=path; 
            o.loadFromFile(o.path);
        end
        function saveToFile(o,path)
            try
                devices=o.devices;
                save(path,'devices');
            catch
                disp('Failed to save devices list');
            end
        end
        function loadFromFile(o,path)
            try
                ld=load(path);
                o.devices=ld.devices;
            catch
                disp('Failed to locate devices file');
            end
        end
        function addDevice(o,name,type,varname,extraparam,shots)
            device.name=name;
            device.type=type;
            device.varname=varname;
            device.shots=shots;
            device.extraparam=extraparam;
            o.devices=[o.devices {device}];
            o.saveToFile(o.path);
        end
        function addDeviceInd(o,ind,name,type,varname,extraparam,shots)
            if ind<=length(o.devices)+1
                device.name=name;
                device.type=type;
                device.varname=varname;
                device.shots=shots;
                device.extraparam=extraparam;
                o.devices={o.devices{1:ind-1} device o.devices{ind:end}};
            end
            o.saveToFile(o.path);
        end
        function removeDeviceInd(o,ind)
            if(ind==1)
                o.devices={o.devices{2:end}};
            elseif(ind==length(o.devices))
                o.devices={o.devices{1:ind-1}};
            else
                o.devices={o.devices{[1:ind-1 ind+1:end]}};
            end
            o.saveToFile(o.path);
        end
        function editDevice(o,ind,name,type,varname,extraparam,shots)
            if ind<=length(o.devices)
                o.devices{ind}.name=name;
                o.devices{ind}.type=type;
                o.devices{ind}.varname=varname;
                if(shots(1)~=-1)
                    o.devices{ind}.shots=shots;
                end
                o.devices{ind}.extraparam=extraparam;
            end
            o.saveToFile(o.path);
        end
        function devices = getDevices(o)
            devices = o.devices;
        end
        
        function device = getDevice(o,ind)
            device = o.devices{ind};
        end
        
        function c = count(o)
            c=length(o.devices);
        end
        
        function setExtraParamByName(o,name,extraparam)
            for i=1:length(o.devices)
                if(strcmp(name,o.devices{i}.name))
                    o.devices{i}.extraparam=extraparam;
                    o.saveToFile(o.path);
                    break;
                end
            end
        end
        
        function setShotsByName(o,name,shots)
            for i=1:length(o.devices)
                if(strcmp(name,o.devices{i}.name))
                    o.devices{i}.shots=shots;
                    o.saveToFile(o.path);
                    break;
                end
            end
        end
    end
end

