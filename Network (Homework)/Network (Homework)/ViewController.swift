//
//  ViewController.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 21.11.22.
//

import UIKit

class ViewController: UIViewController {
    
    var arrayOfDeps = [DepartmentModel]()
    var uniqueCities = [String]()
    var sortedDeps = [DepartmentModel]()
    var selectedCollectionCell = IndexPath()
    var searchedDeps = [DepartmentModel]()
    var tapped: Bool = false
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    var searchBar: UISearchController = {
        var searchBar = UISearchController(searchResultsController: nil)
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.barStyle = .black
        searchBar.searchBar.placeholder = "Search by city"
        return searchBar
    }()
    private var searchIsEmpty: Bool {
        guard let text = searchBar.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isSearching: Bool {
        return searchBar.isActive && !searchIsEmpty
    }


    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func registerCells() {
        let collectionCell = UINib(nibName: CollectionViewCell.id, bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: CollectionViewCell.id)
        let sortCell = UINib(nibName: SortCell.id, bundle: nil)
        collectionView.register(sortCell, forCellWithReuseIdentifier: SortCell.id)
        let tableCells = UINib(nibName: TableViewCell.id, bundle: nil)
        tableView.register(tableCells, forCellReuseIdentifier: TableViewCell.id)
    }
    
    func getInfo() {
        spinner.startAnimating()
        DepartmentProvider().getDepartments { departments in
            self.arrayOfDeps = departments
            self.setUniqueCities()
            self.addDeps()
            self.uniqueCities.insert("Sort", at: 0)
            self.uniqueCities.insert("All", at: 0)
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.navigationItem.searchController = self.searchBar
            self.spinner.stopAnimating()
        } failure: {
            self.spinner.stopAnimating()
        }
    }
    
    func addDeps() {
        arrayOfDeps.forEach { deps in
            sortedDeps.append(deps)
        }
    }
    
    func setUniqueCities() {
        let _ = arrayOfDeps.filter { item in
            if uniqueCities.contains(item.city) {
                return false
            } else {
                uniqueCities.append(item.city)
                return true
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uniqueCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath)
        guard let cell = cell as? CollectionViewCell else { return cell }
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortCell.id, for: indexPath)
            guard let sortCell = cell as? SortCell else { return cell }
            sortCell.isSelected = selectedCollectionCell == indexPath
            sortCell.setup()
            sortCell.labelOutlet.text = "Sort by city"
            tapped ? (sortCell.imageOutlet.image = UIImage(systemName: "chevron.down")) : (sortCell.imageOutlet.image = UIImage(systemName: "chevron.up"))
            return sortCell
        }
        cell.isSelected = selectedCollectionCell == indexPath
        cell.setup()
        cell.label.text = uniqueCities[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCollectionCell = indexPath
        if indexPath.row == 0 {
            sortedDeps = arrayOfDeps
        } else if indexPath.row == 1 {
            if tapped {
                sortedDeps = sortedDeps.sorted {
                    $0.city < $1.city
                }
                tapped = !tapped
            } else {
                sortedDeps = sortedDeps.sorted {
                    $0.city > $1.city
                }
                tapped = !tapped
            }
            tableView.reloadData()
            collectionView.reloadData()
            
        } else {
            sortedDeps = arrayOfDeps.filter { $0.city == uniqueCities[indexPath.row] }
        }
        
        collectionView.reloadData()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedDeps.count
        }
        return sortedDeps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dep: DepartmentModel
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath)
        guard let cell = cell as? TableViewCell else { return cell }
        if isSearching {
            dep = searchedDeps[indexPath.row]
        } else {
            dep = sortedDeps[indexPath.row]
        }
        cell.labelOutlet.text = "\(dep.city) \(dep.department)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return collectionView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searching(searchText: text)
    }
    private func searching(searchText: String) {
        searchedDeps = arrayOfDeps.filter{ $0.city.contains(searchText) }
        tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectedCollectionCell = IndexPath(row: 0, section: 0)
        sortedDeps = arrayOfDeps
        tableView.reloadData()
        collectionView.reloadData()
    }
}
