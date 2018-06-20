## アプリの操作方法
![説明1](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage1.png?raw=true) 
![説明2](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage2.png?raw=true) 
![説明3](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage3.png?raw=true) 
![説明4](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage4.png?raw=true) 
![説明5](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage5.png?raw=true) 
![説明6](https://github.com/enpit2su-ics/team-A/blob/master/Documents/walkpage6.png?raw=true) 


## アプリのコンパイル方法
### 1. CocoaPodsをコンパイルするPCにインストールする
```
  $ sudo gem install cocoapods
  $ pod setup
```
  参考:[【Swift】CocoaPods導入手順](https://qiita.com/ShinokiRyosei/items/3090290cb72434852460)
  
  
### 2. プロジェクトをダウンロード/クローンする  

### 3. 外部ライブラリをインストールする
```
  $ cd team-A-master
  $ pod init
  $ pod install
  $ pod update
```

### 4. プロジェクトをXcodeで開く
  開くファイルは"enPiT2SUProduct.xcworkspace"

### その他コンパイルエラーへの対処  
  ・一部ライブラリ(Charts, Eureka)をコンパイルする際のSwiftのバージョンはSwift4.0にする  
    左メニューファイルリスト->"Pods"を開く
    左2番目のメニューにあるTARGETSから該当するライブラリの設定を開く
    "Build Settings"->"Swift Compiler - Language"->"Swift Language Version"でバージョンを変更する
    
  ・本体をコンパイルする際のSwiftのバージョンもSwift4.0にした方がいいかもしれない

## サーバの構築方法
### 1.PHP7とSQLite3の動くWebを用意する

### 2.githubのDcuments/server以下のファイルをWebサーバの公開ディレクトリに配置する
  ・ihonkiのフォルダまるごと
### 3.iPhone側アプリでのソースコードで通信先を変更する
  ・HistoryShare.swiftのurlDetailを通信先のアドレスに変更   
  ・AppDelegate.swiftの関数uidget中にあるstringUrlを通信先のアドレスに変更   
  ・httpでの通信(SSLを用いない通信)を行う場合はinfo.plist中の"App Transport Seculity Setings -> Exception Domains" に通信先アドレスを追加しておく(既存のを書き換えてもいい)   
