//
//  DepartmentProvider.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 23.11.22.
//

import Foundation
import Moya
import Moya_ObjectMapper


final class DepartmentProvider {
    private let provider = MoyaProvider<DepartmentApi>(plugins: [NetworkLoggerPlugin()])
    
    func getDepartments(success: (([DepartmentModel]) -> Void)?, failure: (() -> Void)? = nil) {
        provider.request(.allDepartments) { result in
            switch result {
            case .success(let response):
                guard let departments = try? response.mapArray(DepartmentModel.self) else { failure?()
                    return  }
                success?(departments)
            case .failure(_):
                failure?()
            }
        }
    }
}
