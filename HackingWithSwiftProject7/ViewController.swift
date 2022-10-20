//
//  ViewController.swift
//  HackingWithSwiftProject7
//
//  Created by user208023 on 10/18/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditsButton = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.rightBarButtonItem = creditsButton
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        navigationItem.leftBarButtonItem = filterButton
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter Petitions", message: "Filter the petitions you want to see by key-words", preferredStyle: .alert)
        ac.addTextField()
        let filterAction = UIAlertAction(title: "Filter", style: .default) {[weak self] _ in
            if let filterString = ac.textFields?[0].text {
                var petitionsFiltered = [Petition]()
                guard let petitionsArray = self?.petitions else { return }
                for petition in petitionsArray {
                    if petition.body.contains(filterString) {
                        petitionsFiltered.append(petition)
                    }
                }
                self?.petitions = petitionsFiltered
                self?.tableView.reloadData()
            }
        }
        ac.addAction(filterAction)
        present(ac, animated: true)
    }


}

