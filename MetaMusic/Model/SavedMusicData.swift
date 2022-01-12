//
//  SavedMusicData.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 02.05.21.
//

import Foundation

class SavedMusicData: NSObject {
    static let shared: SavedMusicData = SavedMusicData()
    var musicData: [AlbumsData] = []
}
