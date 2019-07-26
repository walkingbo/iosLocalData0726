
import UIKit

class ViewController: UIViewController {
    var dbPath:String!
    
    @IBOutlet var txtName: UITextField!
    
    @IBOutlet var txtPhone: UITextField!
    
    @IBAction func select1(_ sender: Any) {
    }
    
    @IBAction func insert1(_ sender: Any) {
        //name 입력란과 phone 입력란의 텍스트를 가져오기
        let name = txtName.text
        let phone = txtPhone.text
        
        //데이터 삽입 sql 만들기
        //값을 바로 입력하지 않고 바인딩을 하는 이유는
        //값을 직접 입력할려면 문자는 작은 따옴표를 붙여야하고
        //날짜는 형식에 맞춰서 주어야 하기 때문입니다.
        let sql = "insert into contact(name, phone) values(?,?)"
        //데이터베이스 접속 만들기
        let db = FMDatabase(path:dbPath)
        if db.open() == true{
            //insert 구문 실행
            db.executeUpdate(sql, withArgumentsIn:[name!, phone!])
            txtName.text = ""
            txtPhone.text = ""
            db.close()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docPath = docPaths[0]
        dbPath = docPath + "/contact.sqlite"
        //파일이 없으면 파일을 생성하고 테이블 만들기
        let fm = FileManager.default
        if !fm.fileExists(atPath: dbPath){
            let db = FMDatabase(path:dbPath)
            //데이터베이스 열기
            if db.open() == true{
                //테이블 만들기
                let sql = "create table if not exists contact(id integer primary key autoincrement, name text, phone text)"
                db.executeStatements(sql)
                db.close()
            }

        
    }


}
}
