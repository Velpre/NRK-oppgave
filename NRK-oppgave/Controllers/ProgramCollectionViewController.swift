//
//  ProgramCollectionViewController.swift
//  NRK-oppgave
//
//  Created by VP on 19/05/2023.
//

import UIKit



class ProgramCollectionViewController: UIViewController {
    
    var userAge: String!
    var movieList = [Item]()
    var movieImgList = [UIImage]()
    
    var programDataModel = ProgramDataModel()
    let spinnerVC = LoadingSpinnerViewController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userageOutlet: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connecting delegates
        programDataModel.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        programDataModel.videoDelegate = self
        
        //Handeling data fetch
        addSpinner(to: self, spinner: spinnerVC)
        programDataModel.fetchProgram(age: userAge)
        
        addCollectionViewUI()
        userageOutlet.text = userAge + " år"
    }
    
    func addCollectionViewUI(){
        collectionView.collectionViewLayout = createLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        //Item
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), size: 2.5)

        let itemFullScreen = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), size: 2.5)

        //MARK: small horizontal group
    
        let horizontalGroupTwoItems = CompositionalLayout.createGroup(aligment: .horizontal, width: .fractionalWidth(1), height: .absolute(200), items: [item, item])


        let horizontalGroupFullScreen = CompositionalLayout.createGroup(aligment: .horizontal, width: .fractionalWidth(1), height: .absolute(400), item: itemFullScreen, count: 1)

        //MARK: final group with all nested groups
        let mainGroup = CompositionalLayout.createGroup(aligment: .vertical, width: .fractionalWidth(1), height: .absolute(600), items: [horizontalGroupTwoItems,  horizontalGroupFullScreen, horizontalGroupFullScreen])
        
        //Section
        let section = NSCollectionLayoutSection(group: mainGroup)
        //return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //Checking if item is playeble(program) or not
    func checkIfSerie(movie: Item) -> Bool{
        if movie.type == "series" {
            return false
        } else if movie.type == "program"{
            return true
        }
        return false
    }
    
}

//MARK: Collection view Deletates
extension ProgramCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        let movie = movieList[indexPath.row]
        
        cell.movieImage.image = movieImgList[indexPath.row]
        cell.title.text = movie.title
        cell.undertitle.text = movie.subTitle
        
        //Checking if item is playeble(program) or not
        let checkIfPlayble = checkIfSerie(movie: movie)
        
        //Adding UI depending if it is playable(program) or not
        if !checkIfPlayble {
            cell.serieMarkerOutlet.isHidden = false
            cell.playButton.isHidden = true
        } else {
            cell.playButton.isHidden = false
            cell.serieMarkerOutlet.isHidden = true
        }
        
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if checkIfSerie(movie: movieList[indexPath.row]){
            if let href = movieList[indexPath.row]._links.playback?.href{
                programDataModel.fetchVideoInfo(path: href)
            }
        }else{
            showAlertWith(message: "Denne er ikke mulig år se", title: "Info")
        }

    }
}


extension ProgramCollectionViewController: DataManagerDelegate{
    func didUpdateData(_ movie: [Item], _ imageList: [UIImage]) {
        //print(movie)
//        print("-----------")
//        print(imageList)
        self.movieList = movie
        self.movieImgList = imageList
        self.collectionView.reloadData()
        self.spinnerVC.view.removeFromSuperview()
    }
    
    func didFoundError(_ error: String) {
        showAlertWith(message: error)
    }
}


extension ProgramCollectionViewController: VideoManagerDelegate{
    func didUpdateVideo(_ video: String) {
        print(video)
    }
}
