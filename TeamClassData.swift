//
//  TeamClassData.swift
//  FootBallApp
//
//  Created by Praveen Khare on 27/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import Foundation

class TeamClassData {
    
    var team_id: String = ""
    var team_name: String = ""
    var session_id: String = ""
    var logo: String = ""
    var twitter_data: String = ""
    var venue: String = ""
    var coach_id: String = ""
    var chairman_id: String = ""
    
    init(team_id: String,team_name: String,session_id: String,logo: String,twitter_data: String,venue: String,coach_id: String,chairman_id: String){
        
        self.team_id = team_id
        self.team_name = team_name
        self.session_id = session_id
        self.logo = logo
        self.twitter_data = twitter_data
        self.venue = venue
        self.coach_id = coach_id
        self.chairman_id = chairman_id
    }
}
