import CloudKit
import UIKit

class MyGenresTableViewController: UITableViewController {

    var myGenres: [String]!
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedGenres = defaults.object(forKey: "myGenres") as? [String] {
            myGenres = savedGenres
        } else {
            myGenres = [String]()
        }
    
    title = "Nortify me about..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc func saveTapped(){
        let defaults = UserDefaults.standard
        defaults.set(myGenres, forKey: "myGenres")
        
        let dataBase = CKContainer.init(identifier: "iCloud.CloudKitMusic").publicCloudDatabase
        
        dataBase.fetchAllSubscriptions { [unowned self] (subscriptions, error) in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        dataBase.delete(withSubscriptionID: subscription.subscriptionID) { (str, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                    for genre in self.myGenres {
                        let predicate = NSPredicate(format: "genre = %@", genre)
                        let subscription = CKQuerySubscription(recordType: "Whistles", predicate: predicate, options: .firesOnRecordCreation)
                        
                        let notification = CKSubscription.NotificationInfo()
                        notification.alertBody = "There's a new whistle in the \(genre) genre."
                        notification.soundName = "default"
                        
                        subscription.notificationInfo = notification
                        
                        dataBase.save(subscription) { (result, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreTableViewController.genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let genre = SelectGenreTableViewController.genres[indexPath.row]
        cell.textLabel?.text = genre
        
        if myGenres.contains(genre){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectGenre = SelectGenreTableViewController.genres[indexPath.row]
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                myGenres.append(selectGenre)
            } else {
                cell.accessoryType = .none
                
                if let index = myGenres.firstIndex(of: selectGenre){
                    myGenres.remove(at: index)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
