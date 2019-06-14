//
//  DetailViewController.swift
//  RealmMemo03
//
//  Created by dit02 on 2019. 6. 14..
//  Copyright © 2019년 201820028. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDataSource {
    
    var memo:Memo?
    
    let realm = try! Realm()
    var memoArray: Results<Memo>?
    
    @IBOutlet weak var DetailTableView: UITableView!
    
    var content: String?
    var date = Date()
    
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        format.locale = Locale(identifier: "Ko_kr")
        return format
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: //메모의 cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) //날짜의 cell
            
            cell.textLabel?.text = formatter.string(for: memo?.date)
            
            return cell
            
        default :
            fatalError()
        }
    }
    
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Memo", message: "Delete Memo?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {(action) in
            
            //realm에 저장된 데이터 삭제
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.memo!)
            }
            //pop설정을 해줘야 메모 목록으로 돌아간다
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DetailTableView.reloadData()
    }
    
    //메모 수정을 위해 데이터 AddViewController로 넘긴다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? AddViewController {
            vc.editTarget = memo
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
