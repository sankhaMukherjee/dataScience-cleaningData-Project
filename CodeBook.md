#Code Book

This file describes the data, the files associated with this exercise, and the output. Apart from the files corresponding to the project, the following files have been generated:

 - "CodeBook.md" : This file
 - "analysis.R"  : The R program file for doing the analysis
 - "README.md"   : The file describing all the variables

## Description of the Raw Data 
The raw data is extracted within the folder `UCI HAR Dataset`. This is the root folder for the data. Within the dataset, there are a number of files and folders. Of all the files, some of the files are of interst. They will be grouped into logical categories:

Data belonging to all subgroups:

  -  "features.txt"
  -  "activity_labels.txt"

This data belongs to the *test* data set. 
 	
| file name               |  description                                                             |
|-------------------------|:-------------------------------------------------------------------------|
| "test/X_test.txt"       | `n` observations (each observation is a vector of 561 dimensions)        |
| "test/y_test.txt"       |  lables (a number/observation [1-6] representing what the user is doing) |
| "test/subject_test.txt" |  subject id / observation                                                |

Then, there is the *training* data set. 
 	
| file name                       |  description                                                             |
|---------------------------------|:-------------------------------------------------------------------------|
| "train/X_train.txt"       | `n` observations (each observation is a vector of 561 dimensions)        |
| "train/y_train.txt"       |  lables (a number/observation [1-6] representing what the user is doing) |
| "train/subject_train.txt" |  subject id / observation                                                |

## The Variables & Functions

The following contains the different variables used in the program. 

### The `features` variable:
This is the variable used for describing the data vector elements. This is simply read from the file named "features.txt", and the second column containing the name of the variable is converted into a `character vector`. The characters `(`, `)`, and `,` dont seem to work well as column names, and hence these are removed from the character vector. 

### The `activityLabels` variable:
This is a data frame containing the name of the activity label corresponding to its particular activity. The `colnames` are subsequently named `id` and `label` respectively so that it is easy to identify the data columns, although, truth be told, the names are relatively easy to understand.

### The `createDataSet()` function:
This function does all the hard work of converting the data into managable data frames as output. Remember that we only need the mean and the standard deviations of the different variables. Hence, there is no point keeping a whole lot of information in memory. This function not only reads a data file, but also filters out the rows contianing only the mean and standard deviations of the dataset.  

This function takes a filename for the dataset we want to work on, and returns the dataframe with only columns containing mean and the standard deviations in them. This way, the dataframe will not contain a lot of frivolous data. The information required for the function are the following:

 - `dataFile`: This is the name of the file containing the vectors of the movement
 - `labelFile`: This is a file containing the activity label for each of the vectors provided corresponding to the activity performed.
 - `subjectFile`: This file corresponds to the subject id of the person performing the activity
 - `features`: these are the names of the different elements of the vector available within the data file 
 - `activityLables`: this is the dataframe that associates an activity id to an activity. (e.g. `WALKING` has an i.d.of `1`).

 The `dataFile`, `labelFile`, and `subjectFile` correspond directly to the three files listed in the table for the training and test sets mentioned in the Section *Description of the Raw Data*. 
 
The function performs the following transformations:

1. It reads the data within the `dataFile` into a data frame called `data`. The column names are named appropriately by directly supplying the `features` vector as the `col.name` option. 
2. It finds a subset of features containing the names `mean`, `std` and `Mean` within the column names, and this vector is called `selectFeatures`.
3. It extracts the `selectFeatures` columns out of data and renames this pruned dataset `data`.
4. It read `labelFile` and converts the numbers within the read `numeric` vector into a `character` vector according to the assignment provided by `activityLabels`. It then adds this vector into the `data` data frame as a new column named `activity`.
5. It reads `subjectFile` and converts the data into a `numeric` vector. It then adds this into the `data` data frame as a new column named `subjects`.
6. It returns the data frame `data`


### The `test`, `train`, and `total` variables
The `test` and the `train` variables contain datasets returned by the `createDataSet()` function when files from the "test" and "train" directories respectively are supplied to it. Then, these two dataframes are combined into a single data frame using the `rbind()` function to create the `total` data frame. 

### The `summary` variable

This data frame summarizes the data as required by the project.  

## Output Files

In this project, only two output files are present.

 - "total.csv": contains the CSV representation of the `total` data frame
 - "summary.csv": contains the CSV representation of the `summary` data frame. 

