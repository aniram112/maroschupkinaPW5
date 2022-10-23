import UIKit


protocol AddNoteDelegate: AnyObject {
    func newNoteAdded(note: ShortNote)
}

final class AddNoteCell: UITableViewCell, UITextViewDelegate {
    static let reuseIdentifier = "AddNoteCell"
    public var addButton = UIButton()
    //public var background = UIColor.systemGray5
    
    var delegate: AddNoteDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        textView.delegate = self
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setupBackground(with color: UIColor){
        textView.backgroundColor = color
        contentView.backgroundColor = color
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    private func setupView() {
        textView.font = .systemFont(ofSize: 18, weight: .semibold)
        textView.textColor = .lightGray
        textView.text = "Type something"
        //textView.backgroundColor = background
        textView.setHeight(to: 140)
        
        addButton.setTitle("Add new note", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.setTitleColor(.systemBackground, for: .normal)
        addButton.backgroundColor = .label
        addButton.layer.cornerRadius = 8
        addButton.setHeight(to: 44)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        addButton.alpha = 0.5
        
        let stackView = UIStackView(arrangedSubviews: [textView, addButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.pin(to: contentView, [.left: 16, .top: 16, .right: 16, .bottom: 16])
        //contentView.backgroundColor = background
        
    }
    
    @objc
    private func addButtonTapped(_ sender: UIButton) {
        if (!textView.text.isEmpty && textView.text != "Type something"){
            delegate?.newNoteAdded(note: ShortNote(text: textView.text))
            textView.textColor = .lightGray
            textView.text = "Type something"
        }
    }
    
    private var textView = UITextView()
    
}
