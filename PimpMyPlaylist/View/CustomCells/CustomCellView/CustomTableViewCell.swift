//
//  CustomTableViewCell.swift
//  PimpMyPlaylist
//
//  Created by Antoine THIEL on 17/01/2021.
//

import UIKit

protocol CustomCellDelegate: class {
    func sharePressed(cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet public var label: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var buttonDel: UIButton!
    
    public var movieID:WatchListMovie!
    
    var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func updateButtonLabel(_ sender: Any) {
        let WatchListApi = WatchListService()
        WatchListApi.updateMovie(movie: movieID) { (result) in
            switch result{
            case .success(let movie):
                if movie.watched  {
                    self.onResultApi(state: true)
                }else {
                    self.onResultApi(state: false)
                }
                break
            case .failure(let e):
                print(e)
                break
            }
        }
    }
    
    
    @IBAction func deleteMovie(_ sender: Any) {
        delegate?.sharePressed(cell: self)
    }
    
    func onResultApi(state:Bool){
        if state {
            DispatchQueue.main.async {
                self.button.setTitle("Vu", for: .normal)
                self.button.setTitleColor(UIColor.green, for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.button.setTitle("A voir", for: .normal)
                self.button.setTitleColor(UIColor.red, for: .normal)
            }
        }
    }
  
}
