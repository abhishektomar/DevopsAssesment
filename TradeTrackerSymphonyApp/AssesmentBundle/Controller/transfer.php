<?php
$mongo = new MongoClient("mongodb://10.10.22.237");
$db = $mongo->TradeUser;
$collection = $db->TradeCollection;
if($argv[4] == 'remove')
    $collection->remove();
$document = array("firstName" =>$argv[1], "lastName" => $argv[2], "age"=>$argv[3]);
$collection->insert($document);
?>
