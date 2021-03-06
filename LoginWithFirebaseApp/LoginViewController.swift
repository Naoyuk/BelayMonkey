//
//  LoginViewController.swift
//  LoginWithFirebaseApp
//
//  Created by NaoyukiIshida on 2021-08-17.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var moveToSigninButton: UIButton!
    
    @IBAction func tappedMoveToSigninButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedLoginButton(_ sender: Any) {
        print("tapped Login Button!!")
        
        HUD.show(.progress, onView: self.view)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Login情報の取得に失敗しました。", err)
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            } else {
                print("Loginに成功しました。" )
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let userRef = Firestore.firestore().collection("users").document(uid)
                userRef.getDocument { (snapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        HUD.hide { (_) in
                            HUD.flash(.error, delay: 1)
                        }
                        return
                    }
                    
                    guard let data = snapshot?.data() else { return }
                    let user = User.init(dic: data)
                    print("ユーザー情報の取得に成功しました。\(user.name)")
                    HUD.hide { (_) in
                        HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                            self.presentToHomeViewConrtoller(user: user)
                        }
                    }
                    

                }
            }
        }
    }
    
    private func presentToHomeViewConrtoller(user: User) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 125, green: 125, blue: 125)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 125, green: 125, blue: 125)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 45, green: 176, blue: 78)
        }
        
        print("textField.text: ", textField.text)
    }
    
}
