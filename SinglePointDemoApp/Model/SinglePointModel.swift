//
//  SinglePointModel.swift
//  SinglePointDemoApp
//
//  Created by GOUTHAM on 25/11/24.
//

import Foundation

struct SinglePointModel : Codable {
    let id : String?
    let name : String?
    let type : String?
    let shortDescription : String?
    let longDescription : String?
    let preparationMinutes : Int?
    let imageName : String?
    let ingredients : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case type = "type"
        case shortDescription = "shortDescription"
        case longDescription = "longDescription"
        case preparationMinutes = "preparationMinutes"
        case imageName = "imageName"
        case ingredients = "ingredients"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        longDescription = try values.decodeIfPresent(String.self, forKey: .longDescription)
        preparationMinutes = try values.decodeIfPresent(Int.self, forKey: .preparationMinutes)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        ingredients = try values.decodeIfPresent([String].self, forKey: .ingredients)
    }

}
