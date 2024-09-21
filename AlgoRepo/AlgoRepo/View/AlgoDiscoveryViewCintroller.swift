import UIKit

class AlgoDiscoveryViewCintroller: UIViewController {
    
    fileprivate var viewModel : any AlgoDiscoveryViewModelProtocol
    
    lazy var peraButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self]_ in
            self?.viewModel.goToRepoList("perawallet")
        }))
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Pera Wallet", for: .normal)
        return button
      }()
    
    lazy var faundationButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            self?.viewModel.goToRepoList("algorandfoundation")
        }))
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Algorand Foundation", for: .normal)
        return button
      }()
    
    lazy var algorandButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            self?.viewModel.goToRepoList("algorand")
        }))
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Algorand", for: .normal)
        return button
      }()
    
    init(viewModel: any AlgoDiscoveryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        let verticalStack = VerticalStackView(arrangedSubviews: [faundationButton, algorandButton, peraButton], spacing: 10)
        layoutStack(source: verticalStack)
        
        navigationItem.title = "Discovery"
    }
    
    private func layoutStack(source: UIView) {
        view.addSubview(source)
        NSLayoutConstraint.activate([
            source.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            source.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
