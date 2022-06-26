//
//  PostListTableViewController.swift
//  Master-Reddit
//
//  Created by Cameron Stuart on 4/28/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {

    var safeArea: UILayoutGuide {
            return self.view.safeAreaLayoutGuide
    }
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(redditTableView)
        constrainTableView()
        configureTableView()
        PostController.fetchPosts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.redditTableView.reloadData()
                case .failure(let error):
                    print("-----------------BOOO ERROR-----------------")
                    print(error)
                }
            }
        }
    }
    
    func configureTableView() {
        redditTableView.dataSource = self
        redditTableView.delegate = self
        redditTableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        redditTableView.allowsSelection = false
    }
    
    func constrainTableView() {
        NSLayoutConstraint.activate([
            redditTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            redditTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            redditTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            redditTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])  
    }
    
    let redditTableView: UITableView = {
            let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
    }()
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "postCell")
        let post = self.posts[indexPath.row]
        
        PostController.fetchThumbnail(post: post) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let thumbnail):
                    cell.imageView?.image = thumbnail
                    cell.textLabel?.text = post.title
                    cell.detailTextLabel?.text = "Ups: \(post.ups)"
                case .failure(let error):
                    print(error.errorDescription)
                    cell.imageView?.image = UIImage(named: "imageNotAvailable")
                    cell.textLabel?.text = post.title
                    cell.detailTextLabel?.text = "Ups: \(post.ups)"
                }
            }
        }

        return cell
    }
}
