//
//  AlbumCell.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 03.05.21.
//

import UIKit

protocol AlbumCellDelegate: AnyObject {
    func didPressButton(_ tag: Int)
}

class AlbumCell: UITableViewCell {

    var cellDelegate: AlbumCellDelegate?
    var checkButton = true
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var biographyLabel: UITextView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var bandNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func saveAlbumPressed(_ sender: UIButton) {
        
        cellDelegate?.didPressButton(sender.tag)
        
        if checkButton {
            
            savedButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            checkButton = false
        } else {
            savedButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            checkButton = true
        }
    }
}
