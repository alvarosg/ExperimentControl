% (c) Alvaro Sanchez Gonzalez 2014
classdef MetadataListHandler<handle
    %BOXESHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fields
        path
    end
    
    methods
        function o = MetadataListHandler(path)
            o.fields={};
            o.path=path; 
            o.loadFromFile(o.path);
        end
        function saveToFile(o,path)
            try
                fields=o.fields;
                save(path,'fields');
            catch
                disp('Failed to save metadata fields list');
            end
        end
        function loadFromFile(o,path)
            try
                ld=load(path);
                o.fields=ld.fields;
            catch
                disp('Failed to locate metadata fields file');
            end
        end
        function addField(o,name,varname)
            field.name=name;
            field.varname=varname;
            o.fields=[o.fields {field}];
            o.saveToFile(o.path);
        end
        function addFieldInd(o,ind,name,varname)
            if ind<=length(o.fields)+1
                field.name=name;
                field.varname=varname;
                o.fields={o.fields{1:ind-1} field o.fields{ind:end}};
            end
            o.saveToFile(o.path);
        end
        function removeFieldInd(o,ind)
            if(ind==1)
                o.fields={o.fields{2:end}};
            elseif(ind==length(o.fields))
                o.fields={o.fields{1:ind-1}};
            else
                o.fields={o.fields{[1:ind-1 ind+1:end]}};
            end
            o.saveToFile(o.path);
        end
        function editField(o,ind,name,varname)
            if ind<=length(o.fields)
                o.fields{ind}.name=name;
                o.fields{ind}.varname=varname;
            end
            o.saveToFile(o.path);
        end
        function fields = getFields(o)
            fields = o.fields;
        end
        
        function fields = getField(o,ind)
            fields = o.fields{ind};
        end
        
        function c = count(o)
            c=length(o.fields);
        end
        
    end
end

