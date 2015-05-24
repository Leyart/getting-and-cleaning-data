Code Book
========

Raw data collection
-------------------

### Collection

Raw data are obtained from UCI Machine Learning repository. In particular we used
the *Human Activity Recognition Using Smartphones Data Set* [[1](#uci-har)],
that was used by the original collectors to conduct experiments exploiting
Support Vector Machine (SVM), as described in [[2](#har-smart)].

### Signals

The 3-axial time domain signals from accelerometer and gyroscope
were captured at a constant rate of 50 Hz and filtered to remove noise.
The acceleration signal was then separated into body and gravity
acceleration signals using another filter.
The body linear acceleration and angular velocity were derived in time
to obtain Jerk signals. The magnitude of these
three-dimensional signals were calculated using the Euclidean norm.
A Fast Fourier Transform (FFT) was applied to some of these
time domain signals to obtain frequency domain signals.

The signals were sampled in fixed-width sliding windows of 2.56 sec and 50%
overlap (128 readings/window at 50 Hz).
From each window, a vector of features was obtained by calculating variables
from the time and frequency domain.

No unit of measures is reported as all features were normalized and bounded
within [-1,1].

Data transformation
-------------------

The raw data sets are processed with run_analisys.R script to create a tidy data
set.

### Merging training and test dataset into a unique dataset

Test and training data (X_train.txt, X_test.txt), subject ids (subject_train.txt,
subject_test.txt) and activity ids (y_train.txt, y_test.txt) are merged to obtain
a single data set. Variables are labelled with the names assigned by original the
original authors (found at features.txt).

### Mean and standard deviation extraction

From the unique dataset that has been created an intermediate dataset with only
the values of the estimated mean (variables with labels that contain "mean") and
standard deviation (variables with labels containing "std") are retrieved.
This is accomplished by filtering the original dataset with a logical vector
created column-wise using grepl on the aforementioned strings, keeping the Subject
and the ActivityId also to not lose information regarding the user wearing the device
and his/her activities.

### Meaningful activity names

A new column with textual activity names describing the activity has been added
by looking up the descriptions in activity_labels.txt and matching it against the
Activity id column.

### Refining label names

Labels given from the original collectors were changed:
* to obtain valid R names without parentheses, dashes and commas
* to obtain more descriptive labels

### Create a tidy data set

From the intermediate data set is created a final tidy data set where numeric
variables are averaged for each activity and each subject.

Each row of the tidy dataset is composed by

*  An activity label (__Activity__) with possible values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
*  The identifier of the subject who carried out the experiment (__Subject__)
*  a feature vector with time and frequency domain signal variables that has been extracted from the dataset (numeric)

The data set is finally written to the file "tidyDataset.txt".

References
----------

1.  <a name="uci-har"/>Human Activity Recognition Using Smartphones Data Set.
    URL: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>. Accessed 05/24/2015
2. <a name="har-smart"/>Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
   *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*.
   International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
