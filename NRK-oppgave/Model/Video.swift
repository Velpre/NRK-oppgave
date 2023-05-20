//
//  Video.swift
//  NRK-oppgave
//
//  Created by VP on 20/05/2023.
//

import Foundation

struct Video:Codable{
    var playable: Assets
}

struct Assets:Codable{
    var assets: [Asset]
}

struct Asset:Codable{
    var url: String
    var format: String
}


