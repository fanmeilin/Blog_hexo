---
title: 图像合成视频
tags: python
categories: python
date: 2021-10-30 09:50:29
---

> 在微生物项目中，需要将视频中的微生物检测识别出来，并且生成视频的格式保存，其中需要将检测的annotation图片合成为视频格式。**大致流程：使用cv库，首先读取图片，resize到指定大小，存储到Video实例中；**

> OpenCV 底层是用 FFMEPG 进行多媒体开发的，所以 OpenCV 它的长项不在于此，它只是提供了这种能力而已，如果要针对多媒体文件做复杂的处理，推荐的还是 FFMEPG 专业库。OpenCV 用来创建视频文件的类是 VideoWriter。首先普及一些视频类相关的知识点。

## 视频有关知识

### 1. 文件后缀名

我们一般都知道视频文件是 .mp4、.3gp、.rmvb 等等格式的，但一个文件取这样的后缀名是为了告诉用户或者操作系统，它的内容是什么格式的。我们也可以将 rmvb 格式的文件取名为 ***.avi。后缀的目的是为了方便用专业的工具或者软件操作它们。

### 2. 文件格式

我们可以将一个视频文件看做一个容器。

简单地说就是可以看做是一个盒子。

**这个盒子里面有视频画面数据、音频数据、字幕数据等等。**

不同的文件格式如 mp4、avi、mkv 等等，它们存放 打包数据的方式不一样，文件内部文件编码方式也可能不一样。

### 3. 编码格式

视频容器中，一般有视频和音频数据，它们采取的编码方式不一样。

视频常见的编码方式通常有： x264、h264、mpeg-4

音频常见的编码方式通常有： mp3、AAC、flac

编码的目的主要是为了高效存储和传输，如果你不采用编码压缩的话，那么视频可以看做是一系列的图片序列，体积会非常大。

### 4. 编码器和解码器

把视频或者音频按照编码格式，编码成特定文件格式需要编码器的参与，不然每次开发重新写代码代价很高。

把特定文件格式解码成特定的编码格式数据，这个过程称为解码，需要解码器的存在。

解码器和编码器都有开源的或者收费的工具库，极大方便了开发者。

### 5. FPS 帧率

我们读初中物理时，大概了解过电影画面一秒钟 24 帧，其实对应的就是 24 fps，frame per second，有些手机有高速摄像的功能，原理就是能够 1 秒钟拍摄 960 张图片，然后用正常的速度放映出来，所以细节比较多。

fps 越高，细节越好，体验也越好，但是文件容量也越高。

## 函数原型 cv2.VideoWriter()

```python
VideoWriter(filename, fourcc, fps, frameSize[, isColor]) -> <VideoWriter object>
```

- filename:要保存的文件的路径
- fourcc: 指定编码器
- fps: 要保存的视频的帧率
- frameSize: 要保存的文件的画面尺寸
- isColor: 指示是黑白画面还是彩色的画面

### fourcc的设置

> fourcc意为四字符代码（Four-Character Codes），顾名思义，该编码由四个字符组成,下面是VideoWriter_fourcc对象一些常用的参数，注意：字符顺序不能弄混。

- cv2.VideoWriter_fourcc('D', 'I', 'V', 'X') 对应格式 mp4
- cv2.VideoWriter_fourcc('I','4','2','0')---未压缩的YUV颜色编码，4:2:0色度子采样。兼容性好，但文件较大，注意是很大。文件扩展名.avi。

- cv2.VideoWriter_focurcc('P','I','M','1')---MPEG-1编码类型。随机访问，灵活的帧率、可变的图像尺寸、定义了I帧、P帧和B帧、运动补偿可跨越多个帧、半像素精度的运动向量、量化矩阵、GOF结构、slice结构、技术细节、输入视频格式。文件扩展名.avi。

- cv2.VideoWriter_fourcc('X','V','I','D')---MPEG-4编码类型，视频大小为平均值，MPEG4所需要的空间是MPEG1或M-JPEG的1/10，它对运动物体可以保证良好的清晰度，间/时间/画质具有可调性。文件扩展名.avi。

