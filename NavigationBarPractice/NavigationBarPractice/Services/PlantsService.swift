//
//  PlantsService.swift
//  NavigationBarPractice
//
//  Created by yutong on 2021/11/9.
//

import Foundation

protocol PlantsServiceProtocol {
    func getPlants(completion: @escaping (_ success: Bool, _ results: PlantsData?, _ error: String?) -> ())
}

class PlantsService: PlantsServiceProtocol {
    let limit = 20
    var offset = 0
    func getPlants(completion: @escaping (Bool, PlantsData?, String?) -> ()) {
        HttpRequestHelper().GET(url: "https://data.taipei/opendata/datalist/apiAccess"
                                , params: [
                                    "scope": "resourceAquire"
                                    , "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14"
                                    , "limit": "\(limit)"
                                    , "offset": "\(offset)"
                                ]
                                , httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(PlantsData.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse PlantsData to model")
                }
            } else {
                completion(false, nil, "Error: PlantsData GET Request failed")
            }
        }
    }
}
