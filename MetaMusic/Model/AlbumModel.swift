//
//  AlbumModel.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 03.05.21.
//

import Foundation

struct AlbumModel {
    let albums: [AlbumsData]
}

struct AlbumsData {
    let idAlbum: String
    let albumName: String
    let albumArtist: String
    let albumGenre: String
    let albumURL: String
    let albumDescr: String
    let albumYear: String
}
