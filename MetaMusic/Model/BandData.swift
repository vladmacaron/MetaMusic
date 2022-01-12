//
//  MusicData.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 27.04.21.
//

import Foundation

struct BandData: Codable {
    let artists: [Artists]
}


struct Artists: Codable {
    let idArtist: String
    let strArtist: String
}

