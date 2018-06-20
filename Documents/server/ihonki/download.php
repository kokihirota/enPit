<?php
    //Check Input
    if(isset($_POST['uid'])){ $uid = $_POST['uid']; } else{ exit ('Invalid UID'); }

    //Values
    $begin_year = isset($_POST['begin_year']) ? $_POST['begin_year'] : 0;
    $begin_mont = isset($_POST['begin_mont']) ? $_POST['begin_mont'] : 1;
    $begin_day  = isset($_POST['begin_day'] ) ? $_POST['begin_day']  : 1;
    $begin_hour = isset($_POST['begin_hour']) ? $_POST['begin_hour'] : 0;
    $begin_minu = isset($_POST['begin_minu']) ? $_POST['begin_minu'] : 0;

    $end_year = isset($_POST['end_year']) ? $_POST['end_year']: 10000;
    $end_mont = isset($_POST['end_mont']) ? $_POST['end_mont']: 1;
    $end_day  = isset($_POST['end_day'] ) ? $_POST['end_day'] : 1;
    $end_hour = isset($_POST['end_hour']) ? $_POST['end_hour']: 0;
    $end_minu = isset($_POST['end_minu']) ? $_POST['end_minu']: 0;

    try {
        //Connect DB
        $db = new PDO('sqlite:user_sqlite_db.db');
        
        //SetAttribute
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        //GetTime
        $stmt = sprintf("SELECT julianday('%d-%02d-%02d %02d:%02d:00') AS julianday", $begin_year, $begin_mont, $begin_day, $begin_hour, $begin_minu);
        $tres = $db->query($stmt);

        while($res = $tres->fetch(PDO::FETCH_ASSOC)){
            $begin_time = $res['julianday'];
        }

        $stmt = sprintf("SELECT julianday('%d-%02d-%02d %02d:%02d:00') AS julianday", $end_year, $end_mont, $end_day, $end_hour, $end_minu);
        $tres = $db->query($stmt);

        while($res = $tres->fetch(PDO::FETCH_ASSOC)){
            $end_time = $res['julianday'];
        }


        //SearchDB

        $stmt = $db->prepare(
            "SELECT 
                SUM(
                    CASE WHEN Data_Pedometer IS null 
                        THEN 0 
                        ELSE Data_Pedometer 
                    END
                ) 
                AS Pedometer
                ,SUM(
                    CASE WHEN Data_Distance IS null 
                        THEN 0 
                        ELSE Data_Distance 
                    END
                ) 
                AS Distance 
                ,SUM(
                    CASE WHEN Data_Calorie IS null 
                        THEN 0 
                        ELSE Data_Calorie 
                    END
                ) 
                AS Calorie
            FROM Exercize_Data
            WHERE 
                id = ?
                AND Date_Time BETWEEN ? AND ?
        ");
        $stmt->bindParam(1, $uid);
        $stmt->bindParam(2, $begin_time);
        $stmt->bindParam(3, $end_time);
        $stmt->execute();

        while($res = $stmt->fetch()){
            echo is_null($res['Pedometer']) ? 0 : $res['Pedometer'];
            echo ",";
            echo is_null($res['Distance']) ? 0 : $res['Distance'];
            echo ",";
            echo is_null($res['Calorie']) ? 0 : $res['Calorie'];
        }
    } 
    catch (Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
?>
