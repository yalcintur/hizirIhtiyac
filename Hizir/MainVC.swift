//
//  MainVC.swift
//  Hizir
//
//  Created by Yalcin TUR on 12.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hastaneLabel: UILabel!
    
    @IBOutlet weak var adLabel: UILabel!
    
    @IBOutlet weak var gorevLabel: UILabel!
    var artistsList=[ArtistModel]()
    @IBOutlet weak var tblArtists: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        let artist: ArtistModel
        artist = artistsList[indexPath.row]
        
        cell.isim.text = artist.isteyen
        cell.tür.text = artist.tip
        cell.aciliyet.text = "\(artist.onem!). Derece"
        if artist.tip! == "Dezenfektan" {
            cell.miktar.text = "\(artist.tane!) Litre"
        }
        else{
            cell.miktar.text = "\(artist.tane!) Tane"
        }
        if (artist.onem)! == "1" {
            cell.acilGorsel.image = #imageLiteral(resourceName: "icons8-high-priority-80-2")
        }
        else{
            cell.acilGorsel.image = #imageLiteral(resourceName: "icons8-high-priority-80")
       }
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    @IBAction func deneme(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email
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
                
                ref.child("Ihtiyaclar").child(hastaneGerçek).child("maske").setValue(["isteyen": isimGerçek,"önem":"yüksek", "tane":10, "onay":false])
                }}}})

        
    }
    
    @IBAction func cikis(_ sender: UIButton) {
        

        let alert = UIAlertController(title: "Çıkmak istediğinize emin misiniz?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "iptal", style: .cancel, handler: nil))
         
        alert.addAction(UIAlertAction(title: "tamam", style: .default, handler: { action in
         
        let firebaseAuth = Auth.auth()
              do {
                try firebaseAuth.signOut()
                  let needVC = self.storyboard?.instantiateViewController(withIdentifier: "Giris")
                  needVC?.modalPresentationStyle = .fullScreen
                  self.present(needVC!, animated: true, completion: nil)
                  
              } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
              }
            
        }))
         
        self.present(alert, animated: true)
        
          
    }
    
    @IBAction func ihtiyacButtonPressed(_ sender: UIButton) {
        let needVC = self.storyboard?.instantiateViewController(withIdentifier: "NeedVC")
                   needVC?.modalPresentationStyle = .fullScreen
        self.present(needVC!, animated: true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UID=Auth.auth().currentUser?.uid
        
        var ref = Database.database().reference()
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("hastane").observeSingleEvent(of: .value) { (snapshot) in
            guard let hastaneGerçek = snapshot.value as? String else { return }
                print(hastaneGerçek)
                self.hastaneLabel.text=hastaneGerçek
            }}})
        
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("meslek").observeSingleEvent(of: .value) { (snapshot) in
            guard let gerçekMeslek = snapshot.value as? String else { return }
                print(gerçekMeslek)
                self.gorevLabel.text = gerçekMeslek
            }}})
        
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("isim").observeSingleEvent(of: .value) { (snapshot) in
            guard let gerçekIsim = snapshot.value as? String else { return }
                print(gerçekIsim)
                self.adLabel.text = gerçekIsim
            }}})
        
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("hastane").observeSingleEvent(of: .value) { (snapshot) in
            guard let hastaneGerçek = snapshot.value as? String else { return }
                print(hastaneGerçek)
        ref=Database.database().reference().child("Ihtiyaclar").child(hastaneGerçek).child(self.showedItem)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                self.artistsList.removeAll()
                
                for artists in snapshot.children.allObjects as![DataSnapshot]{
                    let artistObject = artists.value as? [String:AnyObject]
                    let artistName=artistObject?["isteyen"]
                    let onay=artistObject?["onay"]
                    let onem=artistObject?["onem"]
                    let tane=artistObject?["tane"]
                    let tip=artistObject?["tip"]
                    
                    let artist=ArtistModel(isteyen: artistName as! String?, onay:onay as! Bool?, onem: onem as! String?, tane: tane as! String?, tip: tip as! String?)
                    
                     self.artistsList.append(artist)
                    
                }
                self.tblArtists.reloadData()
            }
        })
            }
            } })
    }

    func refreshTable(Item:String) {
        var ref = Database.database().reference()
        let UID=Auth.auth().currentUser?.uid
        ref.child("Kullanicilar").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(String(UID!)){
            Database.database().reference().child("Kullanicilar").child(UID!).child("hastane").observeSingleEvent(of: .value) { (snapshot) in
            guard let hastaneGerçek = snapshot.value as? String else { return }
                print(hastaneGerçek)
        
        
        ref=Database.database().reference().child("Ihtiyaclar").child(hastaneGerçek).child(self.showedItem)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                self.artistsList.removeAll()
                
                for artists in snapshot.children.allObjects as![DataSnapshot]{
                    let artistObject = artists.value as? [String:AnyObject]
                    let artistName=artistObject?["isteyen"]
                    let onay=artistObject?["onay"]
                    let onem=artistObject?["onem"]
                    let tane=artistObject?["tane"]
                    let tip=artistObject?["tip"]
                    
                    let artist=ArtistModel(isteyen: artistName as! String?, onay:onay as! Bool?, onem: onem as! String?, tane: tane as! String?, tip: tip as! String?)
                    
                     self.artistsList.append(artist)
                    
                }
                self.tblArtists.reloadData()
            }
        })
    }
            }
        })}
    var showedItem = " " as String
    @IBAction func maskeButtonPressed(_ sender: UIButton) {
        self.showedItem="Maske"
        refreshTable(Item:showedItem)
        print(showedItem)
    }
    
    
    @IBAction func dezenfektanButtonPressed(_ sender: UIButton) {
        self.showedItem="Dezenfektan"
        refreshTable(Item:showedItem)
        print(showedItem)
    }
    
    
    @IBAction func eldivenButtonPressed(_ sender: UIButton) {
        self.showedItem="Eldiven"
        refreshTable(Item:showedItem)
        print(showedItem)
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