- cv2.VideoWriter_fourcc('T','H','E','O')---OGGVorbis，音频压缩格式，有损压缩，类似于MP3等的音乐格式。兼容性差，文件扩展名为.ogv。

- **cv2.VideoWriter_focurcc('F','L','V','1')---FLV是FLASH VIDEO的简称，FLV流媒体格式是一种新的视频格式。**由于它形成的文件极小、加载速度极快，使得网络观看视频文件成为可能，它的出现有效的解决了视频文件导入Flash后，使导出的SWF文件体积庞大，不能在网络上很好的使用等缺点。文件扩展名为.flv

视频编码方式还有很多，具体可参考http://www.fourcc.org/codecs.php。

## 实现代码

flv2jpg.py:切分视频，按照指定帧频率保存图片。

```python
import cv2
import os
def flv2jpg(videopath, mytimeF=1, save_flag = False):
    """
    将flv格式视频每隔mytimeF个帧保存一张图片
    :param videopath: 存储flv视频的文件夹
    :param mytimeF: 间隔帧数
    :return:
    """
    save_dir = os.path.join(os.path.dirname(videopath), "images")
    os.makedirs(save_dir, exist_ok=True)
    num = 1  # 保存图片计数
    print(videopath)
    vc = cv2.VideoCapture(videopath)
    if vc.isOpened():
        rval, frame = vc.read()
    else:
        rval = False
    timeF = mytimeF  # 每隔mytimeF帧
    count = 1  # 帧计数
    while rval:
        rval, frame = vc.read()
        if count % timeF == 0 and frame is not None:
            print("current frame count:", count)
            print("num:", num)

            if save_flag:
                save_path = os.path.join(save_dir, str(num) + "_" + videopath.split("/")[-1] + ".jpg")
                cv2.imwrite(save_path, frame)
                print(save_path)
                num += 1
        count += 1
    vc.release()
    return save_dir


if __name__ == "__main__":
    test_video = "./data/lunchong3.flv"
    flv2jpg(test_video,save_flag=True)

```

main.py ：保存处理后的视频

```python
from flv2jpg import flv2jpg
import cv2
import os,glob
from detectInfo import Detect_img
def makeVideo(Video_img_list,fps,size,save_dir):
    """
    func:由切分好的视频帧图像得到检测后的视频
    input: 待合成的图片list，视频的fps，size设置 视频保存路径
    return: 无返回
    """
    # video = cv2.VideoWriter(save_dir, cv2.VideoWriter_fourcc('I', '4', '2', '0'), fps, size)
    video = cv2.VideoWriter(save_dir, cv2.VideoWriter_fourcc(*'mp4v'), fps, size)

    for img in Video_img_list:
        img = cv2.resize(img, size)  # 将图片转换为1280*720
        video.write(img)

def detectVideo(test_video_path,detect_img,fps=24,size=(640,480),sift_thres = 0.5):
    """
    将输入的视频，切分图像，使用模型检测，返回合成的视频结果
    Args:
        test_video_path: 视频路径 
        detect_img: 模型实例
        fps: 视频帧
        size: 视频图像大小
        sift_thres: 筛选显示的检测阈值

    Returns: None

    """
    img_root = flv2jpg(test_video_path,save_flag=True) #读取路径
    save_dir_anno = os.path.join(os.path.dirname(test_video_path),"annotation/")
    #获取批量数据的检测信息
    Video_img_list = detect_img.get_info(source=img_root, save_img=True, save_dir=save_dir_anno,sift_thres=sift_thres)
    save_dir = os.path.join(os.path.dirname(test_video_path),"VideoDetect.mp4")
    makeVideo(Video_img_list, fps, size, save_dir)


if __name__ == "__main__":
    detect_img = Detect_img(weights="./weights/best.pt")
    test_video_path = "./data/lunchong3.flv"
    detectVideo(test_video_path, detect_img, fps=120, size=(640, 480), sift_thres=0)
```

## YoLov5中的实现

实际上在yolov5的detect脚本中，包含了处理输入为视频格式文件的检测代码，可以直接使用。

