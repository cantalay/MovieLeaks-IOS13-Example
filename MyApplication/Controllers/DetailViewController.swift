//
//  DetailViewController.swift
//  MyApplication
//
//  Created by Can Talay on 30.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import UIKit

class DetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    var urlString: String = "top"
    var currentState:CGFloat = 0.0
    var header: HeaderReusableView?
    var moviesManager = MoviesManager()
    var movie: MoviesDetail?
    fileprivate let cellIdentifier = "cellId"
    fileprivate let headerIdentifier = "headerId"
    fileprivate let padding: CGFloat = 16
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if let state =  header?.animator.state.rawValue{
            if state == 1{
               header?.animator.stopAnimation(true)
               header?.animator.finishAnimation(at: .current)
            }
        }
    }
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Untitled")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundView = imageView
        moviesManager.delegate = self
        moviesManager.fetchMovie(imdbID: urlString)
        self.showSpinner(onView: self.view)
        setupCustomLayout()
        setupCollectionView()
        }
        // Do any additional setup after loading the view.
    
    fileprivate func setupCustomLayout() {
        //layout customization
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.sectionInset = .init(top: padding, left: padding, bottom: -padding, right: -padding)
            //layout.minimumLineSpacing = 100
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        self.collectionView.collectionViewLayout = StretchyHeaderLayout()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(DetailViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
}

//MARK: - UICollectionViewController

extension DetailViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DetailViewCell
        if indexPath.row == 0 {
            if let movie = movie {
                var actors = "Actors: \(movie.actors) \n"
                actors += "Writer: \(movie.writer) "
                cell.heavyLabel.text = "Actors and Writers"
                cell.descriptionLabel.text = actors
            }
        }
        if indexPath.row == 1 {
            if let movie = movie {
                let imdb = "Imdb Rating : \(movie.imdbRating) \n Total Vote : \(movie.imdbVotes) \n MetaScore : \(movie.metaScore)"
                cell.heavyLabel.text = "Imdb and metaScore"
                cell.descriptionLabel.text = imdb
            }
        }
        if indexPath.row == 2 {
            if let movie = movie {
                cell.heavyLabel.text = "Plot"
                cell.descriptionLabel.text = movie.plot
            }
        }
        return cell
    }
    
    
}

//MARK: - UICollectionViewHeaderController

extension DetailViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSetY = scrollView.contentOffset.y
        self.view.layoutIfNeeded()
        //header?.animator.startAnimation()
        header?.animator.fractionComplete = CGFloat(abs(contentOffSetY)/(150))
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderReusableView
        print("HEADER INSIDE")
        //self.showSpinner(onView: self.view)
        DispatchQueue.main.async {
            if let movie = self.movie {
                //self.removeSpinner()
                self.header?.descriptionLabel.text = movie.genre
                self.header?.heavyLabel.text = movie.title
                if let url = URL(string: movie.poster) {
                    self.header?.imageView.load(url: url)
                }
                self.removeSpinner()
            }
            
        }
         
        return header!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: view.frame.width, height: 340)
    }
    
}

//MARK: - MoviesManagerDelegate


extension DetailViewController: MoviesManagerDelegate {
    func didUpdateMovies(movies: [Movies]?) {
        
    }
    
    func didFailWithError(error: Error?) {
        
    }
    
    func didSelectMovies(movie: MoviesDetail) {
        
        DispatchQueue.main.async {
            print("DID SELECT MOVIE : \(movie.title)")
            self.movie = movie
            
            self.collectionView.reloadData()
        }
            
    }
    
    
}

//MARK: - UICollectionViewFlowLayout

extension DetailViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UIDevice.current.orientation.isLandscape{
            header?.imageView.contentMode = .scaleAspectFit
        }else{
            header?.imageView.contentMode = .scaleAspectFit
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width - 2*padding, height: view.frame.height*0.25)
    }
    
}


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

