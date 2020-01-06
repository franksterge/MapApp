
import UIKit

class CustomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }    
}
