import UIKit

final class NotesViewController: UIViewController {
    public var background = UIColor.systemBackground
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupView() {
        setupTableView()
        setupNavBar()
    }
    
    private func setupNavBar() {
        self.title = "Notes"
        let closeButton = UIButton(type: .close)
        closeButton.addTarget(self, action: #selector(dismissViewController(_: )), for: .touchUpInside)
    }
    
    @objc
    private func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)
        tableView.register(AddNoteCell.self, forCellReuseIdentifier: AddNoteCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 20
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.pin(to: self.view)
    }
    
    private func handleDelete(indexPath: IndexPath) {
        Storage.shared.dataSource.remove(at: indexPath.row)
        Storage.shared.saveData()
        tableView.reloadData()
    }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    //public var dataSource = [ShortNote]()
    //private var dataSource = [ShortNote(text: "a"), ShortNote(text: "We're no strangers to love You know the rules and so do I (do I)"), ShortNote(text: "c")]
}

extension NotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return  Storage.shared.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier: AddNoteCell.reuseIdentifier, for: indexPath) as? AddNoteCell {
                addNewCell.setupBackground(with: background.darker(by: 10) ?? .systemGray5)
                addNewCell.delegate = self
                return addNewCell
            }
        default:
            let note = Storage.shared.dataSource[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as? NoteCell {
                noteCell.configure(note: note, background: background.darker(by: 10) ?? .clear)
                noteCell.contentView.backgroundColor = background
                return noteCell
            }
        }
        return UITableViewCell()
    }
    
    
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: .none) { [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NotesViewController: AddNoteDelegate {
    func newNoteAdded(note: ShortNote) {
        Storage.shared.dataSource.insert(note, at: 0)
        Storage.shared.saveData()
        tableView.reloadData()
    }
}
