//
//  BakanlikVC.swift
//  Hizir
//
//  Created by Yalcin TUR on 13.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit
import Firebase

class BakanlikVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var hastaneSearchBar: UITextField!
    @IBOutlet weak var tblArtist: UITableView!
    var searching = false
    var artistsList = [ArtistModel]()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hastaneSearchBar.delegate = self

        tblArtist.delegate = self
        tblArtist.dataSource = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var showedItem = " " as String

    
    
    @IBAction func maskePressed(_ sender: UIButton) {
        self.showedItem="Maske"
        refreshTable(Item:showedItem)
        print(showedItem)
    }
    @IBAction func dezenfektanPressed(_ sender: UIButton) {
        self.showedItem="Dezenfektan"
        refreshTable(Item:showedItem)
        print(showedItem)
    }
    @IBAction func eldivenPressed(_ sender: UIButton) {
        self.showedItem="Eldiven"
            refreshTable(Item:showedItem)
            print(showedItem)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return CGFloat(100)
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
                self.tblArtist.reloadData()
            }
        })
    }
            }
        })} 
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let artist: ArtistModel
        artist = artistsList[indexPath.row]
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
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

    
}

extension BakanlikVC: UITextFieldDelegate {
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        hastaneSearchBar.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hastaneSearchBar.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = hastaneSearchBar.text {
            var ref = Database.database().reference()
           
                            ref=Database.database().reference().child("Ihtiyaclar").child(city).child(self.showedItem)
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
                                    self.tblArtist.reloadData()
                                }
                            })
                              
           print(city)
        }
        
        hastaneSearchBar.text = ""
        
    }
}
