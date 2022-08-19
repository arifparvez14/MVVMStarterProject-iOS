//
//  MovieInfo.swift
//  Movie List
//

import Foundation
import UIKit

struct MovieInfo: Decodable {
    let results: [MovieResult]
}

struct MovieResult: Decodable {
    let posterPath: String?
    var posterUrl: URL?
    let title: String?
    let overview: String?
    var cellHeight: CGFloat?

    enum CodingKeys: String, CodingKey {
        case posterUrl, title, overview, cellHeight
        case posterPath = "poster_path"
    }
}
