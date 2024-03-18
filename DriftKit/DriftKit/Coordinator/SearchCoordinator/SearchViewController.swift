//
//  SearchViewController.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit
import FirebaseAuth

class SearchViewController: UIViewController {
    
    var viewModel : SearchViewModel?
    
    private lazy var searchController :  UISearchController = {
        let search = UISearchController()
        
        return search
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private func setTableView(){
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.frame      = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                  = .white
        navigationItem.searchController       = searchController
        setTableView()
        searchController.delegate             = self
        searchController.searchResultsUpdater = self
        Task{
            await viewModel?.fetchAllUsers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      
    }
    
}
extension SearchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel?.filterUserCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchCell else {return UITableViewCell()}
        cell.user = viewModel?.cellForRow(indexPath: indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         viewModel?.selectedUser(indexPath: indexPath.row)
    }
}
extension SearchViewController : UISearchResultsUpdating,UISearchControllerDelegate{
  
    func updateSearchResults(for searchController: UISearchController) {
        guard let text        = searchController.searchBar.text else {return}
        
        if text.isEmpty{
            self.tableView.reloadData()
        }else {
            viewModel?.searchUser(text: text)
            self.tableView.reloadData()
        }
    }
    
    
}
