//
//  PlantTableViewCell.swift
//  NavigationBarPractice
//
//  Created by yutong on 2021/10/26.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var featureTitleLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var picImage: UIImageView!
    var cellH:CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var cellViewModel: PlantCellViewModel? {
        didSet {
            idLabel.text = cellViewModel!.id
            let hOffset:CGFloat = 1 //locationLabel.frame.minY - nameLabel.frame.maxY
            nameLabel.text = cellViewModel!.name
            let lineH:CGFloat = nameLabel.font.pointSize
            let x = nameLabel.frame.minX
            let tX = nameTitleLabel.frame.minX
            let tW = nameTitleLabel.frame.width
            let tH = nameTitleLabel.frame.height
            let w:CGFloat = frame.width - nameLabel.frame.minX - 10 //221
            var lines = nameLabel.calculateMaxLines()
            nameTitleLabel.frame = CGRect(x: tX, y: nameLabel.frame.minY, width: tW, height: tH)
            nameLabel.frame = CGRect(x: x, y: nameLabel.frame.minY, width: w, height: lineH*CGFloat(lines))
            nameLabel.numberOfLines = Int(lines)
            nameTitleLabel.sizeToFit()
            nameLabel.sizeToFit()
            nameLabel.layer.borderColor = UIColor.gray.cgColor
            nameLabel.layer.borderWidth = 0

            locationLabel.text = cellViewModel!.location
            var y = nameLabel.frame.maxY + hOffset
            lines = locationLabel.calculateMaxLines()
            locationLabel.frame = CGRect(x: x, y: y, width: w, height: lineH*CGFloat(lines))
            locationTitleLabel.frame = CGRect(x: tX, y: y, width: tW, height: tH)
            locationLabel.numberOfLines =  Int(lines)
            locationTitleLabel.sizeToFit()
            locationLabel.sizeToFit()
            locationLabel.layer.borderColor = UIColor.gray.cgColor
            locationLabel.layer.borderWidth = 0

            featureLabel.text = cellViewModel!.feature
            y = locationLabel.frame.maxY + hOffset
            lines = featureLabel.calculateMaxLines()
            featureLabel.frame = CGRect(x: x, y: y, width: w, height: lineH*CGFloat(lines))
            featureTitleLabel.frame = CGRect(x: tX, y: y, width: tW, height: tH)
            featureLabel.numberOfLines = Int(lines)
            featureTitleLabel.sizeToFit()
            featureLabel.sizeToFit()
            featureLabel.layer.borderColor = UIColor.gray.cgColor
            featureLabel.layer.borderWidth = 0

            cellH = nameLabel.frame.height + locationLabel.frame.height + featureLabel.frame.height + nameLabel.frame.minY*2 + hOffset*2
            self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: cellH)
            if cellViewModel!.pic01URL != "" {
                downloadImage(from: URL(string: cellViewModel!.pic01URL)!)
            } else {
                self.picImage.image = UIImage(systemName: "square.slash")
            }
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)

            DispatchQueue.main.async() { [weak self] in
                self?.picImage.image = UIImage(data: data)
            }
        }
    }

}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
