//
//  SelectGenreViewController.swift
//  CloudKitMusic
//
//  Created by Leandro de Sousa Silva on 10/10/19.
//  Copyright © 2019 AcademyMistic. All rights reserved.
//

import UIKit

class SelectGenreViewController: UITableViewController {

    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul", "Rapper"]
    
    private let cellID = "cellID"
    
    fileprivate func setupTableView() {
        title = "Select Genre"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreViewController.genres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID , for: indexPath)
        
        cell.textLabel?.text = SelectGenreViewController.genres[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //verifica quando for selecionado a cell se tem algum valor, se tiver vazio manda o valor desconhecido unknown
        if let cell = tableView.cellForRow(at: indexPath){
            let genre = cell.textLabel?.text ?? SelectGenreViewController.genres[0]
            let addComentsController = AddComentsViewController()
            
            addComentsController.genre = genre
            navigationController?.pushViewController(addComentsController, animated: true)
        }
    }
    
    
}
