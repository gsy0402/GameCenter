//
//  CommentTableViewController.swift
//  GameCenter
//
//  Created by Siyuan Guo on 12/12/18.
//  Copyright © 2018 Siyuan Guo. All rights reserved.
//

import UIKit
import CoreData
import Parse

class CommentTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var game: Game!
    var commentArray: [Comment] = [Comment]()

    //Properties
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Comments ViewController loaded.")
        
        if let url = URL(string: self.game.imageURL!), let data = try? Data(contentsOf: url)
        {
            self.gameImageView.image = UIImage(data: data)
        }
        else {
            self.gameImageView.image = UIImage(named: "unavailableImage")
        }
        
        self.naviItem.title = self.game.name!
        
        print("Loading comments from context.")
        self.loadCommentsFromContext()
        print("Loaded comments from context.")
        
        if self.commentArray.count == 0 {
            print("0 comments in commentArray")
            self.saveDataFromWebToArrayAndContext()
        }
        else {
//            self.deleteAllCommentsFromContext()
//            self.saveContext()
            print("Updating UI...")
            self.tableView.reloadData()
            print("UI Updated.")
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        print("Added refreshControlAlt to tableView")

    }

    //MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width / 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.commentsLabel.text = "\(self.commentArray[indexPath.row].parentGame?.gameId): " + self.commentArray[indexPath.row].comment!
        cell.userNameLabel.text = self.commentArray[indexPath.row].userName!
        
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.width / 2
        cell.avatarImageView.clipsToBounds = true
        
        if let url = URL(string: self.commentArray[indexPath.row].avatarURL!), let data = try? Data(contentsOf: url)
        {
            cell.avatarImageView.image = UIImage(data: data)
        }
        else {
            cell.avatarImageView.image = UIImage(named: "unavailableImage")
        }

        return cell
    }
    
    //MARK: - API Methods
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        self.deleteAllCommentsFromContext()
//        self.saveContext()
//        print("Erased current data store.")
//
//        print("Fetching Comment data from web...")
//        self.saveDataFromWebToArrayAndContext()
//        print("Fetched Comment data from web.")
        
        print("Updating UI...")
        self.tableView.reloadData()
        print("UI Updated.")
        
        refreshControl.endRefreshing()
    }
    
    func saveDataFromWebToArrayAndContext() {
        
        let predicate = NSPredicate(format: "gameId = \(self.game.gameId)")
        let query = PFQuery(className:"Comments", predicate: predicate)
        query.order(byAscending: "gameId")
        
        
        query.findObjectsInBackground(block: {
            
            (comments, error) in
            
            if error == nil {
                
                if let commentss = comments {
                    
                    //Append games to array
                    
                    for comment in commentss {
                        
                        let newComment = Comment(context: self.context)
                        newComment.userName = comment["name"] as? String
                        newComment.avatarURL = comment["avatar"] as! String
                        newComment.comment = comment["comment"] as? String
                        newComment.parentGame = self.game
                        
                        self.commentArray.append(newComment)
                        print("Appended newComment for gameId: \(self.game.gameId) to commentArray")
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
    
    func deleteAllCommentsFromContext() {
        for comment in self.commentArray {
            print("Deleting comment for gameId \(self.game.gameId)")
            self.context.delete(comment)
        }
        print("All comments deleted from context for gameId \(self.game.gameId).")
        self.commentArray.removeAll()
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
    
    func loadCommentsFromContext(withRequest request: NSFetchRequest<Comment> = Comment.fetchRequest()) {
        
        print("Loading games with gameId \(self.game.gameId)")
        let gamePredicate = NSPredicate(format: "parentGame.name MATCHES %@", self.game.name!)
        request.predicate = gamePredicate
        
        do {
            print("Loading Comment data from Core Data Model...")
            self.commentArray = try self.context.fetch(request)
            print("Loaded data on to commentArray.")
        }
        catch {
            print("Error fetching data from context, \(error)")
        }
        
    }

}
