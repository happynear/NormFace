# NormFace
NormFace: L2 HyperSphere Embedding for Face Verification

https://arxiv.org/abs/1704.06369

| Baseline Model      | Original Accuracy | Finetune Using Normalization |
| ------------------- |:-----------------:|:----------------------------:|
| [Light CNN(MaxOut)](https://github.com/AlfredXiangWu/face_verification_experiment)   | 98.41%\*          |98.78%                        |
| [Center Face(ResNet)](https://github.com/ydwen/caffe-face) | 99.03%            |99.21%                        |

\* It is 98.13% on [Light CNN's project page](https://github.com/AlfredXiangWu/face_verification_experiment). After applying [the mirror face trick](./MirrorFace.md), it becomes 98.41%.

# Requirements

1. My Caffe (https://github.com/happynear/caffe-windows/tree/ms). It also works on Linux. Anyway, if you want to use your own Caffe, please transplant the `inner_product_layer`, `inner_distance_layer`, `normalize_layer`, `general_contrastive_layer`, `flip_layer`, `softmax_layer` and `accuracy_layer` to your Caffe. Since there are too many layers to transplant, I suggest you to use my Caffe directly:)
2. Matlab to draw some figures.
3. GPU with CUDA support.
4. MTCNN face and facial landmark detector(https://github.com/kpzhang93/MTCNN_face_detection_alignment).
5. Baseline model such as [Center Face](https://github.com/ydwen/caffe-face) or [Light CNN](https://github.com/AlfredXiangWu/face_verification_experiment) or your own model trained by softmax loss. I don't know whether my loss helps or not if your model is trained by other loss functions. You may have a try. I believe it will be effective if there is no normalization term in your model.

# Train

1. The dataset used in this paper is [CASIA-Webface](http://www.cbsr.ia.ac.cn/english/CASIA-WebFace-Database.html). Note that there are 3 identities overlap between CASIA-Webface and LFW. They are `0166921`, `1056413` and `1193098`. For fair evaluation, it is recommended to remove them from CAISA-Webface. 
2. Align all face images using MTCNN. The script can be found in [my another github repository](https://github.com/happynear/FaceVerification/blob/master/dataset/general_align.m).
3. Replace the final inner-product layer and softmax layer with layers defined in [scaled_cosine_softmax.prototxt](./prototxt/scaled_cosine_softmax.prototxt) or [normalized_Euclidean_contrastive.prototxt](./prototxt/normalized_Euclidean_contrastive.prototxt).
4. **Fine-tune** the network based on the original model using a small learning rate, say 0.001 or 0.0001.

# Evaluation

Evaluation codes are in [my another github repository](https://github.com/happynear/FaceVerification). Please refer to the second paragraph of the Update section. 

A trick called mirror face is used during extracting the features. A sample code is in `./prototxt/example_of_mirror_face.prototxt`.

**About the mirror face:**  See [./MirrorFace.md](./MirrorFace.md)

**About the histogram feature for video face verification:** Details are in [./YTF](https://github.com/happynear/NormFace/tree/master/YTF).

# Trained Models

Light CNN B model(98.78%): [Google Drive](https://drive.google.com/open?id=0B0OhXbSTAU1HT3I5V3ZLd0JDaW8) or [Baidu Yun](https://pan.baidu.com/s/1gfklrrl).

ps: I used to get a model of 98.8%, but I lost it....

Center Face model(99.21%): [Google Drive](https://drive.google.com/open?id=0B0OhXbSTAU1HM2NWcWFiN2lvbTg) or [Baidu Yun](https://pan.baidu.com/s/1i4Q4vD7).

# License

This code is distributed under MIT LICENSE. The released models are only allowed for non-commercial use.

# Citation

If you find my paper or the codes useful in your research, please cite
```
@article{Wang2017NormFace,
Author = {Feng Wang and Xiang Xiang and Jian Cheng and Alan L. Yuille},
Title = {NormFace: L2 Hypersphere Embedding for Face Verification},
Year = {2017},
Eprint = {arXiv:1704.06369}
}
```

# Contact

Feng Wang [feng.wff(at)gmail.com], please replace (at) with @.
