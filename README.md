# Implementing Natural Language Processing to Explore the Lens of News Media


## Project Description

Here you find all the accompanying code for the exam project in the course *Introduction to Cultural Data Science*
in the autumn of 2021 at the University of Aarhus.

The aim of the project is to investegate the lens of news media by using natural
language processing on a large corpus of news articles. I use named entity recognition and sentiment analysis. 

Future implementations could be topic modelling and an analysis by gender. 
It would also be useful to incorporate a non-western newspaper such as Al Jazeera.   

## Files in the Repository

### Reproducibility Notebook
The most relevant file in the repository is the *Reproducibility Notebook*. 
This file presents all the accompanying code as a notebook using r-markdown and the package bookdown. 
There are two options to view the reproducibility notebook:

1. The slow but more robust option: First, clone the repository to a local repository. Then navigate to the folder named
*_book* and open the file named *index.html*. I open the file in Google Chrome and it runs smoothly. 
2. The quick but slightly buggy option: Simply go to the webpage: https://htmlpreview.github.io/?https://raw.githubusercontent.com/ah140797/news_media_NLP/master/_book/index.html


### Other files
You will also find 23 r-markdown scripts named through *01_*, *02_* etc. Each script
corresponds to a chapter in the reproducibility notebook. 

You will also find the following folders:

* *_book* which contains a ton of files for producing the reproduciblity notebook.
* *data/* which contains all the data and a metadata-file with a brief description of all the datasets.
* *figures/* which contains all the figures produced in R.
* *images/* which contains the images that are used inside the reproducibility notebook.
* *python_scripts/* which contains all the python scripts in the format of Jupyter Notebook. It also contains all the data necessary to run the python code.
* *shinyapp/* which contains all the scripts and data for running the shinyapp. 

## How to Run the Project

Running the project requires some programming languages and integrated development enviroments (IDE). 
The programming languages in the project are Python and R.
The IDE's in the project are Jupyter Notebook (which runs in the enviroment of Anaconda) and RStudio. 







