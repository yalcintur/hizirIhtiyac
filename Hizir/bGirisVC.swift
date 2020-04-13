//
//  bGirisVC.swift
//  Hizir
//
//  Created by Yalcin TUR on 13.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit

class bGirisVC: UIViewController {

    @IBOutlet weak var kodTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func girisYapPressed(_ sender: UIButton) {
        if kodTextField.text! == "1Q#123ewQ" {
            
            let bGirisVC = self.storyboard?.instantiateViewController(withIdentifier: "BakanlikVC")
                                   bGirisVC?.modalPresentationStyle = .fullScreen
                                   self.present(bGirisVC!, animated: true, completion: nil)
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
