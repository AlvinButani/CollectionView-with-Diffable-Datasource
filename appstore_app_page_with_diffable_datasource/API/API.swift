//
//  API.swift
//  appstore_app_page_with_diffable_datasource
//
//  Created by sunny on 01/01/24.
//

import Alamofire

class API{
    
    static let shared = API()
    
    private init(){}
    
    func getApplicationList() async throws -> [Application] {
    
        let dataTask = AF.request("https://rss.applemarketingtools.com/api/v2/in/apps/top-free/20/apps.json")
            .validate()
            .serializingDecodable(Feed.self)
        
        let response = await dataTask.response
        
        switch response.result{
        case let .success(feed):
            return feed.feed.results
            
        case let .failure(error):
            throw error
        }
    }
}
