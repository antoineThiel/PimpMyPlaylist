//
//  MovieViewController.swift
//  PimpMyPlaylist
//
//  Created by Antoine THIEL on 17/01/2021.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate {
    let Api = ApiService()
    
    @IBOutlet var tableView: UITableView!
    private var movie:TmdbMovie!
    var watchlistMoviesId: [Int] = []
    @IBOutlet var overviewTitleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var titleMovieLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    class func newInstance(nibName:String?, movie: TmdbMovie) -> MovieViewController{
        let movieView = MovieViewController(nibName: "MovieViewController", bundle: nil)
        movieView.movie = movie
        return movieView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let img = UIImage(named: "saitama") else { return }
        self.view.backgroundColor = UIColor(patternImage: img)
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        //self.tableView.backgroundColor = UIColor.clear
        self.registerTableViewCells()
        self.titleMovieLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        self.overviewTitleLabel.text = NSLocalizedString("controller.movie.overviewTitle", comment: "")
        self.addButton.setTitle(NSLocalizedString("controller.movie.addButton", comment: ""), for: .normal)
        
        //Get all infos from tmbd then fill the following infos
    }
    
    
    
    private func registerTableViewCells(){
        let textFieldCell = UINib(nibName: "MovieTableViewCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    

    @IBAction func addWatchlist(_ sender: Any) {
        //Call api to add movie id to our watchlist and update the user movies
        self.addButton.setTitle("Added", for: .normal)
        let idFile = getDocumentsDirectory().appendingPathComponent("id.txt")
        let id = try! String(contentsOf: idFile)
        let userId = Int(id)
        Api.postMovie(movie: movie, userId: userId!) { [self] (result) in
            switch result{
            case .success(let film):
                Api.getAllMovie { (result) in
                    switch result{
                    case .success(let moviesData):
                        let array = moviesData.arrayWatchListMovies
                        for movie in array {
                            watchlistMoviesId.append(movie.id!)
                        }
                        watchlistMoviesId.append(film.id)
                        Api.updateUserMovie(movieId: watchlistMoviesId) { (result) in
                            switch result{
                            case .success( _):
                                break
                            case .failure(let e):
                                print(e)
                                break
                            }
                        }
                        break
                    case .failure(let e):
                        print(e)
                        break
                    }
                }
            break
            case .failure(let error):
                print(error)
            break
            }
        }
    }
    

}

extension MovieViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell {
            switch indexPath.row {
            case 0:
                cell.labelKey.text = NSLocalizedString("controller.movie.date", comment: "")
                cell.labelValue.text = movie.release_date != nil ? movie.release_date : "n.c"
            case 1:
                cell.labelKey.text = NSLocalizedString("controller.movie.ogTitle", comment: "")
                cell.labelValue.text = movie.original_title
            case 2:
                cell.labelKey.text = NSLocalizedString("controller.movie.ogLanguage", comment: "")
                cell.labelValue.text = movie.original_language
            case 3:
                cell.labelKey.text = NSLocalizedString("controller.movie.popularity", comment: "")
                cell.labelValue.text = String(format: "%f", movie.popularity!)
            case 4:
                cell.labelKey.text = NSLocalizedString("controller.movie.genre", comment: "")
                cell.labelValue.text = String(format: "%d", movie.genre_ids)
            default:
                print("hi")
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
