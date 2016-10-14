% (c) Alvaro Sanchez Gonzalez 2014
classdef ImageAcquisitionDevice<AbstractAcquisitionDevice
    %ABSTRACTAQUISITIONDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        cameraController
        image
        cropHand
        boxesHand
    end
    
    methods
        function o=ImageAcquisitionDevice(deviceInfo)
            o = o@AbstractAcquisitionDevice(deviceInfo);  
            
            o.cropHand=0;
            o.boxesHand=0;
            o.setExtraParam(o.deviceInfo.extraparam)
        end
        
        function setExtraParam(o,extraparam)
            
            [boxesPath, remain]=strtok(extraparam,',');
            [cropPath, remain]=strtok(remain,',');
            
            if(isempty(boxesPath))
                boxesPath='Boxes.mat';
            end
            if(isempty(cropPath))
                cropPath='CropRectangle.mat';
            end
            
            o.deviceInfo.extraparam=sprintf('%s,%s',boxesPath,cropPath);
            
            if(o.cropHand==0)
                o.cropHand=CropRectangleHandler(cropPath);
                o.boxesHand=BoxesHandler(boxesPath);
            else
                o.cropHand.loadFromFile(cropPath);
                o.boxesHand.loadFromFile(boxesPath);
            end
        end
                
        function resetBuffer(o)
            o.image.avg=0;
            o.image.std=0;    
            o.image.count=0;
            o.image.exposure=o.getExposure();
        end
        function acquisition(o)
            [image,o.image.x,o.image.y,o.image.timestamp,o.image.params]=take_snapshot(o.cameraController.camera);
            if(o.image.count==0)
                o.image.avg=double(image);
                o.image.std=double(image).^2;
            else
                o.image.avg=o.image.avg+double(image);
                o.image.std=o.image.std+double(image).^2; %this is the sum of squares! std deviation is calculated when data is retrieved (o.normalize)
            end
            
            o.image.count=o.image.count+1;
            
        end
        function image=retrieve(o)
            image=o.image; %Create a copy
            image=o.normalize(image);         
        end
        
        function image=retrieveReduced(o)
            image=o.image; %Create a copy
            image=o.normalize(image);        
            rect=o.cropHand.rectangle;
            rect(1)=max(1,rect(1));
            rect(3)=max(1,rect(3));
            rect(2)=min(rect(2),size(image.avg,2));
            rect(4)=min(rect(4),size(image.avg,1));
            
            image.avg=image.avg(rect(3):rect(4),rect(1):rect(2),:);
            image.std=image.std(rect(3):rect(4),rect(1):rect(2),:);
            image.rectangle=rect;
        end
        
        function areas=areaBoxes(o)
            image=o.image; %Create a copy
            image=o.normalize(image); 
            image.avg=sum(image.avg,3);
            boxes=o.boxesHand.boxes;
            areas=[];
            for i=1:length(boxes)
                rect=boxes{i}.rect;
                rect(1)=max(1,rect(1));
                rect(3)=max(1,rect(3));
                rect(2)=min(rect(2),size(image.avg,2));
                rect(4)=min(rect(4),size(image.avg,1));
                areas(i)=sum(sum(image.avg(rect(3):rect(4),rect(1):rect(2))));
            end
        end
        
        function projection=projectionSlice(o)
            image=o.image; %Create a copy
            image=o.normalize(image); 
            imageavg=sum(image.avg,3);
            rect=o.cropHand.rectangle;
            projection=sum(imageavg(rect(3):rect(4),rect(1):rect(2)),1); 
        end
        
        function image=normalize(o,image)
            image.avg=image.avg/image.count;
                    
            if(image.count>1) %Calculate the standard deviation only if there is more than one image (otherwise it is 0)
                image.std=sqrt(1/(image.count-1)*(image.std-image.count*image.avg.^2));   %sd= sqrt(1/(N-1)*(sum (xi^2)-N*(mean(x)^2))
            else
                image.std=zeros(size(image.avg));
            end 
        end
        
        function axes=getAxes(o)
            axes=o.cameraController.viewer.viewer.im.axes;
        end
        
        function state=isStillValid(o)
            state=isvalid(o.cameraController);
        end         
    end
    
    methods (Static)
        initialize(o);
        setExposure(o,msExposure);
        msExposure = getExposure(o);
    end
    
end
