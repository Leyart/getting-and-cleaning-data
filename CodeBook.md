Code Book
========

Raw data collection
-------------------

### Collection

The data used for the project are obtained from UCI Machine Learning repository and come from the *Human Activity Recognition Using Smartphones Data Set* that can be found
here  <a name="uci-har"/>Human Activity Recognition Using Smartphones Data Set. URL: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

#### Notes:
- Features are normalized and bounded within [-1,1]. *IMPORTANT* For this reason no unit of measurement is reported.
- Each feature vector is a row on the text file.
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units are rad/seg.
- A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: http://www.youtube.com/watch?v=XOEN9W05_4A


Data transformation
-------------------

In the following, a description of the steps performed to clean the dataset is provided

### Merging training and test dataset into a unique dataset

The first step was to merge together the training datasets by column,
thus adding all the features that were split into several files in a unique dataframe.
Cbinds calls were chained to merge training data (X_train.txt), subject ids (subject_train.txt),
and activity ids (y_train.txt) in a unique dataset.
The same operations are performed over the test datasets.
Finally the two datasets obtained by chaining training and test sets are merged by row
to create a unique dataset to be manipulated and filtered.
Variables are labelled with the names assigned by original the
original authors (defined in features.txt).

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
Activity id column. By using the make.names command it was ensured to assign to the
dataset only syntactically valid names consisting of letters, numbers and the dot or
underline characters and starts with a letter or the dot not followed by a number.

### Refining label names

Labels were changed to format them to R standards (removing commas, parenthesis and dashes) and make
them more user friendly. Moreover:

* The prefix `t` was rewritten into `TimeD`, to make it clear the feature corresponds to the time domain
* The prefix `f` was rewritten into `FreqD`, to make it clear the feature corresponds to the frequency domain
* BodyBody has been replaced by Body
* mean and std have been capitalized
* Acc and Mag has been changed into Acceleration and Magnitude
* Freq has been extended to Frequency

### Tidy Dataset Creation

Each row of the tidy dataset is composed by

*  __Subject__: The numeric id of the subject that performed the experiment
*  __Activity__: A textual label with possible values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
*  A 79-feature vector with time and frequency domain numeric features extracted from the datasets.

A final dataset is created by averaging each numeric feature for each activity and each subject.
Ddply with numcolwise(mean) applies the mean column by column for each numerical column
over the data grouped by Subject and Activity and then combines the result into a data frame.

The following table relates the 17 signals to the names used as prefix for the
variables names present in the data set. ".XYZ" denotes three variables, one for each axis.

Name                                  | Time domain                                 | Frequency domain
------------------------------------- | ------------------------------------------- | ------------------------------------------------
Body Acceleration                     | TimeDomain.BodyAcceleration.XYZ             | FrequencyDomain.BodyAcceleration.XYZ
Gravity Acceleration                  | TimeDomain.GravityAcceleration.XYZ          |
Body Acceleration Jerk                | TimeDomain.BodyAccelerationJerk.XYZ         | FrequencyDomain.BodyAccelerationJerk.XYZ
Body Angular Speed                    | TimeDomain.BodyAngularSpeed.XYZ             | FrequencyDomain.BodyAngularSpeed.XYZ
Body Angular Acceleration             | TimeDomain.BodyAngularAcceleration.XYZ      |
Body Acceleration Magnitude           | TimeDomain.BodyAccelerationMagnitude        | FrequencyDomain.BodyAccelerationMagnitude
Gravity Acceleration Magnitude        | TimeDomain.GravityAccelerationMagnitude     |
Body Acceleration Jerk Magnitude      | TimeDomain.BodyAccelerationJerkMagnitude    | FrequencyDomain.BodyAccelerationJerkMagnitude
Body Angular Speed Magnitude          | TimeDomain.BodyAngularSpeedMagnitude        | FrequencyDomain.BodyAngularSpeedMagnitude
Body Angular Acceleration Magnitude   | TimeDomain.BodyAngularAccelerationMagnitude | FrequencyDomain.BodyAngularAccelerationMagnitude

For variables derived from mean and standard deviation estimation, the previous labels
are augmented with the terms "Mean" or "StandardDeviation".

The data set is written to the file sensor_avg_by_act_sub.txt.


The data set is finally written to the file "tidyDataset.txt".
