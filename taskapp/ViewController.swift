//
//  ViewController.swift
//  taskapp
//
//  Created by 伊藤 大智 on 2017/02/04.
//  Copyright © 2017年 daichi.itoh. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    // 個別のデータ読み書き用
    let realm = try! Realm()
    
    // 一覧データ用
    let taskArray = try! Realm().objects(Task.self).sorted(byProperty: "date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    /**
     * UITableViewDatasourceプロトコルのメソッド(必須)
     * 各セルの内容を返すメソッド
     * @param tableView
     * @param indexPath
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 各セルのデータを取得しCellに値(タイトル、日付)を設定
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString: String = formatter.string(from: task.date as Date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * 各セルを選択した時に実行されるメソッド
     * @param tableView
     * @param indexPath
     **/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * セルが削除可能なことを伝えるメソッド
     * @param tableView
     * @param indexPath
     **/
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
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
        if editingStyle == UITableViewCellEditingStyle.delete {
            // データベースから削除
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    /**
     * 画面遷移時に呼ばれるメソッド
     * @param segue
     * @param sender
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        let inputViewController: InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            // 作成済みのタスクの編集
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            // 新規作成
            let task = Task()
            task.date = NSDate()
            
            // 既存タスク数に1加える
            if taskArray.count != 0 {
                task.id = taskArray.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
        
    }
}

