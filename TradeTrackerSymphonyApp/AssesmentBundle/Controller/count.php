<?php
$mongo = new MongoClient("mongodb://10.10.22.237");
$db = $mongo->TradeUser;
$collection = $db->TradeCollection;
$count = $collection->count();
echo $count;
?>
