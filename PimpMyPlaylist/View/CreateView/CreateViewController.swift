//
//  CreateViewController.swift
//  PimpMyPlaylist
//
//  Created by Antoine THIEL on 26/01/2021.
//

import UIKit

class CreateViewController: UIViewController {
    let UserApi = UserService()
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmField: UITextField!
    @IBOutlet var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.setTitle(NSLocalizedString("controller.create.createButton", comment: ""), for: .normal)
        self.loginButton.setTitle(NSLocalizedString("controller.create.loginButton", comment: ""), for: .normal)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClick(_ sender: Any) {
        guard usernameField.text != nil else {
            return
        }
        guard emailField.text != nil else {
            return
        }
        guard passwordField.text != nil else {
            return
        }
        
        //Call api pour créer le compte, sur retour de l'api
        //changer de view.
        UserApi.registerUser(username: usernameField.text!, email: emailField.text!, password: passwordField.text!) { (result) in
            switch result{
            case.success(_):
                let account = getDocumentsDirectory().appendingPathComponent("account.txt")
                do {
                    let string = "true"
                    try string.write(to: account, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print("Failed to fetch token from API")
                }
                DispatchQueue.main.async {
                    let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    self.navigationController?.pushViewController(login, animated: true)
                }
            break
            case .failure(let error):
            print(error)
            break
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(login, animated: true)
    }
    
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}


