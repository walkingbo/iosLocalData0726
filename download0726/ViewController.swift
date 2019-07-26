import UIKit

import Alamofire
import Nuke

class ViewController: UIViewController {
    //이미지를 출력할 뷰
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //화면 전체크기를 얻어내기
        let frame = UIScreen.main.bounds
        
        //뷰를 만들고 배치
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        imageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        //부모 뷰에 배치
        self.view.addSubview(imageView)
        
        /*
        //동기적으로 이미지를 다운로드 받아서 imageView에 출력
        let addr = "http://192.168.0.131:8090/images/car.jpg"
        let imageUrl = URL(string:addr)
        let imageData = try! Data(contentsOf: imageUrl!)
        let image = UIImage(data: imageData)
        imageView.image = image
        */
        /*
        //Alamofire를 이용한 다운로드
        let request = Alamofire.request("http://192.168.0.131:8090/images/car.jpg", method:.get, parameters:nil)
        request.response{
            response in
                let url = URL(string: "http://192.168.0.131:8090/images/car.jpg")
            //Nuke의 이미지 처리 옵션 만들기
            let options = ImageLoadingOptions(placeholder: UIImage(named: "RedCoffee.png"), transition: .fadeIn(duration: 2))
            Nuke.loadImage(with: url!, options: options, into: self.imageView)
        }
        */
        
        
        //저장된 파일을 읽고 쓰기 위한 인스턴스를 가져오기
        let fm = FileManager.default
        //도큐먼트 디렉토리 경로를 생성(번들은 기록을 못함)
        //tmp 디렉토리는 데이터가 소멸될 수 있음 )
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        //이미지 파일의 경로와 업데이트 된 시간을 기족하는 파일의 경로를 생성
        let imagePath = docDir + "/car.jpg"
        let updatePath = docDir + "/update.txt"
        
        //업데이트한 시간 찾아오기(json-192.168.0.131:8090/updatetime)
        let request = Alamofire.request("http://192.168.0.131:8090/updatetime",method: .get,encoding:JSONEncoding.default,headers:[:])
        request.responseJSON{
            response in
            //에러가 발생한 경우 - 서버에 접속이 안되는 경우
            if response.error != nil{
                print("서버와 연결이 되지 않음")
                let image = UIImage(named: "red.jpg")
                self.imageView.image = image
                return
            }
            
            //업데이트 한 시간을 저장할 변수
            var updateTimeString = ""
            //업데이트 한 시간을 저장한 파일이 존재하는지 확인
            //파일이 존재하는 경우
            if fm.fileExists(atPath: updatePath) == true{
                print("업데이트 한 시간을 기록한 파일이 존재")
                //파일의 내용읽기
                let dataBuffer = fm.contents(atPath: updatePath)
                //문자열로 변환
                let localUpdateTime = String(data:dataBuffer!,encoding: .utf8)
                //서버에서 읽어온 데이터를 문자열로 변환
                if let jsonObject = response.result.value as? [String:Any]{
                    updateTimeString = jsonObject["result"] as! String
                    //서버에서 읽어온 것과 로컬에 저장된 내용이 같으면
                    if updateTimeString == localUpdateTime{
                        //로컬에 있는 내용 출력
                        print("최신 업데이트 내용입니다.")
                        //imagePath의 내용을 출력
                        let dataBuffer = fm.contents(atPath: imagePath)
                        let image = UIImage(data: dataBuffer!)
                        self.imageView.image = image
                        return
                    }else{
                        //업데이트를 기록한 파일을 삭제
                        try! fm.removeItem(atPath: updatePath)
                    }
                }
                
            }
                //업데이트를 기록한 파일이 없으면 기록
                fm.createFile(atPath: updatePath, contents: updateTimeString.data(using: .utf8), attributes: nil)
                //이미지를 다운로드 받아서 저장
                let request = Alamofire.request("http://192.168.0.131:8090/images/car.jpg",method: .get,parameters: nil)
                request.response{
                    response in
                    //이미지 출력
                    let image = UIImage(data: response.data!)
                    self.imageView.image = image
                    
                    //기존의 이미지 파일이 있으면 삭제
                    if fm.fileExists(atPath: imagePath){
                        try! fm.removeItem(atPath: imagePath)
                    }
                    //파일에 기록
                    fm.createFile(atPath: imagePath, contents: response.data!, attributes: nil)
            }
                
            }
           
        
        
        
    }


}

