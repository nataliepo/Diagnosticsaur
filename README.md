# Diagnaosticsaur

Questions?  Email: natalie@auburnandivory.com.


## Scripts


* freespace.pl -- Easy parser for df -h.  Usage:
   
      perl freespace.pl --filesys="/dev/sda1" --option="Size" > output
      
where each filesys is a drive and each option is a column on the df -h table (Filesystem, Size, Used, Avail, Capacity, Mounted on).