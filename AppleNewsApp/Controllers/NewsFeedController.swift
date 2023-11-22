//
//  ViewController.swift
//  AppleNewsApp
//
//  Created by maris.rozenstoks on 17/11/2023.
//

import UIKit
import Kingfisher

class NewsFeedController: UITableViewController {
    private var cellID = "CustomCell"
    private var newsItems: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchNews()
    }

    private func setupView() {
        title = "Latest Updates"
        view.backgroundColor = .systemBackground
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.translatesAutoresizingMaskIntoConstraints = false

        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    private func fetchNews() {
        NetworkManager.fetchData(url: NetworkManager.api) { [weak self] newsItems in
            self?.newsItems = newsItems.articles ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = newsItems[indexPath.row]
        showAlert(for: selectedArticle)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showAlert(for article: Article) {
        let alert = UIAlertController(title: article.title, message: nil, preferredStyle: .alert)
        
        let scrollableTextVC = ScrollableTextViewController()
        scrollableTextVC.textContent = article.description ?? ""
        
        alert.setValue(scrollableTextVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableViewCell

        let article = newsItems[indexPath.row]

        cell.titleLabel.text = article.title ?? ""
        cell.newsImageView.kf.setImage(with: URL(string: article.urlToImage ?? ""))

        return cell
    }
}

class CustomTableViewCell: UITableViewCell {
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            newsImageView.widthAnchor.constraint(equalToConstant: 120),

            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrollableTextViewController: UIViewController {
    var textContent: String = ""
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
    }
    
    private func setupTextView() {
        textView.text = textContent
        view.addSubview(textView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}