### 相关代码

```python
datasets.py
class LoadImages:  # for inference
    def __init__(self, path, img_size=640, stride=32):
        p = str(Path(path).absolute())  # os-agnostic absolute path
        if '*' in p:
            files = sorted(glob.glob(p, recursive=True))  # glob
        elif os.path.isdir(p):
            files = sorted(glob.glob(os.path.join(p, '*.*')))  # dir
        elif os.path.isfile(p):
            files = [p]  # files
        else:
            raise Exception(f'ERROR: {p} does not exist')

        images = [x for x in files if x.split('.')[-1].lower() in img_formats]
        videos = [x for x in files if x.split('.')[-1].lower() in vid_formats]
        ni, nv = len(images), len(videos)

        self.img_size = img_size
        self.stride = stride
        self.files = images + videos
        self.nf = ni + nv  # number of files
        self.video_flag = [False] * ni + [True] * nv
        self.mode = 'image'
        if any(videos):
            self.new_video(videos[0])  # 如果为路径则读取打开视频
        else:
            self.cap = None
        assert self.nf > 0, f'No images or videos found in {p}. ' \
                            f'Supported formats are:\nimages: {img_formats}\nvideos: {vid_formats}'

    def __iter__(self):
        self.count = 0
        return self

    def __next__(self):
        if self.count == self.nf:
            raise StopIteration
        path = self.files[self.count]

        if self.video_flag[self.count]:
            # Read video
            self.mode = 'video'
            ret_val, img0 = self.cap.read() #按帧读取视频，ret,frame是获cap.read()方法的两个返回值。其中ret是布尔值，如果读取帧是正确的则返回True，如果文件读取到结尾，它的返回值就为False。frame就是每一帧的图像，是个三维矩阵。
            if not ret_val:
                self.count += 1
                self.cap.release()
                if self.count == self.nf:  # last video
                    raise StopIteration
                else:
                    path = self.files[self.count]
                    self.new_video(path) 
                    ret_val, img0 = self.cap.read()

            self.frame += 1
            # print(f'video {self.count + 1}/{self.nf} ({self.frame}/{self.frames}) {path}: ', end='')

        else:
            # Read image
            self.count += 1
            img_path_code = np.fromfile(path, dtype=np.uint8)  # 含有中文路径时
            img0 = cv2.imdecode(img_path_code,1)  # path，，，，BGR
            assert img0 is not None, 'Image Not Found ' + path
            # print(f'image {self.count}/{self.nf} {path}: ', end='')

        # Padded resize
        img = letterbox(img0, self.img_size, stride=self.stride)[0]

        # Convert
        img = img[:, :, ::-1].transpose(2, 0, 1)  # BGR to RGB and HWC to CHW
        img = np.ascontiguousarray(img)

        return path, img, img0, self.cap

    def new_video(self, path):
        self.frame = 0
        self.cap = cv2.VideoCapture(path) #VideoCapture()中参数是0，表示打开笔记本的内置摄像头，参数是视频文件路径则打开视频
        self.frames = int(self.cap.get(cv2.CAP_PROP_FRAME_COUNT))

    def __len__(self):
        return self.nf  # number of files
```

detect.py中涉及视频的处理代码：在上述的loaddata中的cap.read()会默认得到的帧图像为640*480，可以使用cap.get()函数得到视频相关属性，使用cap.set()函数设置3，4id的参数值（3，4对应的是宽高属性）

> cv2.VideoCapture().set(propId, value)
> 功能：设置摄像头
> 参数：propId：设置的视频参数，
> 　　　　　　　类型：整数，
> 　　　　　　　可以参考 ：cv2.VideoCapture().get()中的参数
> 　　　　　　　value： 设置的参数
> 返回值：bool值：
> 　　　　true:不能确保摄像头已接受属性值
> 　　　　flase:摄像头未接受属性值
>
> 举例：
> cap.set(3, 480)
> 参数：3：在视频流的帧的宽度
> 　　　480：高度的数值
> 功能：把视频流的帧(图片)的宽度调成480
>
> cap.set(4, 480)
> 参数：4：在视频流的帧的高度
> 　　　480：宽度的数值
> 功能：把视频流的帧(图片)的高度调成480

