import UIKit

class AlgoCollectionCellView: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label: UILabel = .init(text: .empty, font: .boldSystemFont(ofSize: 14))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label: UILabel = .init(text: .empty, font: .systemFont(ofSize: 10))
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        return label
    }()
    
    lazy var favButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            self?.callBack?()
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        return button
      }()
    
    var callBack: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        
        let labelsStackView = VerticalStackView(
            arrangedSubviews:
                [
                    nameLabel,
                    descriptionLabel,
                ],
            spacing: 5
        )
        backgroundColor = .systemGray.withAlphaComponent(0.1)
        labelsStackView.alignment = .leading
        labelsStackView.distribution = .fill
        addSubview(labelsStackView)
        addSubview(favButton)
        
        
        NSLayoutConstraint.activate([
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            favButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favButton.leadingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(model: GitHubCollectionModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        let icon = model.isFavorite ? "heart.fill" : "heart"
        favButton.setImage(UIImage(systemName: icon), for: .normal)
    }
}

