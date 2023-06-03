//
//  MainViewController.swift
//  ChatBot
//
//  Created by 장세림 on 2023/06/02.
//  Copyright © 2023 Apple Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // @IBOutlet var img1: UIImageView!
    @IBAction func btn1(_ sender: Any) {
    }
    // @IBOutlet var slide: UICollectionView!
    
    let youtubeLinks = [
        "https://www.youtube.com/watch?v=fhdX3Wcxwas",
        "https://www.youtube.com/watch?v=pVZtnlA0HUs",
        "https://www.youtube.com/watch?v=NJuSStkIZBg"
    ]
    
    var thumbnails: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이미지뷰 스타일 설정
        //img1.layer.borderWidth = 2.0
        //img1.layer.borderColor = UIColor(red: 96/255, green: 150/255, blue: 180/255, alpha: 1.0).cgColor
        //img1.layer.cornerRadius = 20
        //img1.clipsToBounds = true
        
        // 버튼 스타일 설정
        // btn1.layer.cornerRadius = btn1.frame.height / 2
        // btn1.clipsToBounds = true
        
        /*
        // 슬라이드 컬렉션 뷰 설정
        slide.delegate = self
        slide.dataSource = self
        slide.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // 컬렉션 뷰 레이아웃 설정
        if let flowLayout = slide.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
         */
        
        // 썸네일 이미지 다운로드
        downloadThumbnails()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        /// 이미지뷰 생성 또는 재활용
        var imageView: UIImageView!
        if let existingImageView = cell.contentView.subviews.first as? UIImageView {
            imageView = existingImageView
        } else {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
        }

        // 이미지뷰 프레임 크기 설정
        imageView.frame = cell.contentView.bounds

        // 썸네일 이미지 설정
        imageView.image = thumbnails[indexPath.item]

     
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < youtubeLinks.count else {
            return
        }
        
        if let youtubeURL = URL(string: youtubeLinks[indexPath.item]) {
            UIApplication.shared.open(youtubeURL)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 181)
    }
   /*
    @IBAction func btn1Tapped() {
        // 버튼을 눌렀을 때 실행할 코드를 여기에 작성하세요
        // 다른 페이지로 넘어가는 코드를 추가하세요
    }
    */
     
    
    // MARK: Thumbnail 다운로드
    
    func downloadThumbnails() {
        for link in youtubeLinks {
            if let videoID = extractVideoID(from: link) {
                let thumbnailURL = URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")
                let task = URLSession.shared.dataTask(with: thumbnailURL!) { (data, response, error) in
                    if let data = data, let thumbnail = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.thumbnails.append(thumbnail)
                            // self.slide.reloadData()
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    // 유튜브 링크에서 비디오 ID 추출
    func extractVideoID(from link: String) -> String? {
        let pattern = "v=([\\w-]+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: link.utf16.count)
        if let match = regex?.firstMatch(in: link, options: [], range: range),
           let range = Range(match.range(at: 1), in: link) {
            return String(link[range])
        }
        return nil
    }
}
