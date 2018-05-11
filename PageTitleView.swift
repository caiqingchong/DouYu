//
//  PageTitleView.swift
//  DouYu
//
//  Created by 张齐 on 2018/4/23.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
// MARK:-代理1
protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)

}

//设置普通和点击颜色
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

private let kScrollLineH :CGFloat = 4
private let lineH : CGFloat = 0.5

/*
 1、在这里处理懒加载的视图。
 */
class PageTitleView: UIView {
// MARK:- 实现代理
    weak var delegate : PageTitleViewDelegate?
    
    fileprivate var currentLabelIndex : Int = 0
    fileprivate var titles : [String] //提示是数组类型，里面为string类型
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //懒加载scrollView
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false//不显示水平滚动条
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false //不允许滚动
        scrollView.bounces = false //消除弹簧效果
        return scrollView
    }()
    
    //懒加载滚动的线  初始化线并设置颜色
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollView.backgroundColor = UIColor.orange
        return scrollView
    }()
    
    //自定义初始化的view  并添加视图
    init(frame : CGRect, titles : [String]) {
        self.titles = titles//为什么要放到super后面呢？

        /*
        非 Optional 属性，都必须在构造函数中设置初始值，从而保证对象在被实例化的时候，属性都被正确初始化
        在调用父类构造函数之前，必须保证本类的属性都已经完成初始化
         */
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*
 2、在这里处理视图的添加  fileprivate整个文件共用。
 */
extension PageTitleView{
    fileprivate func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds  //视图大小为当前页面view大小
        setupTitleLabels()
        setupBottomAndLine()
    }
    //添加label文字
    fileprivate func setupTitleLabels(){
        let labelW:CGFloat = frame.width / CGFloat(titles.count)
        let labelH:CGFloat = frame.height - kScrollLineH
        let labelY:CGFloat = 0
        //取出数组中的索引和标题  enumerated,枚举出所有的数据
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center//居中显示
            
            let labelX:CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //scrollView添加设置好的lable
            scrollView.addSubview(label)
            
            //在数组中欧添加label
            titleLabels.append(label)
            
            //为label添加手势，然后添加事件
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target:self,action:#selector(self.titleLabelClick(_:)));
        }
        
        
    }
    
    //添加线
    fileprivate func setupBottomAndLine(){
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        //在视图的底部
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        
        addSubview(bottomLine)
        
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x+firstLabel.frame.width*0.1, y: frame.height-kScrollLineH, width: firstLabel.frame.width*0.8, height: kScrollLineH)
        
        
    }
    
    
}



/*
 3、为label添加手势
 */
extension PageTitleView{
    @objc fileprivate func titleLabelClick(_ tapGes:UITapGestureRecognizer){
        //判断当前的手势是否从属与该lable 通过lable的tag值来判断  如果不是返回
        guard let currentLabel = tapGes.view as? UILabel else {return}
        if currentLabel.tag == currentLabelIndex {return}
        
        
        //当前数据的
        let oldLabel = titleLabels[currentLabelIndex]
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLabelIndex = currentLabel.tag
        
        let scrollLinePosition = currentLabel.frame.origin.x + currentLabel.frame.width * 0.1
        scrollLine.frame.size.width = currentLabel.frame.width * 0.8
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollLine.frame.origin.x = scrollLinePosition//X
        })
        
        //调用代理
        delegate?.pageTitleView(self, selectedIndex: currentLabelIndex)
        
    }
    
    
}


/*
 4、暴露给外部的方法
 */

extension PageTitleView{
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








