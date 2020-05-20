//
//  ViewController.swift
//  ARkittest
//
//  Created by 小林春斗 on 2020/04/14.
//  Copyright © 2020 小林春斗. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController , ARSCNViewDelegate , UIImagePickerControllerDelegate  {
    
    
    //　3Dデータの名前を入力
    var ARName: String  = "Yaguchi_Panic"
    // アニメーションの名前を入力
    var animationName: String  = "unnamed_animation__1"
    

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var animations = [String: CAAnimation]()
    var idle:Bool = true
    var n = 0
    var modelNode = [SCNNode()]
    var isDetectPlane = false
    private var frameNode: SCNNode!
    var planeNode: SCNNode? = nil
    var isShowingAnnotation = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        registerGestureRecognizers()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Sessionをストップ
        sceneView.session.pause()
    }
    
    /// ARSCNiew初期化設定
    func initialize (){
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        
    }
    
    ///　メインのビューのタップを検知するように設定する
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        
        // タップされた位置を取得する
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        // タップされた位置のARアンカーを探す
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            // タップした箇所が取得できていればitemを追加
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    /// アイテム配置メソッド
    func addItem(hitTestResult: ARHitTestResult) {
        sceneView.debugOptions = []
        //if let selectedItem = self.selectedItem {
        // 現実世界の座標を取得
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
            // アセットのより、シーンを作成
            let heroScene = SCNScene(named: "art.scnassets/\(ARName).dae")
            for childNode in heroScene!.rootNode.childNodes {
                modelNode[n].addChildNode(childNode)
            }
            let sceneURL2 = Bundle.main.url(forResource: "art.scnassets/\(ARName)", withExtension: "dae")
            let sceneSource2 = SCNSceneSource(url: sceneURL2!, options: nil)
            
            if let animationObject2 =  sceneSource2?.entryWithIdentifier("\(animationName)", withClass: CAAnimation.self) {
                // The animation will only play once
                animationObject2.repeatCount = 0
                // To create smooth transitions between animations
                // Store the animation for later use
                animations["fav"] = animationObject2
            }
            
            modelNode[n].addAnimation(animations["fav"]!, forKey: nil)
        
        
        modelNode[n].scale = SCNVector3Make(0.1, 0.1, 0.1)
        
        if let camera = sceneView.pointOfView {
            modelNode[n].eulerAngles.y = camera.eulerAngles.y
        }
        // アイテムの配置
        modelNode[n].position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        sceneView.scene.rootNode.addChildNode(modelNode[n])
        n += 1
        modelNode.append(SCNNode())
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("renderer: didAdd")
        
    }
    


}

