<?php

try {

    // 接続
//    $pdor = new PDO('sqlite:record_sqlite_db.db');
    $pdou = new PDO('sqlite:user_sqlite_db.db');

    // SQL実行時にもエラーの代わりに例外を投げるように設定
    // (毎回if文を書く必要がなくなる)
//    $pdor->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdou->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);


    // デフォルトのフェッチモードを連想配列形式に設定
    // (毎回PDO::FETCH_ASSOCを指定する必要が無くなる)
//    $pdor->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdou->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    // テーブルUser作成
    $pdou->exec("CREATE TABLE IF NOT EXISTS user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(10)
    )");

    // テーブルrecord作成
//    $pdor->exec("CREATE TABLE IF NOT EXISTS record(
//        id INTEGER ,
//        pedo INTEGER,
//        distance FLOAT,
//        calorie FLOAT
//    )");

    // 挿入（プリペアドステートメント）
//    $stmt = $pdo->prepare("INSERT INTO fruit(name, price) VALUES (?, ?)");
//   foreach ([['banana', '350'], ['orenge', '300']] as $params) {
//        $stmt->execute($params);
//    }

//データ一つのセットを挿入
$sqlu = 'insert into user (name) values (?)';
// 存在していないとき挿入
// $ sql = 'INSERT INTO hoge (X, Y) SELECT 'a', 'b' FROM テーブル名 WHERE NOT SELECT EXISTS(SELECT * FROM テーブル名 WHERE カラム名 = '条件') '
$stmtu = $pdou->prepare($sqlu);
$flagu = $stmtu->execute(array("default"));

if ($flagu){
//    print('データの追加に成功しました<br>');
//}else{
//    print('データの追加に失敗しました<br>');
//}

//自分のIDを表示
$stmt = $pdou->query('select * from user order by id desc limit 1');
//print("UID : name".'<br>');
//while($r2 = $stmt->fetch(PDO::FETCH_ASSOC)){
$r2 = $stmt->fetch(PDO::FETCH_ASSOC);
print($r2['id']);
//print($r2['name'].'<br>');
}
//登録に失敗したらなにも表示しない


    // 選択 (プリペアドステートメント)
//    $stmt2 = $pdor->prepare("SELECT * FROM record ");
//    $stmt2->execute([$title]);
    //$stmt2 = $pdo->prepare("SELECT * FROM record ");
//$r2 = $stmt2->fetch(PDO::FETCH_ASSOC);
//if ($r2['title'] == $title){
//  print($r2['title'] . "." . $r2['note']);
//}
//else {
//    print($title ."は存在しません" . '<br>');
//}

// 結果を表示

//$stmt = $pdo->query('select * from record');

//print("title : note".'<br>');
//while($r2 = $stmt->fetch(PDO::FETCH_ASSOC)){

//print($r2['title']." : ");
//print($r2['note'].'<br>');

//}

} catch (Exception $e) {
  echo $e->getMessage() . PHP_EOL;
}

?>
