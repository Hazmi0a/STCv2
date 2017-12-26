//
//  Article.swift
//  STCv2
//
//  Created by Abdullah Alhazmi on 25/12/2017.
//  Copyright © 2017 Abdullah Alhazmi. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Article: Object {
    
    @objc dynamic var title: String!
    @objc dynamic var content: String!
    @objc dynamic var image: String!
    
//    for use in future...

//    var website: String!
//    var authors: String!
//    var date: String!
//    var tags: Dictionary<String, AnyObject>!
//
    
    required init() {
        self.title = ""
        self.content = ""
        self.image = ""
        
//    for use in future...
        
//        self.website = ""
//        self.authors = ""
//        self.date = ""
//        self.tags = ["": "" as AnyObject]
        
        super.init()
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(articleDict: Dictionary<String, AnyObject>) {

        if let title = articleDict["title"] as? String {
            self.title = title
        }

        if let content = articleDict["content"] as? String {
            self.content = content
        }

        if let image = articleDict["image_url"] as? String {
            self.image = image
        }
  
//      for use in future...
        
//        if let website = articleDict["website"] as? String {
//            self.website = website
//        }
//
//        if let authors = articleDict["authors"] as? String {
//            self.authors = authors
//        }
//
//        if let date = articleDict["date"] as? String {
//            self.date = date
//        }
//
//        if let tags = articleDict["tags"] as? Dictionary<String, AnyObject> {
//            self.tags = tags
//        }
        
        super.init()

    }
    
    
    
    
    
  
    
}
