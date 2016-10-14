% (c) Alvaro Sanchez Gonzalez 2014
function [increased next] = incrementLoop(sizes,current,ind)
    %If I can increment this counter, I do it
    next=current;
    if(current(ind)<sizes(ind))        
        next(ind)=next(ind)+1;
        increased=true;  
    %If I cannot, I reset it to the initial value
    else
        next(ind)=1;
        % And increment the immediately outer one
        if(ind>1)                    
            [increased next]=incrementLoop(sizes,next,ind-1);
        %Unless this is the most external one, in which case I just
        %stop
        else
            increased=false;
        end  
    end
end
