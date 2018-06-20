<?php
    //Check Input
    if(isset($_POST['sender_uid']))  { $sender_uid   = $_POST['sender_uid']; }   else { exit ('Invalid UID'); }
    if(isset($_POST['receiver_uid'])){ $receiver_uid = $_POST['receiver_uid']; } else { exit ('Invalid UID'); }
    $comment = isset($_POST['comment']) ?  $_POST['comment'] : "";

    $date_year = isset($_POST['date_year']) ? $_POST['date_year'] : 1970;
    $date_mont = isset($_POST['date_mont']) ? $_POST['date_mont'] : 1;
    $date_day  = isset($_POST['date_day'] ) ? $_POST['date_day']  : 1;
    $date_hour = isset($_POST['date_hour']) ? $_POST['date_hour'] : 0;
    $date_minu = isset($_POST['date_minu']) ? $_POST['date_minu'] : 0;

    $false = 0;

    try {
        //Connect DB
        $db = new PDO('sqlite:user_sqlite_db.db');
        
        //SetAttribute
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        //GetTime
        $tsql = sprintf("SELECT julianday('%d-%02d-%02d %02d:%02d:00') AS julianday", $date_year, $date_mont, $date_day, $date_hour, $date_minu);
        $tres = $db->query($tsql);

        while($res = $tres->fetch(PDO::FETCH_ASSOC)){
            $time = $res['julianday'];
        }

        //Rename
        $stmt = $db->prepare("INSERT INTO User_Comments VALUES (?, ?, ?, ?, ?)");
        $stmt->bindParam(1, $sender_uid);
        $stmt->bindParam(2, $receiver_uid);
        $stmt->bindParam(3, $time);
        $stmt->bindParam(4, $comment);
        $stmt->bindParam(5, $false);
        $stmt->execute();
    } 
    
    catch (Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
?>


