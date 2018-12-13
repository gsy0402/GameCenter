//
//  GameTableViewController.swift
//  GameCenter
//
//  Created by Siyuan Guo on 12/12/18.
//  Copyright © 2018 Siyuan Guo. All rights reserved.
//

import UIKit
import CoreData
import Parse

class GameTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    lazy var refreshControlAlt: UIRefreshControl = {
//
//        print("Created refreshControlAlt")
//
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(GameTableViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
//        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Game Data ...")
//
//        return refreshControl
//    }()

    var gameArray: [Game] = [Game]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("View Did Load")
        
        self.loadGamesFromContext()
        
        if self.gameArray.count == 0 {
            print("Currently there are \(self.gameArray.count) games.\nGetting games from the web...")
            self.saveDataFromWebToArrayAndContext()
        }
        else {
            print("First game is \(self.gameArray[0].name!)")
//            self.deleteAllGamesFromContext()
//            self.saveContext()
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        print("Added refreshControlAlt to tableView")
        
        print("Updating UI...")
        self.tableView.reloadData()
        print("UI Updated.")

    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width / 2.8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as! GameTableViewCell
        
        if self.gameArray.count > indexPath.row {
            
            cell.gameNameLabel.text = self.gameArray[indexPath.row].name ?? ""
            cell.gamePriceLabel.text = "$ " + String(format: "%.2f", self.gameArray[indexPath.row].price / 100)
            
            if let url = URL(string: self.gameArray[indexPath.row].imageURL!), let data = try? Data(contentsOf: url)
            {
                cell.gameImageView.image = UIImage(data: data)
            }
            else {
                cell.gameImageView.image = UIImage(named: "unavailableImage")
            }
        }
        else {
            print("Not enough data in gameArray to load onto the cells.")
        }
        
        return cell
    }

    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goToComments", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CommentTableViewController
        destinationVC.game = self.gameArray[self.tableView.indexPathForSelectedRow!.row]
    }

    //MARK: - API Methods
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        self.deleteAllGamesFromContext()
//        print("Erased current data store.")
//
//        print("Fetching Game data from web...")
//        self.saveDataFromWebToArrayAndContext()
//        print("Fetched Game data from web."
        
        print("Updating UI...")
        self.tableView.reloadData()
        print("UI Updated.")

        refreshControl.endRefreshing()
    }
    
    func saveDataFromWebToArrayAndContext() {
        
        let query = PFQuery(className:"Game")
        query.order(byAscending: "gameId")
        
        query.findObjectsInBackground(block: {
            
            (games, error) in
            
            if error == nil {
                
                if let gamess = games {
                    
                    //Append games to array
                    
                    for game in gamess {
                    
                        let newGame = Game(context: self.context)
                        newGame.name = game["name"] as? String
                        newGame.gameId = game["gameId"] as! Int16
                        newGame.imageURL = game["image"] as? String
                        newGame.price = game["price"] as! Double
                        
                        self.gameArray.append(newGame)
                        print("Appended newGame: \(newGame.name!) to gameArray")
                    }
                    
                    //Save gameArray to context
                    self.saveContext()
                }
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func deleteAllGamesFromContext() {
        for game in self.gameArray {
            print("Deleting game \(game.name!)")
            self.context.delete(game)
        }
        print("All games deleted from context.")
        self.gameArray.removeAll()
    }
    
    func saveContext() {
        
        do {
            print("Saving data to context...")
            try self.context.save()
            print("Saved data to context.")
        }
        catch {
            print("Error saving context, \(error)")
        }
        
    }
    
    func loadGamesFromContext(with request: NSFetchRequest<Game> = Game.fetchRequest()) {
        
        print("Loading Game data from Core Data Model...")
        request.sortDescriptors = [NSSortDescriptor(key: "gameId", ascending: true)]

        do {
            self.gameArray = try self.context.fetch(request)
            print("Loaded data on to gameArray.")
        }
        catch {
            print("Error fetching data from context, \(error)")
        }
        
    }


}
