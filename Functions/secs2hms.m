
function time_string=secs2hms(time_in_secs)
    time_string='';
    nhours = 0;
    nmins = 0;
    if time_in_secs >= 3600
        nhours = floor(time_in_secs/3600);
        hour_string = ' h ';
        time_string = [num2str(nhours) hour_string];
    end
    if time_in_secs >= 60
        nmins = floor((time_in_secs - 3600*nhours)/60);
        minute_string = ' m ';
        time_string = [time_string num2str(nmins) minute_string];
    end
    nsecs = time_in_secs - 3600*nhours - 60*nmins;
    time_string = [time_string sprintf('%2.1f', nsecs) ' s'];
