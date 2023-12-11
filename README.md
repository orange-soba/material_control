## アプリケーション名
MaterialControl

## アプケーション概要
製品や部品の作成に必要な部品や材料を計算して表示する。また在庫と比較して発注が必要な部品/材料を表示する。  
そのために部品の登録、材料の登録、部品Aには部品A1が必要であるという登録、部品Aには材料Aが必要であるという登録を行う必要がある。下記イメージ図のような親子関係を登録する。

[![Image from Gyazo](https://i.gyazo.com/bba7f4e1c014151c92844f3a40155ad6.png)](https://gyazo.com/bba7f4e1c014151c92844f3a40155ad6)

## URL
https://material-control.onrender.com/  

## テスト用アカウント
・BASIC認証ID: orange  
・BASIC認証パスワード: 8888  
・メールアドレス: test1@test.com  
・パスワード: password1

## 利用方法
1.トップページのヘッダーから新規登録を行う  
2.ヘッダーの完成品/部品登録から部品の登録を行う  
3.ヘッダーの材料登録から材料登録を行う
4.ヘッダーのマイページから完成品名もしくは部品名をクリックし詳細ページへ遷移する  
5.詳細ページ内の部品登録より必要な部品の登録をする  
6.詳細ページ内の材料登録より必要な材料を登録する  
7.2~5の作業を必要な分行う  
8.詳細ページの材料計算ボタンをクリックし、材料計算ページへ遷移する  
9.計算結果及び発注が必要なものが表示される  

## アプリケーションを作成した背景
前職(機械製造業)において材料の発注を一部任されていたが、その時に教わった材料の頼み方が「多分これが足りない」といった勘を元にしたものだった。材料を無駄なく頼もうと思ったら図面を全て読み、材料を計算しなければならず、1日がかりの作業になっていた。そこで完成品/部品作成に必要な部品や材料さえ登録すれば一瞬で全ての必要な部品や材料を出力出来るアプリがあればそういった悩みを持つ人の助けになると思い、当アプリの作成に至った。

## 洗い出した要件
https://docs.google.com/spreadsheets/d/14od779DNNRGVvLihJdvwEjNPWHneZ3416S1uPEk7S64/edit#gid=982722306

## 実装した機能についての画像やGIFおよびその説明


## 実装予定の機能

## データベース設計

## 画面遷移図

## 開発環境
Ruby/Ruby on Rails/JavaScript/MySQL/Github/render/Visual Studio Code

## ローカルでの動作方法
以下のコマンドを順に実行  
git clone https://github.com/orange-soba/material_control.git
cd material_control
bundle install
rails db:create
rails db:migrate

## 工夫したポイント

## 改善点

## 制作時間