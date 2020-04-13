//
//  NeedVC.swift
//  Hizir
//
//  Created by Yalcin TUR on 12.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit
import Firebase

class NeedVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedUrun = pickerData[row] // selected item
    }
    
    
    @IBOutlet weak var miktarLabel: UILabel!
    
    var selectedUrun = "" as String
    var miktar = 0 as Int
    var aciliyet = 2 as Int
    

    @IBOutlet weak var adLabel: UILabel!
    
    @IBOutlet weak var ihtiyacPickerView: UIPickerView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var pickerData = ["Dezenfektan", "N95-Maske", "Maske", "Eldiven"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let UID=Auth.auth().currentUser?.uid
              
        let ref = Database.database().reference()
        
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("isim").observeSingleEvent(of: .value) { (snapshot) in
            guard let gerçekIsim = snapshot.value as? String else { return }
                print(gerçekIsim)
                self.adLabel.text = gerçekIsim
            }}})
        
        
       self.ihtiyacPickerView.dataSource = self;
       self.ihtiyacPickerView.delegate = self;
        
        
        
    //
       

        
    }
    

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            aciliyet = 1
        case 1:
            aciliyet = 2
        default:
            break
        }
    }
    
    
    @IBAction func geriButtonPressed(_ sender: UIButton) {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                   mainVC?.modalPresentationStyle = .fullScreen
                   self.present(mainVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        miktarLabel.text = Int(sender.value).description
        miktar = Int(sender.value)
    }
    
    @IBAction func gonderButtonPressed(_ sender: UIButton) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        let UID=Auth.auth().currentUser?.uid
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("hastane").observeSingleEvent(of: .value) { (snapshot) in
            guard let hastaneGerçek = snapshot.value as? String else { return }
                print(hastaneGerçek)
                
                Database.database().reference().child("Kullanicilar").child(UID!).child("isim").observeSingleEvent(of: .value) { (snapshot) in
                guard let isimGerçek = snapshot.value as? String else { return }
                    print(isimGerçek)
                
                    ref.child("Ihtiyaclar").child(hastaneGerçek).child(self.selectedUrun).child(UID!).setValue(["isteyen": isimGerçek,"onem":String(self.aciliyet), "tane":String(self.miktar), "onay":false, "tip":self.selectedUrun])
                }}}})
        
        
        let alert = UIAlertController(title: "Başarılı", message: "İhtiyacınız başarıyla alınmıştır.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil) // tamam butonu tanımı
        alert.addAction(okButton) // action eklendi.
        // yapıları görüntülemede kullanılır.
        self.present(alert, animated: true, completion: geriDonus)
    }
    
    func geriDonus(){
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                      mainVC?.modalPresentationStyle = .fullScreen
                      self.present(mainVC!, animated: true, completion: nil)
    }
    
}
