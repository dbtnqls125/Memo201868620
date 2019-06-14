//
//  MainTableViewController.swift
//  RealmMemo03
//
//  Created by dit02 on 2019. 6. 13..
//  Copyright © 2019년 201820028. All rights reserved.
//

import UIKit
import RealmSwift

class Memo: Object { //Memo class
    @objc dynamic var content: String = ""
    @objc dynamic var date = Date()
}

class MainTableViewController: UITableViewController { //메모장 MAIN TableViewController

    @IBOutlet var myTableView: UITableView!
    
    let realm = try! Realm()
    var memoArray: Results<Memo>?
    
    let formatter: DateFormatter = { //Now Time
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        format.locale = Locale(identifier: "Ko_kr")
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        memoArray = realm.objects(Memo.self)
    }
    
    override func viewWillAppear(_ animated: Bool) { //viewDidLoad 이전에 실행
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memoArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let target = memoArray![indexPath.row] //memoArray에 저장된 값
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.date)

        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = myTableView.indexPath(for: cell) { //메모 보기에 값 넘겨주기 위해 segue Setting
            let target = memoArray![indexPath.row]
            
            if let vc = segue.destination as? DetailViewController {
                vc.memo = target
                vc.content = target.content
                vc.date = target.date
            }
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { //Cell 밀어서 삭제
        return .delete
    }

     //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            //realm에 저장된 데이터도 Delete
            let realm = try! Realm()
            try! realm.write {
                realm.delete(memoArray![indexPath.row])
            }
            memoArray = realm.objects(Memo.self)
            self.myTableView.reloadData()
            
        } else if editingStyle == .insert {
             //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
