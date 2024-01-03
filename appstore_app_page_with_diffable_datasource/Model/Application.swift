//
//  Application.swift
//  appstore_app_page_with_diffable_datasource
//
//  Created by sunny on 01/01/24.
//

import Foundation

struct Application:Codable, Hashable{
    
    var artistName:String
    var id:String
    var name:String
    var releaseDate:String
    var kind:String
    var artworkUrl100:String
    var url:String
    
    var artworkURL:URL?{
        return URL(string: self.artworkUrl100)
    }
}

struct Feed:Codable{
    var feed:Feeds
}

struct Feeds:Codable{
    var results: [Application]
    
}
