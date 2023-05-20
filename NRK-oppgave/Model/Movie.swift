//
//  File.swift
//  NRK-oppgave
//
//  Created by VP on 19/05/2023.
//

import Foundation

struct Movie:Codable{
    var headliners:[Item]
}

struct Item:Codable{
    var title:String
    var subTitle: String
    var type:String
    var images:[Image]
    var _links:Links
}

struct Links:Codable{
    var playback:Link?
}

struct Link:Codable{
    var href:String
}


struct Image:Codable{
    var uri:String
}




