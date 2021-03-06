//
//  ViewController.swift
//  taskapp
//
//  Created by 伊藤 大智 on 2017/02/04.
//  Copyright © 2017年 daichi.itoh. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // 個別のデータ読み書き用
    let realm = try! Realm()
    
    // 一覧データ用
    var taskArray = try! Realm().objects(Task.self).sorted(byProperty: "date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
     */
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
        cell.detailTextLabel?.text = dateString + " : " + task.category
        
        return cell
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * 各セルを選択した時に実行されるメソッド
     * @param tableView
     * @param indexPath
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * セルが削除可能なことを伝えるメソッド
     * @param tableView
     * @param indexPath
     */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    /**
     * UITableViewDelegateプロトコルのメソッド
     * 削除ボタン押下時に呼ばれるメソッド
     * @param tableView
     * @param editingStyle
     * @param indexPath
     */
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            // 削除されたタスクを取得
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセル
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
            
            // 未通知のローカル通知一覧出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
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
    
    /**
     * テキスト変更時
     * @param searchBar
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        taskArray = try! Realm().objects(Task.self).filter("category CONTAINS[c] %@", searchBar.text!)
        tableView.reloadData()
    }
    
    
    /**
     * searchボタン押下時
     * @param searchBar
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

