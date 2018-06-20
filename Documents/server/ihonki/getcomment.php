<?php
    //Check Input
    if(isset($_POST['uid'])){ $uid = $_POST['uid']; } else{ exit ('Invalid UID');}
    
    $is_all = (isset($_POST['all'])) ? 1 : 0;

    try {
        //Connect DB
        $db = new PDO('sqlite:user_sqlite_db.db');
        
        //SetAttribute
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        //Rename
        $stmt = $db->prepare(
            "SELECT
                User_Comments.id_Sender
                , user.name
                , (SELECT strftime('%Y-%m-%d %H:%M:%S', User_Comments.Date_Time)) AS Send_Date
                , User_Comments.Comments 
            FROM 
                User_Comments 
                INNER JOIN user ON User_Comments.id_Sender=user.id 
            WHERE 
                User_Comments.id_Receiver=?
        ");
        $stmt->bindParam(1, $uid);
        $stmt->execute();

        #頭の悪いJSON形式の出力
        $out_str = "{";
        $out_str .= "\"Comments\":[";
        while($res = $stmt->fetch()){
            $date = 

            $out_str .= "{";
            $out_str .= sprintf("\"SenderID\":%s,",is_null($res['id_Sender']) ? "0" : $res['id_Sender']);
            $out_str .= sprintf("\"SenderName\":\"%s\",", is_null($res['name']) ? "" : $res['name']);
            $out_str .= sprintf("\"SendDate\":\"%s\",", is_null($res['Send_Date']) ? "0-1-1 00:00:00" : $res['Send_Date']);
            $out_str .= sprintf("\"Comment\":\"%s\"", is_null($res['Comments']) ? 0 : $res['Comments']);
            $out_str .= "},";
        }
        $out_str = rtrim($out_str, ',');
        $out_str .= "]";
        $out_str .= "}";

        print($out_str);
    } 
    catch (Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
?>