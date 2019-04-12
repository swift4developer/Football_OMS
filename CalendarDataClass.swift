//
//  CalendarDataClass.swift
//  FootBallApp
//
//  Created by Praveen Khare on 02/05/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import Foundation

class CalendarDataClass {

    var event_id = String()
    var match_id = String()
    var team_id = String()
    var minuts_value = String()
    var extra_min = String()
    var type_value = String()
    var player_id = String()
    var player_name = String()
    var team_name = String()
    
    init(event_id:String,match_id :String,team_id: String, minuts_value: String, extra_min:String, type_value : String, player_id:String, player_name : String, team_name:String) {
        self.event_id = event_id
        self.team_name = team_name
        self.match_id = match_id
        self.team_id = team_id
        self.minuts_value = minuts_value
        self.extra_min = extra_min
        self.type_value = type_value
        self.player_id = player_id
        self.player_name = player_name
    }
}
