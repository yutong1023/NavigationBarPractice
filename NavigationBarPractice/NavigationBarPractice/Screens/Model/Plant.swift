//
//  Plant.swift
//  NavigationBarPractice
//
//  Created by yutong on 2021/11/9.
//

import Foundation

typealias Plants = [Plant]

struct PlantsData:Codable {
    let result:PlantsResult
}

struct PlantsResult:Codable {
    let limit:Int
    let offset:Int
    let count:Int
    let sort:String
    let results:[Plant]
}

struct Plant:Codable {
    let _id:Int
    let F_Name_Latin:String
    let F_pdf02_ALT:String
    let F_pdf01_ALT:String
    let F_pdf02_URL:String
    let F_Pic02_URL:String
    let F_Keywords:String
    let F_Code:String
    let F_Geo:String
    let F_Pic03_URL:String
    let F_Voice01_ALT:String
    let F_AlsoKnown:String
    let F_Voice02_ALT:String
    let F_Pic04_ALT:String
    let F_Name_En:String
    let F_Brief:String
    let F_Pic04_URL:String
    let F_Voice01_URL:String
    let F_Pic02_ALT:String
    let F_Family:String
    let F_Voice03_ALT:String
    let F_Voice02_URL:String
    let F_Pic03_ALT:String
    let F_Pic01_ALT:String
    let F_CID:String
    let F_pdf01_URL:String
    let F_Vedio_URL:String
    let F_Genus:String
    let F_Function＆Application:String
    let F_Voice03_URL:String
    let F_Update:String
    
    let F_Name_Ch:String
    let F_Location:String
    let F_Feature:String
    let F_Pic01_URL:String
}
