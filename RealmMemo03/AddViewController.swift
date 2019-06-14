//
//  AddViewController.swift
//  RealmMemo03
//
//  Created by dit02 on 2019. 6. 13..
//  Copyright © 2019년 201820028. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    var editTarget: Memo? //Memo에 저장된 값 수정
    
    @IBOutlet weak var memoTextView: UITextView!
    
    let realm = try! Realm()
    var memoArray: Results<Memo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget { //수정 모드
            navigationItem.title = "Edit"
            memoTextView.text = memo.content
            
        } else { //새 메모 모드
            navigationItem.title = "Write Memo"
            memoTextView.text = ""
        }
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        let newMemo = Memo()
        let realm = try! Realm()

        newMemo.content = memoTextView.text //새 메모의 값은 TextView의 값으로 설정
        
        if let editTarget = editTarget {//메모 수정모드라면 TextView에 새롭게 입력한 값으로 realm에 저장
            try! realm.write {
                editTarget.content = newMemo.content
                realm.add(editTarget)
                
            }
        } else {
            try! realm.write {
                realm.add(newMemo)
            }
        }
        
        //저장이 완료되면 메모 목록으로 돌아간다
        dismiss(animated: true, completion: nil)
        
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
