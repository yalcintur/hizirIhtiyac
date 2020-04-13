//
//  ViewController.swift
//  Hizir
//
//  Created by Yalcin TUR on 11.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var ref:DatabaseReference!
    
    @IBOutlet weak var tcKimlikTextField: UITextField!
    
    @IBOutlet weak var eDevletTextField: UITextField!
    
    var tcKimlik = "" as String
          
    var eDevlet = "" as String
    var artistsList=[ArtistModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() { auth, user in
          if user != nil {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            mainVC?.modalPresentationStyle = .fullScreen
            self.present(mainVC!, animated: true, completion: nil)
            self.tcKimlikTextField.text = nil
            self.eDevletTextField.text = nil
          }
        }
        }
        

    @IBAction func girisYapButton(_ sender: UIButton) {


        guard let tcKimlik = tcKimlikTextField.text else { return }
        guard let eposta = eDevletTextField.text else { return }
        Auth.auth().signIn(withEmail: eposta, password: tcKimlik) { user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
          }
        }

        }
    
    // Start Editing The Text Field
       func textFieldDidBeginEditing(_ textField: UITextField) {
           moveTextField(textField, moveDistance: -250, up: true)
       }
       
       // Finish Editing The Text Field
       func textFieldDidEndEditing(_ textField: UITextField) {
           moveTextField(textField, moveDistance: -250, up: false)
       }
       
       // Hide the keyboard when the return key pressed
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
       // Move the text field in a pretty animation!
       func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
           let moveDuration = 0.3
           let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
           
           UIView.beginAnimations("animateTextField", context: nil)
           UIView.setAnimationBeginsFromCurrentState(true)
           UIView.setAnimationDuration(moveDuration)
           self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
           UIView.commitAnimations()
       }
}