| param                    | define                                                       |
| ------------------------ | ------------------------------------------------------------ |
| cv2.VideoCapture.get(0)  | CV_CAP_PROP_POS_MSEC 视频文件的当前位置（播放）以毫秒为单位  |
| cv2.VideoCapture.get(1)  | CV_CAP_PROP_POS_FRAMES 基于以0开始的被捕获或解码的帧索引     |
| cv2.VideoCapture.get(2)  | CV_CAP_PROP_POS_AVI_RATIO 视频文件的相对位置（播放）：0=电影开始，1=影片的结尾。 |
| cv2.VideoCapture.get(3)  | CV_CAP_PROP_FRAME_WIDTH 在视频流的帧的宽度                   |
| cv2.VideoCapture.get(4)  | CV_CAP_PROP_FRAME_HEIGHT 在视频流的帧的高度                  |
| cv2.VideoCapture.get(5)  | CV_CAP_PROP_FPS 帧速率                                       |
| cv2.VideoCapture.get(6)  | CV_CAP_PROP_FOURCC 编解码的4字-字符代码                      |
| cv2.VideoCapture.get(7)  | CV_CAP_PROP_FRAME_COUNT 视频文件中的帧数                     |
| cv2.VideoCapture.get(8)  | CV_CAP_PROP_FORMAT 返回对象的格式                            |
| cv2.VideoCapture.get(9)  | CV_CAP_PROP_MODE 返回后端特定的值，该值指示当前捕获模式      |
| cv2.VideoCapture.get(10) | CV_CAP_PROP_BRIGHTNESS 图像的亮度(仅适用于照相机)            |
| cv2.VideoCapture.get(11) | CV_CAP_PROP_CONTRAST 图像的对比度(仅适用于照相机)            |
| cv2.VideoCapture.get(12) | CV_CAP_PROP_SATURATION 图像的饱和度(仅适用于照相机)          |
| cv2.VideoCapture.get(13) | CV_CAP_PROP_HUE 色调图像(仅适用于照相机)                     |
| cv2.VideoCapture.get(14) | CV_CAP_PROP_GAIN 图像增益(仅适用于照相机)（Gain在摄影中表示白平衡提升） |
| cv2.VideoCapture.get(15) | CV_CAP_PROP_EXPOSURE 曝光(仅适用于照相机)                    |
| cv2.VideoCapture.get(16) | CV_CAP_PROP_CONVERT_RGB 指示是否应将图像转换为RGB布尔标志    |
| cv2.VideoCapture.get(17) | CV_CAP_PROP_WHITE_BALANCE × 暂时不支持                       |
| cv2.VideoCapture.get(18) | CV_CAP_PROP_RECTIFICATION 立体摄像机的矫正标注（目前只有DC1394 v.2.x后端支持这个功能） |

| capture.set                                 | 作用                   |
| ------------------------------------------- | ---------------------- |
| capture.set(CV_CAP_PROP_FRAME_WIDTH, 1080); | 宽度                   |
| capture.set(CV_CAP_PROP_FRAME_HEIGHT, 960); | 高度                   |
| capture.set(CV_CAP_PROP_FPS, 30);           | 帧率 帧/秒             |
| capture.set(CV_CAP_PROP_BRIGHTNESS, 1);     | 亮度                   |
| capture.set(CV_CAP_PROP_CONTRAST,40)        | 对比度 40              |
| capture.set(CV_CAP_PROP_SATURATION, 50);    | 饱和度 50              |
| capture.set(CV_CAP_PROP_HUE, 50);           | 色调 50                |
| capture.set(CV_CAP_PROP_EXPOSURE, 50);      | 曝光 50 获取摄像头参数 |

### 具体代码

