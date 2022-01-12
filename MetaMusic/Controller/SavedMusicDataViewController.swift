//
//  SavedMusicDataViewController.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 02.05.21.
//

import UIKit

class SavedMusicDataViewController: UIViewController {
    
    var savedMusic = SavedMusicData.shared
    var indexPathRow: Int?
    var musicManager = MusicManager()
    var musicModel: AlbumModel?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Albums"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "ReusableAlbumCell")
        tableView.reloadData()
    }
    
}

extension SavedMusicDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMusic.musicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableAlbumCell", for: indexPath) as! AlbumCell
        let album = savedMusic.musicData[indexPath.row]
        
        cell.bandNameLabel.text = album.albumArtist
        cell.savedButton.isHidden = true
        
        if album.albumDescr == "null" {
            cell.biographyLabel.text = ""
        } else {
            cell.biographyLabel.text = album.albumDescr
        }
        
        if album.albumGenre == "null" {
            cell.genreLabel.text = ""
        } else {
            cell.genreLabel.text = album.albumGenre
        }
        
        if album.albumYear == "0" {
            cell.yearLabel.text = ""
        } else {
            cell.yearLabel.text = album.albumYear
        }
        
        cell.titleLabel.text = album.albumName
        setImage(imageView: cell.coverImage, from: album.albumURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedMusic.musicData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
