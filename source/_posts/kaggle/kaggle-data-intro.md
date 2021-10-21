---
title: Sartorius竞赛数据说明
tags: kaggle
categories: kaggle
date: 2021-10-21 17:37:18
---

> 数据说明

Data Description

In this competition we are segmenting neuronal cells in images. The training annotations are provided as run length encoded masks, and the images are in PNG format. The number of images is small, but the number of annotated objects is quite high. The hidden test set is roughly 240 images.

**Note: while predictions are not allowed to overlap, the training labels are provided in full (with overlapping portions included). This is to ensure that models are provided the full data for each object. Removing overlap in predictions is a task for the competitor.**

## Files

**train.csv** - IDs and masks for all training objects. None of this metadata is provided for the test set.

- `id` - unique identifier for object
- `annotation` - run length encoded pixels for the identified neuronal cell
- `width` - source image width
- `height` - source image height
- `cell_type` - the cell line
- `plate_time` - time plate was created
- `sample_date` - date sample was created
- `sample_id` - sample identifier
- `elapsed_timedelta` - time since first image taken of sample

**sample_submission.csv** - a sample submission file in the correct format

**train** - train images in PNG format

**test** - test images in PNG format. Only a few test set images are available for download; the remainder can only be accessed by your notebooks when you submit.

**train_semi_supervised** - unlabeled images offered in case you want to use additional data for a semi-supervised approach.

**LIVECell_dataset_2021** - A mirror of the data from [the LIVECell dataset](https://github.com/sartorius-research/LIVECell). LIVECell is the predecessor dataset to this competition. You will find extra data for the `SH-SHY5Y` cell line, plus several other cell lines not covered in the competition dataset that may be of interest for transfer learning.

