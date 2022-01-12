//
//  MusicDataViewController.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 01.05.21.
//

import UIKit

class MusicDataViewController: UIViewController {
    
    var musicModel: AlbumModel?
    var savedMusic = SavedMusicData.shared
    var test: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bandNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        tableView.dataSource = self
        bandNameLabel.text = musicModel?.albums[0].albumArtist
        
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "ReusableAlbumCell")
        tableView.reloadData()
    }
}

extension MusicDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (musicModel?.albums.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableAlbumCell", for: indexPath) as! AlbumCell
        let album = musicModel?.albums[indexPath.row]
        
        cell.savedButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        
        for music in savedMusic.musicData {
            if album!.idAlbum == music.idAlbum {
                cell.savedButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.checkButton = false
            }
        }
        
        cell.cellDelegate = self
        cell.bandNameLabel.isHidden = true
        cell.savedButton.tag = indexPath.row
        
        if album?.albumDescr == "null" {
            cell.biographyLabel.text = ""
        } else {
            cell.biographyLabel.text = album?.albumDescr
        }
        
        if album?.albumGenre == "null" {
            cell.genreLabel.text = ""
        } else {
            cell.genreLabel.text = album?.albumGenre
        }
        
        if album?.albumYear == "0" {
            cell.yearLabel.text = ""
        } else {
            cell.yearLabel.text = album?.albumYear
        }
        
        cell.titleLabel.text = album?.albumName
        setImage(imageView: cell.coverImage, from: album!.albumURL)
        
        return cell
    }
    
    func setImage(imageView: UIImageView, from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }
    
}

extension MusicDataViewController: AlbumCellDelegate {
    func didPressButton(_ tag: Int) {
        if let music = musicModel?.albums[tag] {
            if savedMusic.musicData.isEmpty {
                savedMusic.musicData.append(music)
                return
            }
            
            for album in savedMusic.musicData {
                if album.idAlbum != music.idAlbum {
                    savedMusic.musicData.append(music)
                    return
                } else {
                    savedMusic.musicData.removeAll(where: {$0.idAlbum == music.idAlbum})
                    return
                }
            }
        }
    }
}

