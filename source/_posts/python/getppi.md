---
title: 获得电脑的ppi
tags: python
categories: python
date: 2021-10-26 14:02:47
---

> 获取电脑的分辨率，物理尺寸，PPI
> 首先介绍一下PPI和DPI：
> PPI（Pixels Per Inch）每一英寸长度上有多少像素点；计算方式可以使用像素点除以屏幕尺寸。
> 分辨率DPI（Dots Per Inch）每一英寸有多少点，这里的点是可以改变的，可以是 1Dot = 1Pixel，也可以是 1Dot = N Pixel。在电脑里，分辩率是可以调节的，这里用的就是Dot ，密度用DPI描述；只有当使用屏幕最大分辩率的时候（即 1Dot = 1Pixel），这个时候 DPI = PPI。

  搜集了很多代码和方法，最后找到一个比较精准的方法是使用Tkinter。
- 可以得到显示屏的尺寸，获取以毫米为单位宽高（winfo_screenmmheight()，winfo_screenmmwidth()），获取显示屏的pixels数目（winfo_screenheight()，winfo_screenwidth()）。

```python
# tk获取屏幕的分辨率和尺寸
from tkinter import Tk
# creating tkinter window
base = Tk()
#screen's length and width in pixels and mm
length_1= base.winfo_screenheight()
width_1= base.winfo_screenwidth()
length_2 = base.winfo_screenmmheight()
width_2 = base.winfo_screenmmwidth()
#screen Depth
screendepth = base.winfo_screendepth()
print("width x length (in pixels) =",(width_1,length_1))
print("width x length (in mm) =", (width_2, length_2))
width_ppn = width_1/width_2
length_ppn = length_1/length_2
ppn = round((width_ppn+length_ppn)/2,2)
print(width_1/width_2,length_1/length_2,ppn)

```
- 使用win32库中的分辨率方法win32print.GetDeviceCaps()，缩放后的分辨率GetSystemMetrics。

```python
## 获取分辨率
from win32 import win32api, win32gui, win32print
from win32.lib import win32con

from win32.win32api import GetSystemMetrics


def get_real_resolution():
    """获取真实的分辨率"""
    hDC = win32gui.GetDC(0)
    # 横向分辨率
    w = win32print.GetDeviceCaps(hDC, win32con.DESKTOPHORZRES)
    # 纵向分辨率
    h = win32print.GetDeviceCaps(hDC, win32con.DESKTOPVERTRES)
    return w, h


def get_screen_size():
    """获取缩放后的分辨率"""
    w = GetSystemMetrics (0)
    h = GetSystemMetrics (1)
    return w, h

real_resolution = get_real_resolution()
screen_size = get_screen_size()
print(real_resolution)
print(screen_size)

screen_scale_rate = round(real_resolution[0] / screen_size[0], 2)
print(screen_scale_rate)
```
- 多屏的分辨率获取的方法。


```python
#屏幕的尺寸
# -*- coding: utf-8 -*-
"""
功能：识别两块显示器各自的分辨率
"""
"""模块导入"""
from win32api import GetSystemMetrics
from win32con import SM_CMONITORS, SM_CXVIRTUALSCREEN, SM_CYVIRTUALSCREEN

def Display_Detection():
    # 显示器数量检测
    MonitorNumber = GetSystemMetrics(SM_CMONITORS)
    # 主屏幕尺寸检测
    MajorScreenWidth = GetSystemMetrics(0)  # 主屏幕宽
    MajorScreenHeight = GetSystemMetrics(1)  # 主屏幕高
    # print("主屏幕尺寸：", GetSystemMetrics(0), "*", GetSystemMetrics(1))
    # 屏幕最大尺寸
    aScreenWidth = GetSystemMetrics(SM_CXVIRTUALSCREEN)  # 屏幕最大宽度
    aScreenHeight = GetSystemMetrics(SM_CYVIRTUALSCREEN)  # 屏幕最大高度
    AllScreen=(aScreenWidth, aScreenHeight)
    # print("屏幕总尺寸:", aScreenWidth, "*", aScreenHeight)
    # 当前主流的分辨率基数是宽，偶数是高
    ResolvingPower = [1280, 720, 1920, 1080, 2560, 1440, 3840, 2160, 4096, 2160, 7680, 4320]

    if MonitorNumber > 1:  # 屏幕数量判断print(MonitorNumber)就可以知道有多少块屏幕
        SecondaryScreenWidth = aScreenWidth - MajorScreenWidth  # 副屏宽=总屏幕宽-当前屏幕宽
        print("副屏宽",SecondaryScreenWidth)

        # 主屏横竖屏检测
        if GetSystemMetrics(0) > GetSystemMetrics(1):
            MianScreen = (GetSystemMetrics(0), GetSystemMetrics(1))
            print("主屏(横屏)尺寸：", GetSystemMetrics(0), "*", GetSystemMetrics(1))
        else:
            MianScreen = (GetSystemMetrics(0), GetSystemMetrics(1))
            print("主屏(竖屏)尺寸：", GetSystemMetrics(0), "*", GetSystemMetrics(1))

        # 横屏状态
        for i in range(0, len(ResolvingPower) - 1, 2):
            # print("i",ResolvingPower[i])
            if SecondaryScreenWidth == ResolvingPower[i]:
                SecondaryScreen = (ResolvingPower[i], ResolvingPower[i + 1])
                print("副屏(横屏)尺寸：", ResolvingPower[i], ResolvingPower[i + 1])
                # return "副屏(竖屏)尺寸：",SecondaryScreen
                break
        # 竖屏状态
        for i in range(1, len(ResolvingPower) - 1, 2):
            # print("i",ResolvingPower[i])
            if SecondaryScreenWidth == ResolvingPower[i]:
                SecondaryScreen = (ResolvingPower[i], ResolvingPower[i + 1])
                print("副屏(竖屏)尺寸：", ResolvingPower[i], ResolvingPower[i - 1])
                # return "副屏(竖屏)尺寸",SecondaryScreen
                break
    return MonitorNumber,AllScreen,MianScreen,SecondaryScreen

#调用
a=Display_Detection()
print(a)#a可以任意遍历其中的内容a[0]代表屏幕数量等等...

主屏(横屏)尺寸： 1920 * 1080
副屏(竖屏)尺寸： 1440 2560
(2, (3360, 1080), (1920, 1080), (1440, 3840))
```