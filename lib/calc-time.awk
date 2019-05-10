#!/bin/awk -f

BEGIN {
    t_work=0;
    t_pause=0;
    t_total=0;
    running=0;
}
{
    if ($1 == "started"){
        timestamp = $2;
        t_start = $2;
        running = 1;
    }
    if ($1 == "paused" && running == 1){
        t_work += $2 - timestamp;
        timestamp = $2;
        running = 0;
    }
    if ($1 == "resumed" && running == 0){
        t_pause += $2 - timestamp;
        timestamp = $2;
        running = 1;
    }
    if ($1 == "stopped"){
        if (running == 1)
            t_work += $2 - timestamp;
        else
            t_pause += $2 - timestamp;
        t_total += $2 - t_start;

        print "started at: " t_start
        print "worked for " format_time(t_work)
        print "paused for " format_time(t_pause)
        print "ended at: " $2
    }
    if ($1 == "Desc:"){
        $1="";
        print "Description:";
        #for (i=2; i<=NF; i++) print $i
        for (i=2; i<NF; i++) printf $i " "; print $NF "\n"
        #print $0, "\n";
    }
}
END{
        print "total time: " format_time(t_total)
}

function format_time(time){
    second = time % 60;
    minut = (time % 3600 - second) /60;
    hour = ((time - time%3600) / 3600) % 24;
    return hour " hours " minut " minutes " second " seconds"
}
