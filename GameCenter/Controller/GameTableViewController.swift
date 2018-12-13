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
    
    var gameArray: [Game] = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width / 2.8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GameTableViewCell

        // Configure the cell...

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    //MARK: - API Methods
    
    func getDataFromWeb() {
        
        let query = PFQuery(className:"Game")
        
        query.findObjectsInBackground(block: {
            
            (games, error) in
            
            if error == nil {
                if let gamess = games {
                    for game in gamess {
                        //Save each game to Core Data
                    }
                }
            }
            else {
                print("Error: \(error)")
            }
        })
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveGames() {
        
        do {
            try self.context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadGames(with request: NSFetchRequest<Game> = Game.fetchRequest()) {
        
        do {
            self.gameArray = try self.context.fetch(request)
        }
        catch {
            print("Error fetching data from context, \(error)")
        }
        
        self.tableView.reloadData()
    }


}
