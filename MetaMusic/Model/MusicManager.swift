//
//  MusicManager.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 27.04.21.
//

import Foundation

protocol MusicManagerDelegate {
    func didUpdateMusic(_ musicManager: MusicManager, music: AlbumModel)
    func didFailWithError(error: Error)
}

struct MusicManager {
    let musicURL = "https://www.theaudiodb.com/api/v1/json/1/"
    
    var delegate: MusicManagerDelegate?
    
    func fetchMusic(bandName: String) {
        let changedName = bandName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(musicURL)search.php?s=\(changedName)"
        performRequestForID(with: urlString)
    }
    
    func fetchAlbums(bandId: String) {
        let urlString = "\(musicURL)album.php?i=\(bandId)"
        performRequest(with: urlString)
    }
    
    func performRequestForID(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let music = self.parseJSONMusic(musicData: safeData) {
                        self.fetchAlbums(bandId: music.id)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let music = self.parseJSONAlbums(musicData: safeData) {
                        self.delegate?.didUpdateMusic(self, music: music)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSONMusic(musicData: Data) -> BandModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BandData.self, from: musicData)
            let id = decodedData.artists[0].idArtist
            let name = decodedData.artists[0].strArtist
            
            let music = BandModel(id: id, name: name)
            return music
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONAlbums(musicData: Data) -> AlbumModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(AlbumData.self, from: musicData)
            var albumData: [AlbumsData] = []
            let coverURL = "https://media.istockphoto.com/vectors/vintage-vinyl-records-out-of-the-box-template-empty-gramophone-cover-vector-id1041993546?k=6&m=1041993546&s=612x612&w=0&h=_THqKVi1cLzwvb_ip-DGwd5Vbe6DKnfEmtQ2lLzkBhI="
            for album in decodedData.album {
                albumData.append(AlbumsData(idAlbum: album.idAlbum, albumName: album.strAlbum, albumArtist: album.strArtist, albumGenre: album.strGenre ?? "null", albumURL: album.strAlbumThumb ?? coverURL, albumDescr: album.strDescriptionEN ?? "null", albumYear: album.intYearReleased))
            }
            
            let music = AlbumModel(albums: albumData)
            return music
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
