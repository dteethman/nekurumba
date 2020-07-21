import UIKit

class HighlightCollectionViewCell: UICollectionViewCell {
    public var data: HighlightData? {
        didSet {
            if let d = data {
                markView.bgColors = d.mark ? (light: greenHighlightColor, dark: greenHighlightColor) : (light: redHighlightColor, dark: redHighlightColor)
                markLabel.text = d.mark ? "👍" : "👎"
                titleTextView.attributedText = d.title
                descriptionTextView.text = d.text
                layoutSubviews()
            }
            
        }
    }
    
//    public var bgColors: (light: UIColor, dark: UIColor) = (light: .white, dark: .black){
//        didSet {
//            bgView.bgColors = bgColors
//        }
//    }
    
    private let bgView = NMViev()
    private let bgMask = UIView()
    private let titleTextView = UITextView()
    private let descriptionTextView = UITextView()
    private let markView = NMViev()
    private let markLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.bgColors = bgColors
        bgView.cornerRadius = 10
        
        bgMask.translatesAutoresizingMaskIntoConstraints = false
        bgMask.layer.cornerRadius = 10
        bgMask.clipsToBounds = true
        
        markView.translatesAutoresizingMaskIntoConstraints = false
        markView.cornerRadius = 20
        
        markLabel.translatesAutoresizingMaskIntoConstraints = false
        markLabel.font = UIFont.systemFont(ofSize: 22)
        markLabel.textAlignment = .center
        
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.backgroundColor = .clear
        titleTextView.textContainer.lineBreakMode = .byWordWrapping
        titleTextView.textAlignment = .left
        titleTextView.isScrollEnabled = false
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        descriptionTextView.textContainer.lineBreakMode = .byWordWrapping
        descriptionTextView.textAlignment = .left
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        contentView.addSubview(bgView)
        contentView.addSubview(bgMask)
        bgMask.addSubview(markView)
        bgMask.addSubview(markLabel)
        bgMask.addSubview(titleTextView)
        bgMask.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bgMask.topAnchor.constraint(equalTo: bgView.topAnchor),
            bgMask.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            bgMask.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            bgMask.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            markView.topAnchor.constraint(equalTo: bgMask.topAnchor, constant: 7),
            markView.trailingAnchor.constraint(equalTo: bgMask.trailingAnchor, constant: -7),
            markView.widthAnchor.constraint(equalToConstant: 40),
            markView.heightAnchor.constraint(equalToConstant: 40),
            
            markLabel.topAnchor.constraint(equalTo: markView.topAnchor),
            markLabel.bottomAnchor.constraint(equalTo: markView.bottomAnchor),
            markLabel.leadingAnchor.constraint(equalTo: markView.leadingAnchor),
            markLabel.trailingAnchor.constraint(equalTo: markView.trailingAnchor),
            
            titleTextView.topAnchor.constraint(equalTo: markView.topAnchor, constant: 0),
            titleTextView.bottomAnchor.constraint(equalTo: markView.bottomAnchor, constant: 3),
            titleTextView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 7),
            titleTextView.trailingAnchor.constraint(equalTo: markView.leadingAnchor, constant: -7),
            
            descriptionTextView.topAnchor.constraint(equalTo: markView.bottomAnchor, constant: 5),
            descriptionTextView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -7),
            descriptionTextView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 7),
            descriptionTextView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -7),
        ])
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
