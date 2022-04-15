//
//  LoginViewController.swift
//  EntertainAmongUs_code_version
//
//  Created by 남궁광 on 2022/02/26.
//

import UIKit
import Toast_Swift
import Alamofire
import SystemConfiguration



class LoginViewController: UIViewController {
    //View
    var imageView: UIImageView?
    var game_name: UILabel?
    var stackview: UIStackView?
    
    var id:UILabel?
    var idTextField:UITextField?
    var password:UILabel?
    var passwordTextField:UITextField?
    var stackview_2: UIStackView?
    
    var signInButton:UIButton?
    var signUpButton:UIButton?
    var stackview_3: UIStackView?

    var googleLoginButton:UIButton?
    var appleLoginButton:UIButton?
    var stackview_4: UIStackView?

    var forgetPassword:UIButton?
    
    //Other
    // MARK: - Method
    /* MARK: Create View Method */
    func addpicture(){
        //1번째 스택뷰(게임 이미지와 게임 이름 나타냄.)
        let imageView: UIImageView = {
                let aimageView = UIImageView()
                aimageView.backgroundColor = .systemYellow
                //표시될 UIImage 객체 부여
                aimageView.image = UIImage(systemName: "signature")
                aimageView.tintColor = .white
                aimageView.translatesAutoresizingMaskIntoConstraints = false
                aimageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
                aimageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
                return aimageView
            }()
        
        view.addSubview(imageView)
 
        let game_name: UILabel = {
            let agame_name = UILabel()
            agame_name.text = "우리끼리 예능"
            agame_name.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
            agame_name.clipsToBounds = true
            agame_name.textAlignment = .center
            agame_name.numberOfLines = 1
            agame_name.textColor = .black
            agame_name.translatesAutoresizingMaskIntoConstraints = false
            return agame_name
        }()
        view.addSubview(game_name)

        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 0
            return stackView
        }()
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(game_name)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor,constant:100).isActive = true

        self.stackview = stackView
    }
    
    func addpicture_2(){
        guard let stackview = self.stackview else { return }
        //2번째 스택뷰(아이디,아이디필드,비번,비밀번호 필드)
        //ID label
        let id : UILabel = {
           let aid = UILabel()
            aid.text = "이메일"
            aid.textColor = .black
            aid.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            //aid.textAlignment = .center
            aid.translatesAutoresizingMaskIntoConstraints = false
            return aid
        }()
        
        view.addSubview(id)
        //ID textField
        let idtextField: UITextField = {
            let aidtextField = UITextField()
            aidtextField.backgroundColor = .white
            aidtextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
            aidtextField.autocapitalizationType = .none
            aidtextField.borderStyle = .roundedRect
            aidtextField.placeholder = "이메일을 입력하세요"
            return aidtextField
        }()
        
        self.idTextField = idtextField
        
        view.addSubview(idtextField)

        //password label
        let password : UILabel = {
            let apassword = UILabel()
            apassword.text = "비밀번호"
            apassword.textColor = .black
            apassword.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            apassword.translatesAutoresizingMaskIntoConstraints = false
            return apassword
        }()
        
        view.addSubview(password)

        //password textField
        let passtextField: UITextField = {
            let apasstextField = UITextField()
            apasstextField.backgroundColor = .white
            apasstextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
            apasstextField.borderStyle = .roundedRect
            apasstextField.autocapitalizationType = .none
            apasstextField.placeholder = "비밀번호를 입력하세요."
            apasstextField.isSecureTextEntry = true
            return apasstextField
        }()
        
        view.addSubview(passtextField)
        
        self.passwordTextField = passtextField
        
        //stackview
        let stackView_2: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        
        view.addSubview(stackView_2)
        
        stackView_2.addArrangedSubview(id)
        stackView_2.addArrangedSubview(idtextField)
        stackView_2.addArrangedSubview(password)
        stackView_2.addArrangedSubview(passtextField)

        stackView_2.translatesAutoresizingMaskIntoConstraints = false
        //stackView_2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView_2.topAnchor.constraint(equalTo: stackview.bottomAnchor,constant:30).isActive = true
        stackView_2.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        stackView_2.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        
        self.stackview_2 = stackView_2
    }
    
    func addpicture_3(){
        guard let stackview_2 = self.stackview_2 else { return }
        //3번째 스택뷰(로그인버튼, 로그아웃 버튼) -> 이메일 형식 지킬 수 있게 SignInButton에 기능을 넣어둠.
        let signInButton: UIButton = {
            let asignInButton = UIButton()
            asignInButton.setTitle("로그인", for: .normal)
            asignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            asignInButton.addTarget(self, action: #selector(self.signInButton(_:)), for: .touchUpInside)
            asignInButton.setTitleColor(.systemBlue, for: .normal)
            return asignInButton
        }()
        
        view.addSubview(signInButton)
        
        
        let signUpButton: UIButton = {
            let asignUpButton = UIButton()
            asignUpButton.setTitle("회원가입", for: .normal)
            asignUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            asignUpButton.addTarget(self, action: #selector(self.signUpButton(_:)), for: .touchUpInside)
            asignUpButton.setTitleColor(.systemBlue, for: .normal)
            return asignUpButton
        }()
        
        view.addSubview(signUpButton)
        
        let stackView_3: UIStackView = {
           let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 10
            return stackView
        }()
        view.addSubview(stackView_3)
        
        stackView_3.addArrangedSubview(signInButton)
        stackView_3.addArrangedSubview(signUpButton)
        
        stackView_3.translatesAutoresizingMaskIntoConstraints = false
        stackView_3.topAnchor.constraint(equalTo: stackview_2.bottomAnchor,constant: 10).isActive=true
        stackView_3.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        stackView_3.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        
        self.stackview_3 = stackView_3
        
    }
    
    func addpicture_4(){
        guard let stackview_3 = self.stackview_3 else { return }
        //4번째 스택뷰(구글과 애플 로그인) -> 아직 기능은 미완이다. 백엔드와 연동예정.
        let GoogleButton: UIButton = {
            let aGoogleButton = UIButton()
            aGoogleButton.setTitle("Google로 계속하기", for: .normal)
            aGoogleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
            aGoogleButton.setImage(UIImage(named: "logo_google"), for: .normal)
            aGoogleButton.setTitleColor(.black, for: .normal)
            //aSignInButton.addTarget(self, action: #selector(self.touchCancleButton(_:)), for: .touchUpInside)
            return aGoogleButton
        }()
        
        view.addSubview(GoogleButton)
        
        let AppleButton: UIButton = {
            let aAppleButton = UIButton()
            aAppleButton.setTitle("Apple로 계속하기", for: .normal)
            aAppleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            aAppleButton.setImage(UIImage(named: "logo_apple"), for: .normal)
            aAppleButton.setTitleColor(.black, for: .normal)
            //aSignUpButton.addTarget(self, action: #selector(self.touchSignUpButton(_:)), for: .touchUpInside)
            return aAppleButton
        }()
        
        view.addSubview(AppleButton)
        
        let stackView_4: UIStackView = {
           let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 30
            return stackView
        }()
        
        view.addSubview(stackView_4)
        
        stackView_4.addArrangedSubview(GoogleButton)
        stackView_4.addArrangedSubview(AppleButton)
        
        stackView_4.translatesAutoresizingMaskIntoConstraints = false
        stackView_4.topAnchor.constraint(equalTo: stackview_3.bottomAnchor,constant: 40).isActive=true
        stackView_4.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        stackView_4.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        
        self.stackview_4 = stackView_4

    }
    
    func addpicture_5(){
        guard let stackview_4 = stackview_4 else { return }

        let forgetPassword: UIButton = {
           let aforgetPassword = UIButton()
            aforgetPassword.setTitle("아이디 또는 비밀번호를 잊으셨나요?", for: .normal)
            aforgetPassword.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
            aforgetPassword.addTarget(self, action: #selector(self.forgetPasswordButton(_:)), for: .touchUpInside)
            aforgetPassword.setTitleColor(.systemRed, for: .normal)
            return aforgetPassword
        }()
        
        view.addSubview(forgetPassword)
        
        forgetPassword.translatesAutoresizingMaskIntoConstraints = false
        forgetPassword.topAnchor.constraint(equalTo: stackview_4.bottomAnchor,constant: 30).isActive = true
        forgetPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        forgetPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
    }
    

    
    
    //이메일과 비밀번호 형시을 확인하는 방법이다. Toast사용함.
    func signInAction(){
        let id = idTextField?.text
        let pass = passwordTextField?.text
        let mainPage = MainPageViewController()
        
        if !isValidEmail(id!){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        if !isVaildPass(pass!){
            //비밀번호 형식 실패
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        
        let URL = "http://3.37.123.140:8080/users/login"
        
        let param: Parameters = [
            "email":id!,
            "password":pass!
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode:200..<300)
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "로그인 성공!",message: "확인버튼을 누르시면 로그인됩니다!",preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    self.navigationController?.pushViewController(mainPage, animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
            
                
                
            case .failure(let error):
                //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title: "이메일 혹은 비밀번호를 다시 확인하세요.!",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler:nil)
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
            }
            
        }
        
        //self.navigationController?.pushViewController(mainPage, animated: true)
        //mainPage.modalPresentationStyle = .fullScreen
        //present(mainPage,animated: true, completion: nil)
        
        
        
    }
    
    
    func isValidEmail(_ email:String) ->Bool{
        //이메일 가능한지 확인
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHes %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    func isVaildPass(_ pass:String)->Bool{
        //비밀번호 가능한지 확인
        let passRefEx = "^[a-zA-Z0-9]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
        
    }
    
    
    
    //로그인 할 때 발생되는 것 -> objc은 오브젝트c와 연동하기위함이다.
    @objc func signInButton(_ sender: UIButton) {
        //일단 이메일 형식과 비밀번호 형식이 참이어야 로그인 되게 만들어 놓음 -> 나중엔 서버에 아이디가 있어야 로그인 되게 만들어야함.
        signInAction()
    }
    
    
    @objc func signUpButton(_ sender: UIButton){
        let signUpView = SignUpViewController()
        self.navigationController?.pushViewController(signUpView, animated: true)
        //signUpView.modalPresentationStyle = .fullScreen
        //present(signUpView,animated: true, completion: nil)

    }
    
    @objc func forgetPasswordButton(_ sender: UIButton){
        let forgetPasswordView = FindpasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordView, animated: true)
        //forgetPasswordView.modalPresentationStyle = .fullScreen
        //present(forgetPasswordView,animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //background 색 변경하기.
        self.view.backgroundColor = .white
        addpicture()
        addpicture_2()
        addpicture_3()
        addpicture_4()
        addpicture_5()
    }
    
}