```python
        # Set Dataloader
        vid_path, vid_writer = None, None
        if webcam:
            view_img = check_imshow()
            cudnn.benchmark = True  # set True to speed up constant image size inference
            dataset = LoadStreams(source, img_size=imgsz, stride=stride)
        else:
            dataset = LoadImages(source, img_size=imgsz, stride=stride)

        for path, img, im0s, vid_cap in tqdm(dataset): #一个batch的信息
            img_path_list.append(path)
            img = torch.from_numpy(img).to(device)
            img = img.half() if half else img.float()  # uint8 to fp16/32
            img /= 255.0  # 0 - 255 to 0.0 - 1.0
            if img.ndimension() == 3:
                img = img.unsqueeze(0)

            # Inference
            t1 = time_synchronized()
            pred = model(img, augment=augment)[0]

            # Apply NMS
            pred = non_max_suppression(pred, conf_thres, iou_thres, classes, agnostic_nms, max_det=max_det)
            t2 = time_synchronized()

            # Process detections
            # imgbox_list = [] #一张图的box信息
            Vorticella_list = []
            Rotifera_list = []


            for i, det in enumerate(pred):  # detections per image 一张图信息
                if webcam:  # batch_size >= 1
                    p, s, im0, frame = path[i], f'{i}: ', im0s[i].copy(), dataset.count
                else:
                    p, s, im0, frame = path, '', im0s.copy(), getattr(dataset, 'frame', 0) 
                s += '%gx%g ' % img.shape[2:]  # print string
                p = Path(p)  # to Path
                save_path = save_dir+p.name # img.jpg
                if len(det):
                    # Rescale boxes from img_size to im0 size
                    # 调整预测框的坐标：基于resize+pad的图片的坐标-->基于原size图片的坐标
                    # 此时坐标格式为xyxy
                    det[:, :4] = scale_coords(img.shape[2:], det[:, :4], im0.shape).round()

                    # Print results
                    for c in det[:, -1].unique():
                        n = (det[:, -1] == c).sum()  # detections per class
                        s += f"{n} {names[int(c)]}{'s' * (n > 1)}, "  # add to string
                    # ["Vorticella", "Rotifera"]
                    # Write results
                    # for *xyxy, conf, cls in reversed(det):
                    for *xyxy, conf, cls in det: #置信度从大到小 #图中的所有框信息
                        xywh_no_norm = xyxy2xywh(torch.tensor(xyxy).view(1, 4)).view(-1).tolist()
                        box = (cls, xywh_no_norm, conf) #存储类别 xywh 置信度
                        if(conf<sift_thres):continue #过滤置信度小于0.7的框
                        if(cls==0):
                            Vorticella_list.append(box)
                        elif(cls==1):
                            Rotifera_list.append(box)
                        # imgbox_list.append(box)
                        c = int(cls)  # integer class
                        label = f'{names[c]} {conf:.2f}'
                        plot_one_box(xyxy, im0, label=label, color=colors(c, True), line_thickness=3)

                # Save results (image with detections)
                if save_img:
                    if dataset.mode == 'image':
                        cv2.imwrite(save_path, im0)
                    else:  # 'video' or 'stream'
                        if vid_path != save_path:  # new video
                            vid_path = save_path
                            if isinstance(vid_writer, cv2.VideoWriter):
                                vid_writer.release()  # release previous video writer
                            if vid_cap:  # video
                                fps = vid_cap.get(cv2.CAP_PROP_FPS) #获取原始视频的帧率
                                # w = int(vid_cap.get(cv2.CAP_PROP_FRAME_WIDTH)) #获取原始视频帧宽
                                # h = int(vid_cap.get(cv2.CAP_PROP_FRAME_HEIGHT)) #获取原始视频的高
                                w, h =  im0.shape[1], im0.shape[0] #更新为原始图像的宽高
                            else:  # stream
                                fps, w, h = 30, im0.shape[1], im0.shape[0]
                                # save_path += '.mp4'
                                save_path += '.flv'
                            # vid_writer = cv2.VideoWriter(save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))

                            vid_writer = cv2.VideoWriter(save_path, cv2.VideoWriter_fourcc('F', 'L', 'V', '1'), fps, (w, h))
                        vid_writer.write(im0)
```

