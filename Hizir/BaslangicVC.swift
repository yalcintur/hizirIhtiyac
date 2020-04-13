//
//  BaslangicVC.swift
//  Hizir
//
//  Created by Yalcin TUR on 13.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit

class BaslangicVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
  
    @IBAction func doktorPressed(_ sender: UIButton) {
        let bGirisVC = self.storyboard?.instantiateViewController(withIdentifier: "Giris")
                   bGirisVC?.modalPresentationStyle = .fullScreen
                   self.present(bGirisVC!, animated: true, completion: nil)
    }
    @IBAction func bakanlikPressed(_ sender: UIButton) {
        let bGirisVC = self.storyboard?.instantiateViewController(withIdentifier: "bGirisVC")
                         bGirisVC?.modalPresentationStyle = .fullScreen
                         self.present(bGirisVC!, animated: true, completion: nil)    }
}

