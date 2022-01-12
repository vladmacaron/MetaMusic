//
//  AlbumData.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 03.05.21.
//

import Foundation

struct AlbumData: Codable {
    let album: [MusicAlbums]
}

struct MusicAlbums: Codable {
    let idAlbum: String
    let strArtist: String
    let strAlbum: String
    let strGenre: String?
    let strAlbumThumb: String?
    let strDescriptionEN: String?
    let intYearReleased: String
}


