//
//  PageTitleView.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/27.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
/*
 流程要点：代理、手势、事件、动画移动
 完成一个一个的移动处理，先不要处理子视图的问题。
 1、代理
 */
/*
@objc protocol XMTestDelegate {
    /// 定义可选方法
    @objc optional func sendDataToBack(str: String)
    
    /// 定义必选方法
    func sendData2Back(str: String)
}
*/

//MARK : - 1、设置代理,里面包含传的视图和对应的索引

protocol  PageTitleViewDelegate :class{
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}
//MARK : - 2、设置相应的数据
private let kNormalColor :(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor :(CGFloat,CGFloat,CGFloat) = (255,128,0)

private let kScrollLineH :CGFloat = 4
private let lineH:CGFloat = 0.5

//MARK : - 3、自定义View
class PageTitleView: UIView {
    //3.1声明一个delegate属性
    weak var delegate : PageTitleViewDelegate?
    
    fileprivate var currentLabelIndex :Int = 0
    fileprivate var titles :[String]
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //3.2设置scrollView进行
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    
    //3.3添加scrollView下方的移动线 设置相应的属性
    fileprivate lazy var scrollLine : UIView = {
    let scrollLine = UIView()
    scrollLine.backgroundColor = UIColor.orange
    
    return scrollLine
    }()
    
    //3.4 对自定义视图PageTitleView进行初始化
    init(frame : CGRect , titles : [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK : - 4 为页面添加UI视图
extension PageTitleView{
    //4.1 总的管理视图
    fileprivate func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds//scrollView填充自定义的view
        //在scrollView中添加label以及滚动条
        setupTitleLabels()
        setupBottomAndLine()
    }
    //4.2 添加title
    fileprivate func setupTitleLabels(){
        //每个标题的宽度相同
        let labelW:CGFloat = frame.width / CGFloat(titles.count)
        //高度为减去滚动条的
        let labelH:CGFloat = frame.height - kScrollLineH
        let labelY:CGFloat = 0
        
        //遍历所有的title，为每个title创建一个label并添加手势处理事件
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //设置frame，主要是X的变化
            let labelX:CGFloat = labelW*CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)

            //添加label到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)//将所有的label存到数组里面留到后面使用
            
            //为label添加手势，使其具备事件触发功能
            label.isUserInteractionEnabled = true
            //(self.titleLabelClick(_:))针对的是有tag的,要传递指定类型的对象手势、UI都可以
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    //4.3创建底部滚动视图
    fileprivate func setupBottomAndLine(){
        //这里设置最底部有一条灰色的   线   看个人心情吧，我是觉得可以没有
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        //起始设置为第一个视图  滚动图为黄色
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x+firstLabel.frame.width*0.1, y: frame.height-kScrollLineH, width: firstLabel.frame.width*0.8, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
    }
    
    
    
}

//MARK : - 5 添加手势处理事件titleLabelClick,并在手势里面完成代理方法的调用
extension PageTitleView{
    @objc fileprivate func titleLabelClick(_ taps:UITapGestureRecognizer){
        //从手势中取出label视图
        guard let currentLabel = taps.view as? UILabel else {return}
        //判断如果点击的是当前的label，那么就不移动，直接return
        if currentLabel.tag == currentLabelIndex{return}
        //currentLabelIndex在后面会,更新当前的label索引
        let oldLabel = titleLabels[currentLabelIndex]
        //点击label之后，改变颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)

        currentLabelIndex = currentLabel.tag
        
        //设置滚动条的移动的距离，宽度是label的 0.8，放到中间位置。
        let scrollLinePosition = currentLabel.frame.origin.x + currentLabel.frame.width * 0.1
        scrollLine.frame.size.width = currentLabel.frame.width * 0.8
        
        //设置动画
        UIView.animate(withDuration: 0.2) {
            self.scrollLine.frame.origin.x = scrollLinePosition
        }
        
        //重点，在此处处理代理方法  或重新调用方法上面的方法，刷新数据。
        delegate?.pageTitleView(self, selectedIndex: currentLabelIndex)
    }
    
}


//MARK : - 6 提供给外部调用的方法  用在子视图滑动时传递改变
extension PageTitleView{
    //progress:获取移动的百分比  sourceIndex：源索引  targetIndex：目标索引
    func setTitleWithProgress(_ progress:CGFloat,sourceIndex : Int,targetIndex : Int){
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + sourceLabel.frame.width*0.1 + moveX
        
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //
        currentLabelIndex = targetIndex
        
    }
    
    
}









