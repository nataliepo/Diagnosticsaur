# Diagnaosticsaur

Questions?  Email: natalie@auburnandivory.com.


## Scripts


* freespace.pl -- Easy parser for df -h.  Usage:
   
      perl freespace.pl --filesys="/dev/sda1" --option="Size" > output
      
where each filesys is a drive and each option is a column on the df -h table (Filesystem, Size, Used, Avail, Capacity, Mounted on).


* tops-scrubber.pl -- Easy parser for top. Usage:
      
      perl top-scrubber.pl --type="mem" --detail="free" > output
   
where the type is info (line 1), tasks, cpu, mem, swap, and the detail for each line depends on the parameters parsed out.   Here are some more examples.
      
      # 1, 5, 10-min load avg -- first row of top
      perl top-scrubber.pl --type="info" --detail="load_1"
      perl top-scrubber.pl --type="info" --detail="load_5"
      perl top-scrubber.pl --type="info" --detail="load_10"
      
      # idle and iowait  -- cpu row of top
      perl top-scrubber.pl --type="cpu" --detail="id"
      perl top-scrubber.pl --type="cpu" --detail="wa"
      
      # swap - buffers, free.
      perl top-scrubber.pl --type="swap" --detail="buffers"
      perl top-scrubber.pl --type="swap" --detail="free"
      
      # tasks -- running, zombie
      perl top-scrubber.pl --type="tasks" --detail="running"
      perl top-scrubber.pl --type="tasks" --detail="zombie"
      
Use the debug statement to get a snapshot of all values, and to see supported type flags (left col) and detail flags (indented in []'s):

      perl top-scrubber.pl --debug
      
      
      