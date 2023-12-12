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
8.詳細ページにて材料計算ボタンを押すと材料計算結果が表示される

## アプリケーションを作成した背景
前職(機械製造業)において材料の発注を一部任されていたが、その時に教わった材料の頼み方が「多分これが足りない」といった勘を元にしたものだった。材料を無駄なく頼もうと思ったら図面を全て読み、材料を計算しなければならず、1日がかりの作業になっていた。  
そこで完成品/部品作成に必要な部品や材料さえ登録すれば一瞬で全ての必要な部品や材料を出力出来るアプリがあればそういった悩みを持つ人の助けになると思い、当アプリの作成に至った。

## 洗い出した要件
https://docs.google.com/spreadsheets/d/14od779DNNRGVvLihJdvwEjNPWHneZ3416S1uPEk7S64/edit#gid=982722306

## 実装した機能についての画像やGIFおよびその説明
・完成品/部品詳細ページの材料計算ボタンをクリックすることで、それを作成するのに必要な部品や材料、また在庫と比較して発注が必要なものが表示される(必要な部品や材料が登録されていない部品を既製品として扱い必要な部品として計算する、下記イメージで言うとPartA11やPartA2が該当)  

[![Image from Gyazo](https://i.gyazo.com/bba7f4e1c014151c92844f3a40155ad6.png)](https://gyazo.com/bba7f4e1c014151c92844f3a40155ad6)

・実際の登録例(イメージ図)と計算結果の例
[![Image from Gyazo](https://i.gyazo.com/e9ad97d83802f3e78d0ac933d531c46d.png)](https://gyazo.com/e9ad97d83802f3e78d0ac933d531c46d)
[![Image from Gyazo](https://i.gyazo.com/1c2200cf262dbf02d47d2dc7e747ca7b.png)](https://gyazo.com/1c2200cf262dbf02d47d2dc7e747ca7b)

## 実装予定の機能
・部品や材料の検索機能(部品名,材料名による検索や材料から材料を使用している部品の検索)  
・材料計算の際の切り代の設定をできる機能  
・図面や部品の写真などの画像を紐付けて登録する機能  
・発注書をpdfで自動作成する機能  

## データベース設計
[![Image from Gyazo](https://i.gyazo.com/aa510e840d1d9e084648a1c3b68106e4.png)](https://gyazo.com/aa510e840d1d9e084648a1c3b68106e4)

## 画面遷移図
[![Image from Gyazo](https://i.gyazo.com/8d9cecaefc17a63dbb28de1bc6138b9b.png)](https://gyazo.com/8d9cecaefc17a63dbb28de1bc6138b9b)

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
部品作成に必要な部品や材料を登録済みのものに限らずさらに深掘りして計算する機能を実装した。  
下記イメージ図を元にすると完成品AにはPartA11等も作成に必要だが、完成品AとPartA11に親子関係の登録はしなくても、「完成品A => PartA => PArtA1 => PartA11」と自動で計算をする。完成品Aだけではなくそれぞれの部品でも材料計算は可能(下記イメージのPartBで材料計算をすると材料Bだけが必要なものとして表示される)。  
そのために再帰関数を用いて機能を実装した。(最低限の親子関係の登録は必要)

[![Image from Gyazo](https://i.gyazo.com/bba7f4e1c014151c92844f3a40155ad6.png)](https://gyazo.com/bba7f4e1c014151c92844f3a40155ad6)

## 改善点
・部品の登録などの作業を簡略化する機能を模索中  

## 制作時間
約150時間