# nlp-jupyter
Dockerfile for Jupyter notebook and Python NLP libraries for Japanese

## This image contains

* JUMAN++ 1.02
* JUMAN 7.01
* KNP 4.19
* PyKNP

* MeCab
* mecab-ipadic-neologd

* scikit-learn
* Gensim
* NLTK

## Usage 
To start jupyter notebook server, run this command in your terminal
```
sudo docker run -it --rm -p 8888:8888 -v ~/notebooks:/root/notebooks hamatani63/nlp-jupyter
```
then your noteboks will be saved at ~/notebooks.

To access the notebook, open this URL:
```
http://localhost:8888/?token=(input the generated token)
```
