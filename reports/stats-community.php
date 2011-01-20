<?php
    
    
    $title = 'Community Report';
    $json_filename = 'stats-natalie.js';
    
    
    /* This order determines the columns that will appear in the report.
      ** The first key is the key name in the json field,
         the name + unit label the column in the graph.
     */
    $parameters = array(
                  
         "process-mt-comments-cgi-running" => array(
                  'name' => 'mt-comments', 
                  'unit' => 'Processes'),

         "process-mt-cp-cgi-running" => array(
                  'name' => 'mt-cp', 
                  'unit' => 'Processes'),               

         "load-one-average" => array(
               'name' => 'load 1', 
               'unit' => 'CPU %'),
             
         "load-five-average" => array(
               'name' => 'load 5', 
               'unit' => 'CPU %'),               
               
         "memory-swap-used" => array(
               'name' => 'swap-used', 
               'unit' => 'M'),
               
         "memory-physical-used" => array(
               'name' => 'memory-used', 
               'unit' => 'M'),               

         "server_id" => array(
               'name' => 'server_id', 
               'unit' => 'app-number'),                                
                  
         "hour"   => array(
                  'name' => 'hour',
                  'unit' => "")
         );
    
    
    include_once('driver.php');  
?>
