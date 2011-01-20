<?php
    
    
    $title = 'Multi-Report';
    $json_filename = 'stats-natalie.js';
    
    
    /* This order determines the columns that will appear in the report.
      ** The first key is the key name in the json field,
         the name + unit label the column in the graph.
     */
    $parameters = array(
         "process-httpd-running" =>  array(
                  'name' => 'httpd', 
                  'unit' => 'Ps'),
                  
         "process-mt-search-cgi-running" => array(
                  'name' => 'search', 
                  'unit' => 'Ps'),
                  
         "process-mt-comments-cgi-running" => array(
                  'name' => 'comments', 
                  'unit' => 'Ps'),

         "process-mt-cp-cgi-running" => array(
                  'name' => 'cp', 
                  'unit' => 'Ps'),

         "process-mt-cgi-running" => array(
                  'name' => 'mt', 
                  'unit' => 'Ps'),
         
         "iostat-nfs-read" => array(
               'name' => 'nfs-read', 
               'unit' => 'kb/s'),

         "iostat-nfs-writes" => array(
               'name' => 'nfs-write', 
               'unit' => 'kb/s'),                        
  
         "load-one-average" => array(
               'name' => 'load 1', 
               'unit' => 'CPU%'),
             
         "load-five-average" => array(
               'name' => 'load 5', 
               'unit' => 'CPU%'),               
               
         "memory-swap-used" => array(
               'name' => 'swap-used', 
               'unit' => 'M'),
               
         "memory-physical-used" => array(
               'name' => 'memory-used', 
               'unit' => 'M'),               

         "server_id" => array(
               'name' => 'server_id', 
               'unit' => 'app'),                                
                  
         "hour"   => array(
                  'name' => 'hour',
                  'unit' => "")
         );
    
    
    include_once('driver.php');  
?>
