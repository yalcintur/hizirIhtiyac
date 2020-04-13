//
//  ArtistModel.swift
//  Hizir
//
//  Created by Hüseyin Yağız Devre on 12.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

class ArtistModel{
    var isteyen:String?
    var onay:Bool?
    var onem:String?
    var tane:String?
    var tip:String?
    init(isteyen:String?, onay:Bool?, onem:String?, tane:String?, tip:String?) {
        self.isteyen=isteyen;
        self.onay=onay;
        self.onem=onem;
        self.tane=tane;
        self.tip=tip;
    }
}
