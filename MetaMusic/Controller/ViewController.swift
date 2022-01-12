//
//  ViewController.swift
//  MetaMusic
//
//  Created by Vladislav Mazurov on 27.04.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    
    var musicManager = MusicManager()
    var musicModel: AlbumModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicManager.delegate = self
        searchField.delegate = self
    }

    @IBAction func savedMusicPressed(_ sender: UIButton) {
        searchField.text = ""
        
        self.performSegue(withIdentifier: "goToSaved", sender: self)
    }
   
}

extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type smth here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = searchField.text {
            musicManager.fetchMusic(bandName: name)
        }
        searchField.text = ""
    }
}

extension ViewController: MusicManagerDelegate {
    func didUpdateMusic(_ musicManager: MusicManager, music: AlbumModel) {
        DispatchQueue.main.async {
            self.musicModel = music
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.sync {
            let alert = UIAlertController(title: "Error", message: "Nothing with this search found. Please try other name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! MusicDataViewController
            destinationVC.musicModel = musicModel
        }
    }
}
