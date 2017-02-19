//
//  InputViewController.swift
//  taskapp
//
//  Created by 伊藤 大智 on 2017/02/12.
//  Copyright © 2017年 daichi.itoh. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 遷移直前に読まれる
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    /**
     * キーボードを閉じるメソッド
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     * タスクのローカル通知を登録する
     * @param task
     */
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents
        content.sound = UNNotificationSound.default()
        
        // 通知を発動するトリガーの作成
        let calender = NSCalendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // ローカル通知のリクエストを作成
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // 通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
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
