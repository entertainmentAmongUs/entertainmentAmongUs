//
//  FindpasswordViewController.swift
//  EntertainAmongUs_code_version
//
//  Created by 남궁광 on 2022/03/02.
//

import UIKit
import Toast_Swift
import Alamofire
//코드 간단해서 스택뷰를 나누지 않음.
class FindpasswordViewController: UIViewController {
    var findPasswordLabel: UILabel?
    
    var name: UILabel?
    var nameTextField: UITextField?
    
    var email: UILabel?
    var emailTextField: UITextField?
    
    var certification: UILabel?
    var certificationTextField: UITextField?
    
    var stackView_3: UIStackView?
    
    var cancelButton: UIButton?
    var completeButton: UIButton?
    
    func addpicture(){
        
        let findPasswordLabel: UILabel = {
           let afindPasswordLabel = UILabel()
            afindPasswordLabel.text = "아이디/비밀번호 찾기"
            afindPasswordLabel.font = UIFont.systemFont(ofSize: 30,weight: .heavy)
            afindPasswordLabel.clipsToBounds = true
            afindPasswordLabel.textAlignment = .center
            afindPasswordLabel.numberOfLines = 1
            afindPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
            return afindPasswordLabel
        }()
        
        view.addSubview(findPasswordLabel)
        self.findPasswordLabel = findPasswordLabel
        
        //1번째 스택(이름, 이름과 텍스트 필드)
        /*
        let name:UILabel = {
           let aname = UILabel()
            aname.text = "이름"
            aname.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            aname.clipsToBounds = true
            aname.textAlignment = .left
            aname.numberOfLines = 1
            aname.translatesAutoresizingMaskIntoConstraints = false
            return aname
        }()
        
        view.addSubview(name)
        self.name = name
        
        let nameTextField: UITextField = {
            let anameTextField = UITextField()
            anameTextField.backgroundColor = .white
            anameTextField.borderStyle = .roundedRect
            return anameTextField
        }()
        
        view.addSubview(nameTextField)
        
        self.nameTextField = nameTextField
        
        let stackView: UIStackView = {
           let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(nameTextField)
        */
        
        //2번째 스택(이메일,이메일 텍스트 필드)
        let email:UILabel = {
           let aemail = UILabel()
            aemail.text = "이메일"
            aemail.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            aemail.clipsToBounds = true
            aemail.textAlignment = .left
            aemail.numberOfLines = 1
            aemail.translatesAutoresizingMaskIntoConstraints = false
            return aemail
        }()
        
        view.addSubview(email)
        
        self.email = email
        
        let emailTextField: UITextField = {
            let aemailTextField = UITextField()
            aemailTextField.backgroundColor = .white
            aemailTextField.borderStyle = .roundedRect
            aemailTextField.autocorrectionType = .no
            return aemailTextField
        }()
        
        
        view.addSubview(emailTextField)
        
        self.emailTextField = emailTextField
        
        let stackView_2: UIStackView = {
           let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_2)
        
        stackView_2.addArrangedSubview(email)
        stackView_2.addArrangedSubview(emailTextField)
        
        
        //3번째 스택(인증번호,인증번호 텍스트 필드.)
        let certification:UILabel = {
           let acertification = UILabel()
            acertification.text = "인증번호"
            acertification.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            acertification.clipsToBounds = true
            acertification.textAlignment = .left
            acertification.numberOfLines = 1
            acertification.translatesAutoresizingMaskIntoConstraints = false
            return acertification
        }()
        
        view.addSubview(certification)
        self.certification = certification
        
        let certificationTextField: UITextField = {
            let acertificationTextField = UITextField()
            acertificationTextField.backgroundColor = .white
            acertificationTextField.borderStyle = .roundedRect
            acertificationTextField.autocorrectionType = .no
            return acertificationTextField
        }()
        
        
        view.addSubview(certificationTextField)
        self.certificationTextField = certificationTextField
        
        let stackView_3: UIStackView = {
           let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_3)
        
        stackView_3.addArrangedSubview(certification)
        stackView_3.addArrangedSubview(certificationTextField)
        //스택뷰 숨기기
        
        self.stackView_3 = stackView_3
        stackView_3.isHidden = true
        
        //전체 스택합침.
        let totalStack: UIStackView = {
            let atotalstackView = UIStackView()
            
            atotalstackView.translatesAutoresizingMaskIntoConstraints = false
            atotalstackView.axis = .vertical
            atotalstackView.alignment = .fill
            atotalstackView.distribution = .fill
            atotalstackView.spacing = 15
            return atotalstackView
        }()
        
        view.addSubview(totalStack)
        
        totalStack.addArrangedSubview(findPasswordLabel)
        //totalStack.addArrangedSubview(stackView)
        totalStack.addArrangedSubview(stackView_2)
        totalStack.addArrangedSubview(stackView_3)
        
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        totalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalStack.topAnchor.constraint(equalTo: view.topAnchor,constant: 120).isActive = true
        totalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        totalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        totalStack.spacing = 5
        
        //4번째 스택(취소버튼, 완료버튼)
        let cancelButton: UIButton = {
            let acancelButton = UIButton()
            acancelButton.setTitle("취소", for: .normal)
            acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
            acancelButton.setTitleColor(.systemBlue, for: .normal)
            return acancelButton
        }()
        
        view.addSubview(cancelButton)
        
        self.cancelButton = cancelButton
        
        let complete: UIButton = {
            let acompleteButton = UIButton()
            acompleteButton.setTitle("완료", for: .normal)
            acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
            acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
            acompleteButton.setTitleColor(.systemBlue, for: .normal)
            return acompleteButton
        }()
        
        view.addSubview(complete)
        
        self.completeButton = complete
        
        let StackView_4: UIStackView = {
            let aStackView = UIStackView()
            
            aStackView.translatesAutoresizingMaskIntoConstraints = false
            aStackView.axis = .horizontal
            aStackView.alignment = .fill
            aStackView.distribution = .fillEqually
            aStackView.spacing = 30
            return aStackView
        }()
        
        view.addSubview(StackView_4)
        
        StackView_4.addArrangedSubview(cancelButton)
        StackView_4.addArrangedSubview(complete)
        
        StackView_4.translatesAutoresizingMaskIntoConstraints = false
        StackView_4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        StackView_4.topAnchor.constraint(equalTo: totalStack.bottomAnchor,constant: 24).isActive = true
        StackView_4.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        StackView_4.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        StackView_4.spacing = 30
    }
    

    
    
    
    func isValidEmail(_ email:String) ->Bool{
        //이메일 가능한지 확인
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHes %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    @objc func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)

    }
    
    @objc func completeButton(_ sender: UIButton){
        guard let stackView_3 = stackView_3 else { return }
        
        if stackView_3.isHidden == true {
            let email = emailTextField?.text
            
            if !isValidEmail(email!){
                //email 형식 실패
                self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
                return
            }
            
            let URL = "http://3.39.193.198:8080/emails/\(String(email!))/email"
            
            let param: Parameters = [
                "email" : email!
            ]

            let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
            //결과값으로 문자열을 받을 때 사용
            alamo.responseString() { response in
                switch response.result
                {
                //통신성공
                case .success:
                    let alert = UIAlertController(title: "인증번호가 전송되었습니다.!",message: "",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        stackView_3.isHidden = false
                    })
                    
                    alert.addAction(confirm)
                    
                    self.present(alert,animated: true,completion: nil)

                    
                //통신실패
                case .failure(let error):
                        //print("error: \(String(describing: error.errorDescription))")
                    let alert = UIAlertController(title:"이메일을 확인하세요.",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                        
                        let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                            action in
                            //self.navigationController?.popViewController(animated: true)
                        })
                        
                        alert.addAction(confirm)
                        
                        self.present(alert,animated: true,completion: nil)
                    }
                    
                }
        }
        else{
            let email = emailTextField?.text
            let certification = certificationTextField?.text
            let param: Parameters = [
                "email" : email!,
                "code": certification!
            ]

            if !isValidEmail(email!){
                //email 형식 실패
                self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
                return
            }
            
            let URL = "http://3.39.193.198:8080/emails/email-code"
            
            let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
            //결과값으로 문자열을 받을 때 사용
            alamo.responseString() { response in
                switch response.result
                {
                //통신성공
                case .success:
                    let alert = UIAlertController(title: "비밀번호 변경페이지로 넘어갑니다..",message: "",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        //self.navigationController?.popViewController(animated: true)
                        //비밀번호 페이지 만들자.
                        let chagnePasswordViewController = ChangePasswordViewController()
                        self.navigationController?.pushViewController(chagnePasswordViewController, animated: true)
        

                    })
                    
                    
                    alert.addAction(confirm)
                    
                    self.present(alert,animated: true,completion: nil)
                    
                    
                    //통신실패
                case .failure(let error):
                        //print("error: \(String(describing: error.errorDescription))")
                    let alert = UIAlertController(title:"인증 코드를 다시 확인하세요..",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                        
                        let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                            action in
                            //self.navigationController?.popViewController(animated: true)
                        })
                        
                        alert.addAction(confirm)
                        
                        self.present(alert,animated: true,completion: nil)
                    }
                    
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "아이디/비밀번호 찾기"
        addpicture()
    }
}
