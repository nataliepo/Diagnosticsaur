<?php
    
    
    $title = 'Multi-Report';
        
    /* This order determines the columns that will appear in the report.
      ** The first key is the key name in the json field,
         the name + unit label the column in the graph.
     */
    $parameters = array(
         "process-httpd-running" =>  array(
                  'name' => 'httpd', 
                  'unit' => 'Processes'),
         
         "iostat-nfs-read" => array(
               'name' => 'nfs-read', 
               'unit' => 'rkB_nor/sec'),

         "iostat-nfs-writes" => array(
               'name' => 'nfs-write', 
               'unit' => 'wkB_nor/s'),                        
  
         "load-one-average" => array(
               'name' => 'load 1', 
               'unit' => 'CPU %'),
             
         "load-five-average" => array(
               'name' => 'load 5', 
               'unit' => 'CPU %'),               
               
         "memory-swap-free" => array(
               'name' => 'swap-free', 
               'unit' => 'M'),
               
         "memory-physical-used" => array(
               'name' => 'memory-used', 
               'unit' => 'M'),               
                  
         "hour"   => array(
                  'name' => 'hour',
                  'unit' => "")
         );
    
    include_once('driver.php');  
    
    
?>