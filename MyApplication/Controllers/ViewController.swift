//
//  ViewController.swift
//  MyApplication
//
//  Created by Can Talay on 27.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    var numberOfItemsPerRow:CGFloat = 2
   var spacingBetweenCells:CGFloat = 10
    @IBOutlet weak var collectionView: UICollectionView!
    
    var moviesManager = MoviesManager()
    var movies: [Movies] = []
    var moviesDetail: MoviesDetail?
    
    var currentIndex = 0
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Untitled")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MovieLeaks"
        showSearchBar()
        showSpinner(onView: view)
        collectionView.backgroundView = imageView
        collectionView.delegate = self
        collectionView.dataSource = self
        moviesManager.delegate = self

        collectionView.register(UINib(nibName: "MoviesView", bundle: nil), forCellWithReuseIdentifier: "MoviesCard")
        moviesManager.fetchMovie(search: "Hello")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            print("IMDBID : \(movies[currentIndex].imdbID)")
            
            detailViewController.urlString = movies[currentIndex].imdbID
            
            
        }
    }
    
    func showSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        //true for hiding, false for keep showing while scrolling
        searchController.searchBar.sizeToFit()
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.placeholder = "Search Movies Here!"
        navigationItem.searchController = searchController
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let optionalSearch = searchBar.text{
            self.showSpinner(onView: self.view)
            moviesManager.fetchMovie(search: optionalSearch)
        }
        
    }

}

//MARK: - MoviesManagerDelegate

extension ViewController: MoviesManagerDelegate {
    func didUpdateMovies(movies: [Movies]?) {
        if let movies = movies {
            DispatchQueue.main.async {
                self.movies = movies
                
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func didSelectMovies(movie: MoviesDetail) {
    }
    
    
    func didFailWithError(error: Error?) {
        print(error!)
    }
}


//MARK: - UIVIEWDataSource-CollectionView
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCard", for: indexPath) as! MoviesView
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.text = movies[indexPath.row].title
        let url = URL(string: movies[indexPath.row].poster)
        
        if let optionalURL = url {
            cell.imageView.load(url: optionalURL)
            self.removeSpinner()
            print("COLLECTIONVIEW")
        }else{
            self.showSpinner(onView: self.view)
        }
        
        return cell
    }
    
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout


extension ViewController:  UICollectionViewDelegateFlowLayout {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            
          //here you can do the logic for the cell size if phone is in landscape
            self.numberOfItemsPerRow = 3
            self.spacingBetweenCells = 5
        } else {
           
            self.numberOfItemsPerRow = 2
            self.spacingBetweenCells = 5
          //logic if not landscape
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let totalSpacing = (2*spacingBetweenCells) + ((self.numberOfItemsPerRow-1)*self.spacingBetweenCells)
        
        if let collection = self.collectionView {
            
            let width = (collection.bounds.width - totalSpacing)/self.numberOfItemsPerRow
            
            
            return CGSize(width: width, height: (width*1.5))
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}


//MARK: - UIImageView


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select ITEM ")
        self.currentIndex = indexPath.row
        self.performSegue(withIdentifier: "goDetailView", sender: self)
        
        
        
    }
    
    
    
}
