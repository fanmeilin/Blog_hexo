---
title: pyqt截取窗口
tags: [python,pyqt]
categories: [python,pyqt]
date: 2021-12-16 10:49:22
---

> 在painter画笔进行绘制之后，需要保存画布图像。一种方法是使用Qpainter p(pixmap)，在指定的map上绘制后保存，可是此方法我保存图片时还是只有原始图片。绘制的图形无法保存；另一种方法时截取窗口保存图片。

## 介绍QScreen的方法

代码如下：
```python
pqscreen  = QGuiApplication.primaryScreen()
pixmap2 = pqscreen.grabWindow(self.winId(), self.x0, self.y0, abs(self.x1-self.x0), abs(self.y1-self.y0)) #本控件的id
pixmap2.save('555.png')
```
截屏的原理主要还是运用QScreen类中的grabWindow方法。

## grabWindow

`QScreen.grabWindow(WId window, int x = 0, int y = 0, int width = -1, int height = -1)`
大致意思是创建并返回通过抓取由QRect（x，y，width，height）限制的给定窗口构造的像素图。

### 参数 

参数（x，y）指定窗口中的偏移量，而（宽度，高度）指定要复制的区域。如果宽度为负数，则该函数将所有内容复制到窗口的右边界。如果高度为负数，则该函数将所有内容复制到窗口的底部。


### Wid

窗口系统标识符（WId）可以使用QWidget.winId（）函数进行检索。grabWindow（）函数从屏幕抓取像素，而不是从窗口抓取像素，即，如果有另一个窗口部分或全部覆盖抓取的像素，则也会从上面的窗口获取像素。鼠标光标一般不会被抓取。

如果是屏幕截图：id为`QtWidgets.QApplication.desktop().winId()`

## 源代码实现
```python
#!/usr/bin/env python
from PyQt5 import QtCore, QtWidgets,QtGui


class Screenshot(QtWidgets.QWidget):
    def __init__(self):
        super(Screenshot, self).__init__()
        self.screenshotLabel = QtWidgets.QLabel()
        self.screenshotLabel.setSizePolicy(QtWidgets.QSizePolicy.Expanding,
                QtWidgets.QSizePolicy.Expanding)
        self.screenshotLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.screenshotLabel.setMinimumSize(240, 160)
        self.createOptionsGroupBox()
        self.createButtonsLayout()
        mainLayout = QtWidgets.QVBoxLayout()
        mainLayout.addWidget(self.screenshotLabel)
        mainLayout.addWidget(self.optionsGroupBox)
        mainLayout.addLayout(self.buttonsLayout)
        self.setLayout(mainLayout)
        self.shootScreen()
        self.delaySpinBox.setValue(0)#延迟多少秒后截屏
        self.setWindowTitle("Screenshot")
        self.resize(300, 200)
        
    def resizeEvent(self, event):
        scaledSize = self.originalPixmap.size()
        scaledSize.scale(self.screenshotLabel.size(), QtCore.Qt.KeepAspectRatio)
        if not self.screenshotLabel.pixmap() or scaledSize != self.screenshotLabel.pixmap().size():
            self.updateScreenshotLabel()
            
    def newScreenshot(self):
        if self.hideThisWindowCheckBox.isChecked():
            self.hide()
        self.newScreenshotButton.setDisabled(True)
        QtCore.QTimer.singleShot(self.delaySpinBox.value() * 1000,
                self.shootScreen)
                
    def saveScreenshot(self):
        format = 'png'
        initialPath = QtCore.QDir.currentPath() + "/untitled." + format
        fileName,filetype = QtWidgets.QFileDialog.getSaveFileName(self, "Save As",
                initialPath,
                "%s Files (*.%s);;All Files (*)" % (format.upper(), format))
        if fileName:
            self.originalPixmap.save(fileName, format)
            print("file saved as  %s" % fileName)
           
    def shootScreen(self):
        if self.delaySpinBox.value() != 0:
            QtWidgets.qApp.beep()
        # Garbage collect any existing image first.
        self.originalPixmap = None
        #self.originalPixmap = QtGui.QPixmap.grabWindow(QtWidgets.QApplication.desktop().winId())#PyQt4
       
        screen= QtWidgets.QApplication.primaryScreen()#PyQt5
        self.originalPixmap = screen.grabWindow(QtWidgets.QApplication.desktop().winId())#PyQt5
       
        self.updateScreenshotLabel()
        self.newScreenshotButton.setDisabled(False)
        if self.hideThisWindowCheckBox.isChecked():
            self.show()
            
    def updateCheckBox(self):
        if self.delaySpinBox.value() == 0:
            self.hideThisWindowCheckBox.setDisabled(True)
        else:
            self.hideThisWindowCheckBox.setDisabled(False)
            
    def createOptionsGroupBox(self):
        self.optionsGroupBox = QtWidgets.QGroupBox("Options")
        self.delaySpinBox = QtWidgets.QSpinBox()
        self.delaySpinBox.setSuffix(" s")
        self.delaySpinBox.setMaximum(60)
        self.delaySpinBox.valueChanged.connect(self.updateCheckBox)
        self.delaySpinBoxLabel = QtWidgets.QLabel("Screenshot Delay:")
        self.hideThisWindowCheckBox = QtWidgets.QCheckBox("Hide This Window")
        optionsGroupBoxLayout = QtWidgets.QGridLayout()
        optionsGroupBoxLayout.addWidget(self.delaySpinBoxLabel, 0, 0)
        optionsGroupBoxLayout.addWidget(self.delaySpinBox, 0, 1)
        optionsGroupBoxLayout.addWidget(self.hideThisWindowCheckBox, 1, 0, 1, 2)
        self.optionsGroupBox.setLayout(optionsGroupBoxLayout)
        
    def createButtonsLayout(self):
        self.newScreenshotButton = self.createButton("New Screenshot",
                self.newScreenshot)
        self.saveScreenshotButton = self.createButton("Save Screenshot",
                self.saveScreenshot)
        self.quitScreenshotButton = self.createButton("Quit", self.close)
        self.buttonsLayout = QtWidgets.QHBoxLayout()
        self.buttonsLayout.addStretch()
        self.buttonsLayout.addWidget(self.newScreenshotButton)
        self.buttonsLayout.addWidget(self.saveScreenshotButton)
        self.buttonsLayout.addWidget(self.quitScreenshotButton)
    def createButton(self, text, member):
        button = QtWidgets.QPushButton(text)
        button.clicked.connect(member)
        return button
    def updateScreenshotLabel(self):
        self.screenshotLabel.setPixmap(self.originalPixmap.scaled(
                self.screenshotLabel.size(), QtCore.Qt.KeepAspectRatio,
                QtCore.Qt.SmoothTransformation))


if __name__ == '__main__':
    import sys
    app = QtWidgets.QApplication(sys.argv)
    screenshot = Screenshot()
    screenshot.show()
    sys.exit(app.exec_())
```