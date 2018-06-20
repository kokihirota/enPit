<?php
    //Check Input
    if(isset($_POST['uid'])){ $uid = $_POST['uid']; } else{ exit ('Invalid UID'); }
    //Values
    $date_year = isset($_POST['date_year']) ? $_POST['date_year'] : 0;
    $date_mont = isset($_POST['date_mont']) ? $_POST['date_mont'] : 1;
    $date_day  = isset($_POST['date_day'] ) ? $_POST['date_day']  : 1;
    $date_hour = isset($_POST['date_hour']) ? $_POST['date_hour'] : 0;
    $date_minu = isset($_POST['date_minu']) ? $_POST['date_minu'] : 0;

    $data_pedo = isset($_POST['data_pedo']) ? $_POST['data_pedo'] : 0;
    $data_dist = isset($_POST['data_dist']) ? $_POST['data_dist'] : 0;
    $data_calo = isset($_POST['data_calo']) ? $_POST['data_calo'] : 0;

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

        //RegistDB
        $stmt = $db->prepare("INSERT INTO Exercize_Data VALUES (?, ?, ?, ?, ?)");
        $stmt->bindParam(1, $uid);
        $stmt->bindParam(2, $time);
        $stmt->bindParam(3, $data_pedo);
        $stmt->bindParam(4, $data_dist);
        $stmt->bindParam(5, $data_calo);
        $stmt->execute();

    } 
    catch (Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
?>