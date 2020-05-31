//
//  ViewController.swift
//  CollectionWithBackground
//
//  Created by Ahmed Fathi on 5/31/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var previousImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var previousHeader: HeaderView!
    @IBOutlet weak var nextHeader: HeaderView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Constants
    
    private let imageParallax: CGFloat = 30
    private let headerTranslation: CGFloat = 45
    private let headerRotationAngle: CGFloat = .pi * 0.1
    
    // MARK: - Properties
    
    private var currentIndex: Int = 0
    private let games: [Game] = mockGames
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    // MARK: Initial State
    
    private func setupInitialState() {
        if games.count > 0 {
            setCurrenGame(games[0])
        }
        
        if games.count > 1 {
            setNextGame(games[1])
        }
        
        // Hide next
        nextImageView.alpha = 0
        nextHeader.alpha = 0
        
        // Prepare filtered images in background
        Filters.prepareCache()
    }
    
    // MARK: Update User Interface
    
    private func setCurrenGame(_ game: Game) {
        previousImageView.image = game.blurredImage
        previousHeader.titleLabel.text = game.name
        previousHeader.subtitleLabel.text = game.developer
    }
    
    private func setNextGame(_ game: Game) {
        nextImageView.image = game.blurredImage
        nextHeader.titleLabel.text = game.name
        nextHeader.subtitleLabel.text = game.developer
    }
    
}


// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCell
        cell.imageView.image = games[indexPath.row].image
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        collectionView.bounds.size
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        .zero
    }
}

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemWidth = collectionView.bounds.width
        let offsetX = scrollView.contentOffset.x
        
        let currentItem = floor(offsetX / itemWidth)
        
        let itemOffsetX = currentItem * itemWidth
        let distanceFromSpotlight = (offsetX - itemOffsetX) / itemWidth
        
        updateImages(Int(currentItem), percentage: distanceFromSpotlight)
    }
    
    private func updateImages(_ index: Int, percentage: CGFloat) {
        if !games.contains(index: index) { return }
        
        if index < games.count - 1 {
            animationScreen(percentage: percentage)
        }
        
        if index == currentIndex { return }
        setCurrenGame(games[index])
        
        if games.contains(index: index + 1) {
            setNextGame(games[index + 1])
            
            setInitialAnimationPositions(index)
        }
        currentIndex = index
    }
    
}


// MARK: - Animations Helpers

extension ViewController {
    
    // MARK: Initial Position
    
    private func setInitialAnimationPositions(_ index: Int) {
        setInitialHeadersPosition()
        setInitialImagesAnimationPosition(index)
    }
    
    private func setInitialHeadersPosition() {
        previousHeader.transform = .identity
        nextHeader.transform = CGAffineTransform.identity.translatedBy(x: 0, y: headerTranslation)
    }
    
    private func setInitialImagesAnimationPosition(_ index: Int) {
        // Starting images positions
        previousImageView.transform = .identity
        if index > currentIndex {
            nextImageView.transform = CGAffineTransform.identity.translatedBy(x: imageParallax, y: 0)
        }
    }
    
    // MARK: Animations
    
    private func animationScreen(percentage: CGFloat) {
        animateHeaders(percentage: percentage)
        animateImages(percentage: percentage)
    }
    
    private func animateHeaders(percentage: CGFloat) {
        previousHeader.alpha = 1 - percentage
        previousHeader.transform = CGAffineTransform.identity.translatedBy(x: 0, y: headerTranslation * percentage)
        
        nextHeader.alpha = percentage
        nextHeader.transform = CGAffineTransform.identity.translatedBy(x: 0, y: (headerTranslation * percentage) - headerTranslation)
    }
    
    private func animateImages(percentage: CGFloat) {
        previousImageView.transform = CGAffineTransform.identity.translatedBy(x:  -1 * imageParallax * percentage, y: 0)
        nextImageView.alpha = percentage
        nextImageView.transform = CGAffineTransform.identity.translatedBy(x: imageParallax - (imageParallax * percentage), y: 0)
    }
}
