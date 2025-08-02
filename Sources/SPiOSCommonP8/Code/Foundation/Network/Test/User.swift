//
//  User.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 29/07/25.
//


class User: Decodable, Identifiable,@unchecked Sendable {
    let id: Int
    var name: String
    let email: String
}
