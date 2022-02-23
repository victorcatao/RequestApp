//
//  RequestPath.swift
//  RequestApp
//
//  Created by Victor Catão on 30/01/22.
//

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
}
