# Evaluation on Youtube Face(YTF)

1. First of all, we need to create the folder structure. Use function `image_list = get_image_list_in_folder(YTF_FOLDER)` to get all the images in `YTF_FOLDER`.
Then use `create_folder_map.m` to create the file-to-folder map. It is recommended to save the `image_list` and `subset_map` variables to a .mat file.

2. Extract the features via `extract_feature.m`.

3. Get the accuracy by `compare_feature.m`.

4. Get the accuracy of Histogram Intersection Kernel Support Vector Machine(HIK-SVM) by `test_label_distribution.m`.
