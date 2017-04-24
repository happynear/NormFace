# Mirror Face

Mirror face is the most effective prior for face image analysis. 
It computes the frontal face and mirror face simultaneously and merge the two features together as the final feature.

Mirror face can be trained in an end-to-end manner.
However, I find it has no help on **training** face verification models.
It can improve the performance of face identification, but when I applied it on face verification, the accuracy even decreased:(

Here are the accuracies using [Wen's model](https://github.com/ydwen/caffe-face) with different feature merging strategy.
We didn't put this table into our paper because we thought this was only a trick.

| PCA? | Front only  | Concatenate | Element-wise SUM | Element-wise MAX |
| ---- |:-----------:|:-----------:|:----------------:|:----------------:|
| No   | 98.5%       |98.53%       |98.63%            |98.67%            |
| YES  | 98.8%       |98.92%       |98.93%            |98.95%            |

With my model:

| PCA? | Front only  | Concatenate | Element-wise SUM | Element-wise MAX |
| ---- |:-----------:|:-----------:|:----------------:|:----------------:|
| No   | 98.77%      |99.03%       |99.02%            |99%               |
| YES  | 98.96%      |99.17%       |99.2167%          |99.2167%          |
