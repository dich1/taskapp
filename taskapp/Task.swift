//
//  Task.swift
//  taskapp
//
//  Created by 伊藤 大智 on 2017/02/18.
//  Copyright © 2017年 daichi.itoh. All rights reserved.
//

import RealmSwift

class Task: Object {
    // id
    dynamic var id = 0
    // タイトル
    dynamic var title = ""
    // 内容
    dynamic var contents = ""
    // 日時
    dynamic var date = NSDate()
    // カテゴリ
    dynamic var category = ""
    
    /**
     * idをプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
