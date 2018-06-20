<?php
    //Check Input
    if(isset($_POST['uid'])){ $uid = $_POST['uid']; } else { exit ('Invalid UID'); }
    if(isset($_POST['new_name'])){ $new_name = $_POST['new_name'];} else { exit ('Invalid Name'); }

    try {
        //Connect DB
        $db = new PDO('sqlite:user_sqlite_db.db');
        
        //SetAttribute
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        //Rename
        $stmt = $db->prepare("UPDATE user SET name = ? WHERE id = ?");
        $stmt->bindParam(1, $new_name);
        $stmt->bindParam(2, $uid);
        $stmt->execute();
    } 
    catch (Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
?>


