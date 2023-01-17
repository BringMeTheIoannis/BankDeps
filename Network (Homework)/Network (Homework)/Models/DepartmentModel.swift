//
//  DepartmentModel.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 21.11.22.
//

import Foundation
import ObjectMapper


class DepartmentModel: Mappable {
    
    
    var department: String = ""
    var city: String = ""
    
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        department <- map["filial_name"]
        city       <- map["name"]
    }
}
