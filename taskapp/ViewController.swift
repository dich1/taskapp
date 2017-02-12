//
//  ViewController.swift
//  taskapp
//
//  Created by 伊藤 大智 on 2017/02/04.
//  Copyright © 2017年 daichi.itoh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * UITableViewDatasourceプロトコルのメソッド(必須)
     * データの数(=セルの数)を返すメソッド
     * @param tableView
     * @param section
     **/
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /**
     * UITableViewDatasourceプロトコルのメソッド(必須)
     * 各セルの内容を返すメソッド
     * @param tableView
     * @param indexPath
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * 各セルを選択した時に実行されるメソッド
     * @param tableView
     * @param indexPath
     **/
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * セルが削除可能なことを伝えるメソッド
     * @param tableView
     * @param indexPath
     **/
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * セルが削除可能なことを伝えるメソッド
     * @param tableView
     * @param editingStyle
     * @param indexPath
     **/
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

