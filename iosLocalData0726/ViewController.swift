//
//  ViewController.swift
//  iosLocalData0726
//
//  Created by 503_18 on 26/07/2019.
//  Copyright © 2019 503_18. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    @IBAction func memorySave(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).shareData = tf.text!
    }
    
    @IBOutlet weak var udtf: UITextField!
    
    @IBAction func udSave(_ sender: Any) {
        //UserDefault
        let ud = UserDefaults.standard
        ud.set(udtf.text,forKey: "msg")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //화면에 출력할 때 마다 호출되는 데이터
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AppDelegate에 선언한 sharedData라는 프로퍼티 가져와서 텍스트 필드에 출력하기
        tf.text = (UIApplication.shared.delegate as! AppDelegate).shareData
        
        //UserDefaults에 저장된 msg에 저장된 내용을 udft에 출력하기
        let ud = UserDefaults.standard
        //msg 에 데이터가 없으면 리턴
        guard let msg = ud.string(forKey: "msg") else{
            udtf.text = "데이터가 없습니다."
            return
        }
        //내용출력
        udtf.text = msg
        
        
    }
    
    //화면을 터치했을 때 호출되는 메소드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //tf의 FirstResponder를 제거
        tf.resignFirstResponder()
        udtf.resignFirstResponder()
    }

}

