

import UIKit

class RestaurantViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var restaurants: [String] = []
    var selectedCity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchBar.delegate = self
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else {
            return
        }
        
        selectedCity = city
        fetchRestaurants(for: city)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row]
        return cell
    }
    
    // MARK: - Networking
    
    func fetchRestaurants(for city: String) {
        guard let url = URL(string: "http://overpass-api.de/api/interpreter?data=[out:json];area[name=\"\(city)\"]->.searchArea;node[amenity=restaurant](area.searchArea);out;") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let elements = json?["elements"] as? [[String: Any]] {
                    self.restaurants = elements.compactMap { $0["tags"] as? [String: String] } // Extract tags
                                                .compactMap { $0["name"] } // Get restaurant name
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
