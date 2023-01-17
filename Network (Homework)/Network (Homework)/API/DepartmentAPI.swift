//
//  DepartmentAPI.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 21.11.22.
//

import Foundation
import Moya


enum DepartmentApi {
    case allDepartments
}

extension DepartmentApi: TargetType {
    var baseURL: URL {
        switch self {
        case .allDepartments:
            return URL(string: "https://belarusbank.by/api/")!
        }
    }
    
    var path: String {
        switch self {
        case .allDepartments:
            return "filials_info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .allDepartments:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .allDepartments:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}


