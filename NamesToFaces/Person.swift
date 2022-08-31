//
//  Person.swift
//  NamesToFaces
//
//  Created by newbie on 31.08.2022.
//

import UIKit

class Person: NSObject {
    var name: String
    let image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
