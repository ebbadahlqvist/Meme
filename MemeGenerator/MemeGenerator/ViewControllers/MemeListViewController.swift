//
//  MemeListViewController.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit
import Imaginary

class MemeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchView: SearchNavBarBottomView!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingView: UIView!
    
    var memes: [Meme] = []
    var searchResultMemes: [Meme] = []
    
    var selectedMeme: Meme = Meme()
    
    var selectedImage: UIImage = UIImage()
    
    let segueID: String = "detailSegue"
    
    let cellHeight: CGFloat = 80.0
    
    var selectedCellRow = -1
    
    //MARK: - View controller specifics
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadingView.isHidden = false
        indicator.startAnimating()
        tableView.tableFooterView = UIView()
        searchView.delegate = self
        DispatchQueue.global(qos: .userInteractive).async {
            ApiHandler.getInstance().getMemesFlow() { (success, errorMessage) in
                DispatchQueue.main.async {
                    if success {
                        self.memes = DataHandler.getInstance().getMemes()
                        self.searchResultMemes = self.memes
                    } else {
                        self.showAlert("Error occurred.", errorMessage)
                    }
                    self.loadingView.isHidden = true
                    self.indicator.stopAnimating()
                    self.tableView.animateTableReload()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = navigationController {
            navController.navigationBar.shadowImage = UIImage()
        }
        
        searchView.addBottomShadow()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchResultMemes.count > selectedCellRow {
            if selectedCellRow != -1 && StorageHandler.getInstance().storageDidChange {
                tableView.reloadRows(at: [IndexPath(row: selectedCellRow, section: 0)], with: .top)
                StorageHandler.getInstance().storageDidChange = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.deselectSelectedRowAnimated(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MemeDetailViewController {
            destination.meme = selectedMeme
        }
    }
    
    //MARK: - Actions
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView delegates
extension MemeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = searchResultMemes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: SmallMemeTableViewCell().ID, for: indexPath) as? SmallMemeTableViewCell {
            
            cell.memeImageView.image = UIImage()
            cell.memeNameLabel.text = meme.name
            cell.memeTextLabel.text = StorageHandler.getInstance().getTextForMeme(id: meme.id)
            
            if let url = URL(string: meme.url) {
                cell.memeImageView.setImage(url: url)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellRow = indexPath.row
        selectedMeme = searchResultMemes[indexPath.row]
        performSegue(withIdentifier: segueID, sender: self)
    }
}

//Mark: - SearchView delegates
extension MemeListViewController: SearchNavBarBottomViewDelegate {
    func onTextChange(text: String, shouldSearch: Bool) {
        
        if text == "" {
            searchResultMemes = memes
        } else {
            searchResultMemes = memes.filter {$0.name.lowercased().contains(text.lowercased())}
        }
        
        tableView.reloadData()
    }
}
