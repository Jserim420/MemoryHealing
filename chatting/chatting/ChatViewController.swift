import UIKit

//channelTableViewCell.xib파일과 연동
class ChatViewController: UIViewController {
    @IBOutlet var channelTableView: UITableView!
    
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelTableView.delegate = self
        channelTableView.dataSource = self
        
        title = "채팅목록"
        
        channels = getChannelMocks()
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewController", for: indexPath) as! ChannelTableViewCell
        cell.chatRoomLabel.text = channels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatViewController()
        viewController.title = channel.name
        navigationController?.pushViewController(viewController, animated: true)
    }
}
