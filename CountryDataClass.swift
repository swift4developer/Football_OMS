//
//  CountryDataClass.swift
//  FootBallApp
//
//  Created by Praveen Khare on 27/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import Foundation

class CountryDataClass {
    
    var c_name: String = ""
    var c_id: String = ""
    var flag_url: String = ""
    var iso_code: String = ""
    
    init(c_name: String,c_id: String,flag_url: String,iso_code: String){
        
        self.c_id = c_id
        self.c_name = c_name
        self.flag_url = flag_url
        self.iso_code = iso_code
    }
}
