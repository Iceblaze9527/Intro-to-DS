# Project Report
> 2016010829 Hu Yiju
> 2016010845 Wang Yuhan
> 2016013327 Xiang Yutong
> 2016010850 Xu Ming

> 2020.01.11

## 1. Project Background
### 1.1 Introduction
YouTube is the world-famous video sharing website, and it maintains a list of the top trending videos on the platform. To determine the year's top-trending videos, YouTube uses a combination of factors, including measuring users' number of views, shares, comments, and likes. This dataset is a daily record of the top trending YouTube videos.

### 1.2 Orientation
In this project, we're particularly interested trending videos in western English-speaking countries, i.e., **Canada, Great Britain, and the US**. We will walk through exploration descriptive analysis to draw some interesting conclusions from the data. Besides, based on this, we will try to use various machine learning methods to help predict titles (or popular words in titles) of trending videos.

## 2. Exploratory Data Analysis
### 2.1 Dataset Specification
Collected by the YouTube API, [this dataset](https://www.kaggle.com/datasnaek/youtube-new) comprises several months (and counting) of data on daily trending YouTube videos in different regions. Each region's data is in a separate CSV file with 16 columns, as shown below:

![01.png](https://i.loli.net/2020/01/09/djP5pyCWnuAG361.png)
Each CSV file includes a "category_id "field, which varies between regions and thus is stored in associated JSON files.

<img src = "https://i.loli.net/2020/01/09/qLzFIwMYmbhsoD4.png" width="60%">

### <span id = "2.2">2.2 Observations and Feature Selection</span>

16 columns give us 16 features, combined with "category "in CSV files. Yet, not all of them are useful or handy enough to be useful. Thus, feature selection is needed.

At first, we categorize these features by their types, namely, normal, ordinal, interval and ratio (``video_id`` is the primary key): 

statistical data type | features
--|--
nominal | ``title``, ``channel_title``, ``category``, ``tags``, ``thumbnail_link``, ``comments_disabled``, ``ratings_disabled``, ``video_error_or_removed``, ``description``
ordinal | ``trending_date``, ``publish_time``, 
interval | 
ratio | ``views``, ``likes``, ``dislikes``, ``comment_count``

As can be seen, nominal data "channel_title "and "catetory "give us two natural aggregation bases, which can be useful in EDA, where we can discuss which category is the most popular, etc.. 
``title``, ``tag``, and ``description`` may also be useful in deciding potential features that trending videos should have. Other data such as ``thumbnail_link``, ``comments_disabled``,``ratings_disabled``, ``video_error_or_removed`` are irrelevant to our analyses. 

Ordinal data are timestamps for videos. As videos can be on-trend for a period and numerical features accumulate through time, duplication removal is necessary, and thus these timestamps may not be useful. Only when one considers durations of trending somehow manifest popularity will they be contributory,  but that can be hazy and redundant, so the most time we can safely ignore them and just use them when showcasing some analytical results.

Numerical data that count reviews of the video are important in the EDA  process. They can be used to display how much a video (or aggregation, i.e., category and channel) is appreciated or depreciated, and their statistics can be correlated. Some EDA methods can be used to examine these traits.

The ``title`` feature is worth an extra mentioning. It is one of the most prominent features of a video, and most importantly, it is not an atomic feature; namely,  it can be seen as a combination of words, and every word can be a potential feature to determine the popularity of the video. Our predictive machine learning methods are all based on such observation.

In conclusion, the features can be classified into 4 groups, and further analyses are based on this classification:

index | feature
--|--
1|``channel_title``, ``category``
2|``views``, ``likes``, ``dislikes``, ``comment_count``
3|``publish_time``, ``trending_date``
4|``title``, ``tags``, ``description``

### 2.3 Data Preprocessing
As mentioned in [section 2.2](#2.2), we should do some preprocessing to make features more useful, which includes: 

#### 2.3.1 Datetime  Transformation
The timestamps can only be useful if they are in "python datetime "format, so a transformation is needed. Besides, it can also be dissected into ``date`` and ``time`` respectively to help give more insights.

#### 2.3.2 Category Names Combination
"catogory "can be useful, but data are stored aside in JSON files. So a combination is needed. We use mapping strategy to do this.

#### 2.3.3 Duplication Dropping
As videos can be on-trend for a period and numerical features accumulate through time, duplication removal is necessary. Thus it is more reasonable to keep the last record of each duplicated item.

### 2.4 EDA Technics
#### 2.4.1. Plots and Charts
Plots and Charts are the most common way to visualize data in EDA. The plot and chart forms used in our EDA process are listed as follows:
* ``count plot``: Show the counts of observations in each categorical bin using bars
* ``barplot``: a chart or graph that presents categorical data bars with heights or lengths proportional to the values that they represent.
* ``scatterplot``: type of plot or mathematical diagram using Cartesian coordinates to display values for typically two variables for a set of data
* ``piecharts``: a circular statistical graphic which is divided into slices to illustrate numerical proportion

#### 2.4.2 Correlation Matrix and Heat Map
The correlation matrix of $n$ random variables $X_{1},\ldots ,X_{n}$ is the $n\times n$ matrix whose $(i,j)$ entry is ${\displaystyle \operatorname {corr} (X_{i},X_{j})}$ .  In statistical modelling, correlation matrices representing the relationships between variables are categorized into different correlation structures, which are distinguished by factors such as the number of parameters required to estimate them. A heat map is a graphical representation of data where the individual values contained in a matrix are represented as colors.

#### 2.4.3 Word Cloud
Word cloud is a novelty visual representation of text data, typically used to depict keyword metadata (tags) on websites or to visualize free form text. Tags are usually single words, and the importance of each tag is shown with font size or color. This format is useful for quickly perceiving the most prominent terms to determine its relative prominence.

#### 2.4.4 Quartiles and IQR
Quantiles are cut points dividing the range of a probability distribution into continuous intervals with equal probabilities or dividing the observations in a sample in the same way. A quartile is a type of quantile which divides the number of data points into four more or less equal parts or quarters. The Interquartile Range (IQR) may be used to determine outliers in the case of quartiles:

$$\mathrm{IQR}=\mathrm{Q}_{3}-\mathrm{Q}_{1}\\
\text { Lower fence }=Q_{1}-1.5(\mathrm{IQR})\\
\text { Upper fence }=Q_{3}+1.5(\mathrm{IQR})$$

Where Q1 and Q3 are the first and third quartiles, respectively, the lower fence is the "lower limit," and the upper fence is the "upper limit" of data. Any data lying outside these defined bounds can be considered an outlier.

In this project, we use outliers defined by quartiles to determine the most popular videos (by their views), which we will use in the prediction process.

### 2.5 Questions & Insights for US dataset

Specifically, we used the US dataset as a representation, and we compared it with combined results from three countries. Based on the observations in  [section 2.2](#2.2), we classified our questions about the data into three groups:

* Trending Videos, Categories, and Channels
* Reviews Related
* Miscellaneous, including time, description, and tags.

#### 2.5.1 Trending Videos, Categories and Channels
Below are the results we get when ``views``,``categories``and ``channels`` are taken into consideration. 

1. *Top10 Most Trending Videos*
    | Channel Name | Title | Category |
    |---|---|---|
    | Lucas and Marcus  | WE MADE OUR MOM CRY...HER DREAM CAME TRUE!| Entertainment|
    | Charlie Puth| Charlie Puth - BOY [Official Audio] | Music |
    | Rooster Teeth| Rooster Teeth Animated Adventures - Millie So Serious | Film & Animation|
    | grav3yardgirl | Why I'm So Scared (being myself and crying too much) | Howto & Style |
    | SamSmithWorldVEVO | Sam Smith - Pray (Official Video) ft. Logic | Music |
    | Unbox Therapy | The ULTIMATE $30,000 Gaming PC Setup| Science & Technology |
    | Complex| YoungBoy Never Broke Again Goes Sneaker Shopping With Complex | Entertainment|
    | nigahiga | FORTNITE The Movie (Official Fake Trailer)| Entertainment|
    | Selena Gomez | Selena Gomez - Back To You (Lyric Video)| Film & Animation |
    | BostonDynamics | Getting some air, Atlas?  | Science & Technology |
    > As can be seen, quite a few trending videos are from the entertainment/Film & Animation/Music category, and many features 'official' in  their titles. We shall look for similar results in the following analyses.
    
2. *Top10 Most Trending Categories*
![1-2-2.png](https://i.loli.net/2020/01/11/KopRFnPZJ4I6miz.png)
    > The barplot shows that ``entertainment`` is the leading trending category on YouTube, twice the number of ``music`` which comes second.

3. *Top10 Most Trending Channels* : 
    ![1-2-3.png](https://i.loli.net/2020/01/11/RomCLaUbKY7GVcF.png)
    >  Among the top 5 channels, 3 (TheEllenShow , The Tonight Show and Jimmy  Kimmel Live) are talk show channels, all contributors to entertainment's category. Also, some sports channels (e.g., ESPN, NBA) and news channels (e.g., CNN, Vox) share some leading positions.

4. *Total & Average Views Of Trending Videos By Categories*
    ![1-2-4.png](https://i.loli.net/2020/01/11/VrU5GP7blCt2ogS.png)
    > Though entertainment may be the most common category of trending videos, it is music videos that share the most views, both in total and on average, far more than any other category. Also, because of this, entertainment videos fall to the 5th position when it comes to average views. On the contrary, though ``film & animation`` seems not as trending a category if we just consider video counts, it gets a surprising amount of views on average. The ``gaming`` category is also a black horse since it doesn't even rank the top 10 on trending categories while takes the 3rd place in average views.

5. *Total & Average Views Of Trending Videos By Channels*: 
    ![1-2-5.png](https://i.loli.net/2020/01/11/pd9r1WDVUoM6zQA.png)
    > Consistent with the results we have got before, music videos get most peeps among all categories, which is shown by reappearing 'VEVO's (VEVO is the world's largest all-premium music video provider) on the trending rank page. Except for Kylie Jenner, who shares beauty tutorials, all the channels that get most average views are music channels. However, channels that get most total views fall in various categories, like sports and entertainment.

#### 2.5.2 Reviews for Trendings
Below are the results we get when numerical features such as ``views``, ``likes``, ``dislikes``, and ``comment counts`` are taken into consideration. 

6. *Most Reviewed Videos, Likes & Dislikes Count*
    ![1-2-6.png](https://i.loli.net/2020/01/11/a2LHou8jbkZyKp1.png)
    > Again, consistent with the previous results, most reviewed videos are music videos, and they are generally appreciated, and they all received over 2 million likes/dislikes.

7. *Most Reviewed Categories, Likes & Dislikes Count*
    ![1-2-7.png](https://i.loli.net/2020/01/11/zkNFpQ14iEVvufr.png)
    > While music videos are the most viewed video category, ``non-profit/activism`` videos get most reviews among all, and also rank first in dislike rate. The total amount of likes is even less, maybe because it's a rather controversial and sensitive topic. These two categories, in total, get more reviews than the following eight. Also, the ``gaming`` category rank 3rd, being a black horse again. In contrast, the ``entertainment`` category, though generally appreciated by people, do not get so many reviews.

8. *Most Reviewed Channels, Likes & Dislikes Count*
    ![1-2-8.png](https://i.loli.net/2020/01/11/eh8d2VlmMX567DW.png)
    > Most channels reappear from the most viewed channels and get an equal amount of appreciation for their views. Some do get more dislikes than others.

9. *Video Views With Respect To Their Reviews Count, Likes & Dislikes*
    ![1-2-9.png](https://i.loli.net/2020/01/11/qsbn2Pi6oNJUdzT.png)
    > As can be seen, the more a video gets viewed in general, the more likes it will receive, and it's the same with dislikes, except that it grows far slower than likes. As for the outliers which receive unexpected views from the audience (points with biggest areas), they have a higher rate of receiving dislikes than those not-so-popular videos. Still, generally, the dislike rate remains small. Still, some poor videos are infamous for the vast dislikes they receive, constituting another outlier group.

10. *Correlation Between Views, Likes, Dislikes, and Comments*
    ![1-2-10.png](https://i.loli.net/2020/01/11/SEbFLprG38Bhf5K.png)
    > The correlation matrix gives a numerical explanation of previous results -- the more views the videos get, the more appreciation and depreciation they will receive (all entries are positive). Still, they tend to be more appreciated (0.85 > 0.47). The comment rate also goes up when there are more views, and it seems that positive ones take domination (0.8 > 0.7).

#### 2.5.3 Miscellaneous

Below are the results we get when ``time``, ``title``, ``tags``and ``descriptions`` are taken into consideration. 

11. *Best Time To Publish A Video In Order To Get Trending*
    Will the publish time in a day affect the popularity of the videos? We shall look into this question.
    
    ![1-2-11.png](https://i.loli.net/2020/01/11/ezvFlsO4pUNqQhK.png)
    > Much to our surprise, the answer is yes, and the results are salient -- those who are published in the afternoon (14-18) win most views, and the ones pop up at night also share good views. But be careful first -- we don't know what time zone the publish time column falls in. Thankfully we have some online tools to determine and turns out all the time in this dataset is UTC. The time zone in the US continent ranges from UTC-5 (Eastern Standard Time) to UTC-8 (Pacific standard time), so the best local time to publish a video in the US can be anywhere from 9 to 13. Since some of the videos are not uploaded by US natives, and we cannot determine how visits of YouTube Websites vary in different regions based solely on this dataset, the results cannot be explored further. But to put up a potential eye-catcher in the morning may not be a bad choice.

12. *WordCloud For Titles, Descriptions, And Tags*
    Word cloud is a very intuitive way to show frequency (or importance) of the words that appeared in the text. We used it to illustrate the dominant words in titles, tags, and descriptions:
    * ``titles``:
    ![1-2-12-1.png](https://i.loli.net/2020/01/11/3y4Qwt9ZSKoiEkx.png)
    * ``descriptions``:
        ![1-2-12-2.png](https://i.loli.net/2020/01/11/hfYpyP1Fk6T2biD.png)
    * ``tags``:
    ![1-2-12-3.png](https://i.loli.net/2020/01/11/gfHp68GJU4rhDek.png)
    > Surprisingly, besides words that are related to entertainment (e.g., official, movie, and Marvel, etc.), words that hint serious political topics (e.g., black, Iraq, Iran, Healthcare) pop up in word clouds.  According to previous results, news & politics category does share a lot of views, but not dominant. Maybe this is because these topics are heavily concentrated on such issues as Iraq&Iran and healthcare policy, in contrast to the various title names music videos can have.

#### 2.5.4 Summary
The basic aggregation groups we used in the analysis are their categories and channels.  If we are not interested in specific channels, the category of the video is more of importance, and channels also fall in different categories, so we can aggregate again. Also, the most important numerical feature we fathom through the process is the views, along with its aggregation (total and average), likes/dislikes, and comment counts.

The fundamental result we concluded from the EDA process on US dataset is: ***US people surf YouTube mostly for fun, also sometimes for serious topics.*** Specifically, there *are* some categories that we find interesting to talk about:

* **Entertainment**: They are the most trending category if we consider its proportion among trending videos, but do not get many views and reviews. In conclusion, this category is generally appreciated by the audience, but either because people cannot get too fanatical about a hilarious talk show as they do to a pop music video, or there are just too many options and people are distracted by its variousness, it is not the most popular category on YouTube.

* **Music /Film & Animation**: Music videos are among the most popular categories on YouTube. They receive most views and reviews, and most of them are positive, similar to Film & Animation. The *official* thing seems to be attractive to the audience, or we can say YouTube is generally considered the biggest hub of *official* music videos, movie trailers, and soundtracks, so no wonder for their popularity on this platform. 

* **Gaming**: It's a black horse worth mentioning for its statistical traits. It does not have a wide range of audience since it is not a trending category, but it seems to have a solid, loyal audience group which will give their dedication to specific videos and contribute a lot to their views and reviews, making them in the 3rd place of the rank page.

* **Non-profit & Activism**: It's one of the categories that receive 4th average views and most reviews, and most importantly, have an unignorable amount of dislikes. It can be inferred that some of them may be controversial and sensitive enough to arouse wide disagreement. (Just like Greta Thunberg. Some of her recent videos on YouTube have received over 3 million views and get nearly equal amounts of likes and dislikes, somewhat supportive to this hypothesis).

* **News & Politics**: It's a relatively hot category regarding both counts and views, though not at all the hottest. But the word clouds show that the topics are concentrated enough to make some keywords reappear in titles, tags, and descriptions of the videos, resulting in their saliency (it is based on the hypothesis that title words of the news are more concentrated than music and entertainment videos are, and it can be examined by cluster analysis methods). However, it seems that people do not have the same desire to review them as they do to music videos or non-profit videos.  

Also, people's habits and tendency to leave reviews are worth some discussion:

* *The more a video gets viewed in general, the more likes it will receive; the dislike rate will slightly grow simultaneously but not exceed to a certain threshold.*
* *US people tend to leave more positive feedbacks to trending videos than negative ones. But some videos are indeed infamous enough to arouse public hate, and people won't bother to show their antipathy.*
* *US people tend to show affection to videos that please their taste (e.g., music and games they love),  or express their opinions on controversial public topics. However, they don't show much attitude toward political issues.*

Finally, the possible best time to publish a video to get trending may be in the morning for US people. It is hard to give a plausible explanation, though, since all came to my mind is that people may find fresh, interesting videos at lunch break, which builds up first waves, and it determines what one will see next after work in the evening until then it becomes a huge tide. But it is hardly convincing, and we may need to know such info as the daily schedule for ordinary Americans or how YouTube channels are run by their owners to determine its mechanism. Whatever the case, one thing for sure is that the publish time of a video does relate to its future popularity, so further exploration is worthy.

### 2.6 Questions & Insights for Datasets of English-Speaking Countries
The US, GB, CA datasets have 40949, 38916, 40881 entries, respectively, so the combined dataset is not skewed to its US component. The EDA process here is to make some comparisons to the US dataset and prepare for predictions.

#### 2.6.1 Trending Videos, Categories and Channels
1. *Top10 Most Trending Videos*
    | Channel Name | Title | Category |
    |---|---|---|
    | SamSmithWorldVEVO | Sam Smith - Pray (Official Video) ft. Logic | Music |
    | ChildishGambinoVEVO | Childish Gambino - This Is America (Official Video) | Music |
    | BostonDynamics | Getting some air, Atlas? | Science & Technology |
    | EnriqueIglesiasVEVO  | Enrique Iglesias - MOVE TO MIAMI (Official Video) ft. Pitbull | Music |
    | Marvel Entertainment | Marvel Studios' Ant-Man and The Wasp - Official Trailer | Entertainment |
    | Kanye West | kanye west / charlamagne interview | People & Blogs |
    | CelineDionVEVO | Céline Dion - Ashes (from the Deadpool 2 Motion Picture Soundtrack) | Music |
    | FlorenceMachineVEVO  | Florence + The Machine - Hunger | Music |
    | Lionsgate Movies|Robin Hood (2018 Movie) Teaser Trailer – Taron Egerton, Jamie Foxx, Jamie Dornan|Film & Animation|
    | Disney•Pixar | Incredibles 2 Official Trailer | Film & Animation |
    
    > This rank list shared 2 videos with the US one: "Sam Smith - Pray (Official Video) ft. Logic "from "SamSmithWorldVEVO``and "Getting some air, Atlas? "from "BostonDynamics ". And again, music videos dominate.

2. *Top10 Most Trending Categories*
    ![1-3-2.jpeg](https://i.loli.net/2020/01/11/gzfFvlxi7OD1LJI.jpg)
    > Compared to previous results, both datasets share the top 7 categories but have different preferences. The other two countries seem to pay more attention to News & Politics(2nd vs. 5th) and People & Blog(3rd vs. 6th), while Howto & Style(7th vs. 3rd) is not as popular. Still, both favor entertainment (1st vs. 1st) and music (4th vs. 2nd) as a diversion.

3. *Top10 Most Trending Channels* 
    ![1-3-3.png](https://i.loli.net/2020/01/11/z7Lwi8CGUjpWmvD.png)
    > There are some surprising results when it comes to top channels:
        1. ESPN is the most popular channel of both,  along with two talk shows.
        2. American news channels such as CNN, MSNBC have more popularity beyond the US.
        3. Most entertainment channels have Indian and Pakistan content (VikatanTV, SET India, Radaan Media, and ARY Digital). According to ARY Digital, this is due to the increasing need for such content in Great Britain.

#### 2.6.2 Closer Look On Titles
4. *Most Popular Words For Titles Of Trending Videos *
    ![1-3-4-1.png](https://i.loli.net/2020/01/11/YPtK73SjqNhoOvF.png)![1-3-4-2.png](https://i.loli.net/2020/01/11/IxO8k9m5YDiCzhu.png)![1-3-4-3.png](https://i.loli.net/2020/01/11/QouWnpb54NBtPVe.png)
    > The word (and gram) frequency shows a similar result of the US, that official music videos/movie trailers in the year(the dataset includes 2017 and 2018 trending videos) are among the hottest videos. Also, highlight moments of games and punjabi songs share some attention, another manifestation of India culture impact among these countries.

#### 2.6.3 Summary
Basically, ***the tendencies are similar in the US dataset and combined dataset***. However, there are some notable differences:
* News and Politics are more welcomed by Great Britain and Canada.
* India (and Pakistan) culture has a greater impact, maybe because of Great Britain.

## 3. Predictions
### 3.1 Logistic Regression To Predict Popularity Of Words In Titles Determined by TF-IDF
#### 3.1.1 Logistic Regression
Logistic regression is the basic method to execute a binary classification task. Explanations are omitted.

#### 3.1.2 Feature Engineering: TF-IDF
TF-IDF analyzes the impact of tokens (words) throughout the whole documents. For example, the more times a word appears in a document (each title), the more weight it will have. However, the more documents (titles) the word appears in, it is "penalized," and the weight is diminished because it is empirically less informative than features that occur in a small fraction of the training corpus (source)

$$
t_{i d}=\frac{n_{i d}}{n_{d}} \log \frac{N}{n_{i}}
$$

Where:
* $n_{id}$ : occurrences of word $i$ in document $d$
* $n_{d}$ : words in document $d$
* $N$: documents in corpus
* $n_i$: documents word $i$ occurs in whole corpus

#### 3.1.3 Model Design
First, we use TF-IDF to extract features of the corpus, and ``max_features = 10000 ". The popularity of the videos is determined by outliers of quartiles in views. Then simple logistic regression is used to  fit the data, with regularization "C = 0.1 "

#### 3.1.4 Prediction Results
Here are three examples of the result: 1 and 3 are labeled 'popular' while 2 is labeled 'normal'.

![2-1-1.png](https://i.loli.net/2020/01/11/uf9vxNRLbTEHMce.png)
![2-1-2.png](https://i.loli.net/2020/01/11/7KOSBelGVZIC49Q.png)
![2-1-3.png](https://i.loli.net/2020/01/11/sVZaFbp1qrw9MRK.png)
From the results, we can see the model itself fits perfectly, but its interpretability is questionable. On the one hand, it may due to TF-IDF method itself, which consider words that appear too frequently as a cliche that should be penalized, so one can see that 'official' 'video' and 'trailer' may be considered heavy hints of a normal video, whereas these are just category labels; on the other, we hope to find useful features that decide the videos' popularity, but based on its feedback, we can hardly gain any knowledge why these highlighted words make the video popular. We cannot exclude the possibility that it is the result of overfitting. In conclusion, this prediction method is not working.

### 3.2 Predictions on Popularity of Words in Titles In 6 Most Trending Categories Using Latent Dirichlet Allocation
#### 3.2.1 Introduction to Latent Dirichlet Allocation
In natural language processing, latent Dirichlet allocation (LDA) is a generative statistical model that allows sets of observations to be explained by unobserved groups that explain why some parts of the data are similar. For example, if observations are words collected into documents, it posits that each document is a mixture of a small number of topics and that each word's presence is attributable to one of the document's topics. In LDA, the topic distribution is assumed to have a sparse Dirichlet prior. The sparse Dirichlet priors encode the intuition that documents cover only a small set of topics and that topics use only a small set of words frequently. A topic is neither semantically nor epistemologically strongly defined. It is identified based on automatic detection of the likelihood of term co-occurrence. 

Details of the algorithm can be superfluous, so they are omitted.

#### 3.2.2 Model Design
First, we use "CountVectorizer "to do feature extraction, which converts the titles to a matrix of token counts, then send them to LDA learner, which divide the corpse into 7 topics, ``max_iteration = 10``, then visualize the result.

#### 3.2.3 Prediction Results
We have examined the top 6 categories that trended and compared the prediction results with actual results. The graphs are interactive, and we recommend running the notebook yourself to get more information. See [Appendix](#app).

##### Entertainment
![2-2-1.png](https://i.loli.net/2020/01/11/IxPfyUkATJwY8qG.png)
##### News & Politics
![2-2-2.png](https://i.loli.net/2020/01/11/XilWJP8ztUbxK6M.png)
##### People & Blogs
![2-2-3.png](https://i.loli.net/2020/01/11/8jqkUgOmXIMh3ZG.png)
##### Music
![2-2-4.png](https://i.loli.net/2020/01/11/ZxshWXt8ofJq79e.png)
##### Sports
![2-2-5.png](https://i.loli.net/2020/01/11/Nk2qMuTdaLvfWGJ.png)
##### Comedy
![2-2-6.png](https://i.loli.net/2020/01/11/NfIcYaUewJWriCQ.png)
As is shown from the graph,  the LDA method does give satisfying results. The topic number as a hyperparameter can still be fine-tuned later on (the results have already been salient, but topics can be even more). Generally, the LDA method, combined with single counting, can give an estimation of term frequency in a  single topic, so it won't penalize cliche words as logistic regression combined with TF-IDF does. More importantly, it gives relative importance to the word, and the results are mostly accurate. So it indeed gives insights on what words lead to popularity and how much they contribute. One thing worth mentioning is that LDA won't give an extreme estimation of frequency, so the accuracy of extreme cases  (e.g., music) may be lower; however, it can keep the general trend correct.

### 3.3 Trending Titles Generation Using LSTM
#### 3.3.1 Introduction to LSTM
LSTM  is based on RNN. The memory state in RNNs gives an advantage over traditional neural networks, but a problem called Vanishing Gradient is associated with them. In this problem, while learning with a large number of layers, it becomes hard for the network to learn and tune the parameters of the earlier layers. Therefore, A new type of RNNs called LSTMs (Long Short Term Memory) Models have been developed.

LSTMs have an additional state called 'cell state' through which the network makes adjustments in the information flow. The advantage of this state is that the model can remember or forget the leanings more selectively:

![2-3.png](https://i.loli.net/2020/01/11/W2v7g6dtsxOmX4j.png)
#### 3.3.2 Model Design
First, we will tokenize and sequential all the title data and pad them to ensure they have the same length before sending them to the LSTM model. Generally, an LSTM model has 4 kinds of layers:
* **Input Layer**: Takes the sequence of words as input.
* **LSTM Layer**: Computes the output using LSTM units. We have added 100 units in the layer, and it can be fine-tuned later. 
* **Dropout Layer**: A regularization layer which randomly turns-off the activations of some neurons in the LSTM layer. It helps in preventing overfitting. The dropout rate is set to 0.1.
* **Output Layer**: Computes the probability of the best possible next word as output. We use softmax as activation method, cross-entropy as our loss function, and Adam as our optimizer.

We will train this model with 50 epochs, which can also be experimented further.
The summary of the model is listed below:

Layer (type) | Output Shape | Param #   
--|--|--
embedding_1 (Embedding) | (None, 25, 10) | 77060     
lstm_1 (LSTM) | (None, 100) | 44400     
dropout_1 (Dropout) | (None, 100) | 0         
dense_1 (Dense) | (None, 7706) | 778306    
```
Total params: 899,766
Trainable params: 899,766
Non-trainable params: 0
```
#### 3.3.3 Prediction Results
Using  some popular words as seeds we can  generate titles from the LSTM model.
```
print (generate_text("Trump", 5, model, max_sequence_len))
print (generate_text("avengers", 8, model, max_sequence_len))
print (generate_text("episode", 6, model, max_sequence_len))
print (generate_text("iraq", 5, model, max_sequence_len))
print (generate_text("punjabi", 5, model, max_sequence_len))
print (generate_text("taylor", 7, model, max_sequence_len))
```
Below are the corresponding results.
```
Trump Wants Feinstein Makes Racist Immigration
Avengers Infinity War Cast Reveals Stole Set Marvel ”
Episode 2 Lalkar Velaiilla Pattadhari 2 2018
Iraq Laachi Logo Muchh Trump Trampoline
Punjabi Got Talent 2018 Auditions Kristel
Taylor Swift Delicate Vertical Version Ft Chris Xcx
```
As can be seen, some titles (like the first one) do seem make sense both syntactically and semantically, while others (like the Iraq one) don't seem to have any inner structure or meaning.  This implies that the LSTM model can be of some use if is fine tuned.

### 3.4 Summary
Together we have used 3 methods in prediction: Logistic Regression, LDA, and LSTM(as a generator). The Logistic Regression method suffers from its TF-IDF feature selection method and basically is too simple; the LDA method is a complex Bayesian method that gives good prediction results; LSTM is a commonly used title generator with good potential.  The hyperparameters in the latter two methods can be finer tuned later on.

## 4 Conclusion
There is so much to find in the YouTube trending videos dataset. Through this project, we have done extensive EDA on a small part of the dataset, and the results are already beyond imagination, and some are worth further exploration. If the same things were conducted on the rest of the dataset, there would be more interesting conclusions. These fun facts can not only give one insight on how modern media like YouTube work and reveal different facets of modern society but also be of great use for those who want to *predict* and *make* popularity. We have taken the first steps by trying various machine learning models, some even beyond what we have learned in class. Hard though they seem, we somehow manage to get them to work and receive fairly good results. 

Still, due to time limitations, we have no chance to design more powerful features, tune the parameters or dive deeper into the theories to fully grasp the methods we have used, and all evaluation methods we know is not applicable here, so we have missed the chance to practice what we have learned in class. That's where our dissatisfaction has come from and is what we want to achieve if given the next chance to conduct another data science project. We do hope we can carry on what we have achieved through this project -- how to raise questions to datasets, conduct EDA, choose and implement algorithms down to runnable codes and give insights on the results, to take steps closer to mastery in data science.


## <span id = "app">Appendix: Anaconda Environment Configuration </span>
All things that need to run the notebook is stored in this ``.yml`` file. To import, simply run
```sh
conda env create -f file_name.yml
```
-----
```yml
name: env_pro_ds# you can use whatever name you like

channels:

- bioconda

- conda-forge

- https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/

- https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/

- https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/

- https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/

- https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/

- defaults

dependencies:

- absl-py=0.9.0=py37_0

- appnope=0.1.0=py37_1000

- astor=0.7.1=py_0

- astroid=2.3.3=py37_0

- astropy=4.0=py37h0b31af3_0

- attrs=19.3.0=py_0

- backcall=0.1.0=py_0

- bleach=3.1.0=py_0

- c-ares=1.15.0=h01d97ff_1001

- ca-certificates=2019.11.28=hecc5488_0

- catalogue=0.2.0=py_0

- cctools=927.0.2=h5ba7a2e_3

- certifi=2019.11.28=py37_0

- cffi=1.13.2=py37h33e799b_0

- chardet=3.0.4=py37_1003

- chart-studio=1.0.0=py_0

- clang=9.0.1=default_hf57f61e_0

- clang_osx-64=9.0.1=h05bbb7f_0

- clangxx=9.0.1=default_hf57f61e_0

- clangxx_osx-64=9.0.1=h05bbb7f_0

- compiler-rt=9.0.1=h6a512c6_0

- compiler-rt_osx-64=9.0.1=h6a512c6_0

- confuse=1.0.0=py_0

- cryptography=2.8=py37hafa8578_1

- cycler=0.10.0=py_2

- cymem=2.0.3=py37h4a8c4bd_0

- cython-blis=0.4.1=py37h0b31af3_0

- decorator=4.4.1=py_0

- defusedxml=0.6.0=py_0

- entrypoints=0.3=py37_1000

- freetype=2.10.0=h24853df_1

- funcy=1.14=py_0

- future=0.18.2=py37_0

- gast=0.3.2=py_0

- grpcio=1.23.0=py37h8a88325_0

- h5py=2.10.0=nompi_py37h106b333_101

- hdf5=1.10.5=nompi_h3e39495_1104

- htmlmin=0.1.12=py_1

- hypothesis=5.1.1=py_0

- idna=2.8=py37_1000

- importlib_metadata=1.3.0=py37_0

- ipykernel=5.1.3=py37h5ca1d4c_0

- ipython=7.11.1=py37h5ca1d4c_0

- ipython_genutils=0.2.0=py_1

- isort=4.3.21=py37_0

- jedi=0.15.2=py37_0

- jinja2=2.10.3=py_0

- joblib=0.14.1=py_0

- jpeg=9c=h1de35cc_1001

- jsonschema=3.2.0=py37_0

- jupyter_client=5.3.4=py37_0

- jupyter_core=4.6.1=py37_0

- keras=2.3.1=py37_0

- keras-applications=1.0.8=py_1

- keras-preprocessing=1.1.0=py_0

- kiwisolver=1.1.0=py37ha1b3eb9_0

- lazy-object-proxy=1.4.3=py37h0b31af3_0

- ld64=450.3=h3c32e8a_3

- libblas=3.8.0=14_openblas

- libcblas=3.8.0=14_openblas

- libcxx=9.0.1=1

- libffi=3.2.1=1

- libgfortran=4.0.0=2

- libgpuarray=0.7.6=h1de35cc_1003

- liblapack=3.8.0=14_openblas

- libllvm8=8.0.1=h770b8ee_0

- libllvm9=9.0.1=ha1b3eb9_0

- libopenblas=0.3.7=h3d69b6c_6

- libpng=1.6.37=h2573ce8_0

- libprotobuf=3.11.2=hd174df1_0

- libsodium=1.0.17=h01d97ff_0

- libtiff=4.1.0=ha78913b_3

- lime=0.1.1.37=py_0

- llvm-openmp=9.0.1=h40edb58_0

- llvmlite=0.30.0=py37h05045ef_1

- lz4-c=1.8.3=h6de7cb9_1001

- mako=1.1.0=py_0

- markdown=3.1.1=py_0

- markupsafe=1.1.1=py37h0b31af3_0

- matplotlib=3.1.2=py37_1

- matplotlib-base=3.1.2=py37h11da6c2_1

- mccabe=0.6.1=py_1

- missingno=0.4.2=py_0

- mistune=0.8.4=py37h0b31af3_1000

- more-itertools=8.0.2=py_0

- murmurhash=1.0.0=py37h4a8c4bd_0

- nb_conda=2.2.1=py37_2

- nb_conda_kernels=2.2.2=py37_0

- nbconvert=5.6.1=py37_0

- nbformat=5.0.3=py_0

- ncurses=6.1=h0a44026_1002

- nltk=3.4.4=py_0

- notebook=6.0.1=py37_0

- numba=0.46.0=py37h4f17bb1_1

- numexpr=2.7.1=py37h4f17bb1_0

- numpy=1.17.3=py37hde6bac1_0

- olefile=0.46=py_0

- openssl=1.1.1d=h0b31af3_0

- packaging=20.0=py_0

- pandas=0.25.3=py37h4f17bb1_0

- pandas-profiling=2.3.0=py_0

- pandoc=2.9.1.1=0

- pandocfilters=1.4.2=py_1

- parso=0.5.2=py_0

- patsy=0.5.1=py_0

- pexpect=4.7.0=py37_0

- phik=0.9.8=py_0

- pickleshare=0.7.5=py37_1000

- pillow=7.0.0=py37h918e99a_0

- pip=19.3.1=py37_0

- plac=0.9.6=py_1

- plotly=4.4.1=py_0

- pluggy=0.13.0=py37_0

- preshed=3.0.2=py37h4a8c4bd_1

- prometheus_client=0.7.1=py_0

- prompt_toolkit=3.0.2=py_0

- protobuf=3.11.2=py37h4a8c4bd_0

- psutil=5.6.7=py37h0b31af3_0

- ptyprocess=0.6.0=py_1001

- py=1.8.1=py_0

- pycparser=2.19=py37_1

- pygments=2.5.2=py_0

- pygpu=0.7.6=py37h3b54f70_1000

- pyldavis=2.1.2=py_0

- pylint=2.4.4=py37_0

- pyopenssl=19.1.0=py37_0

- pyparsing=2.4.6=py_0

- pyrsistent=0.15.7=py37h0b31af3_0

- pysocks=1.7.1=py37_0

- pytest=5.3.2=py37_0

- pytest-arraydiff=0.3=py_0

- pytest-astropy=0.7.0=py_0

- pytest-astropy-header=0.1.2=py_0

- pytest-doctestplus=0.4.0=py_0

- pytest-openfiles=0.4.0=py_0

- pytest-pylint=0.14.1=py_0

- pytest-remotedata=0.3.1=py_0

- pytest-runner=5.2=py_0

- python=3.7.6=h5c2c468_2

- python-dateutil=2.8.1=py_0

- pytz=2019.3=py_0

- pyyaml=5.3=py37h0b31af3_0

- pyzmq=18.1.1=py37h4bf09a9_0

- readline=8.0=hcfe32e1_0

- requests=2.22.0=py37_1

- retrying=1.3.3=py_2

- scikit-learn=0.22.1=py37h3dc85bc_1

- scipy=1.4.1=py37h82752d6_0

- seaborn=0.9.0=py_2

- send2trash=1.5.0=py_0

- setuptools=44.0.0=py37_0

- six=1.13.0=py37_0

- sortedcontainers=2.1.0=py_0

- spacy=2.2.3=py37ha1b3eb9_0

- sqlite=3.30.1=h93121df_0

- srsly=1.0.0=py37h4a8c4bd_0

- statsmodels=0.10.2=py37h3b54f70_0

- tapi=1000.10.8=ha1b3eb9_4

- tensorboard=1.13.1=py37_0

- tensorflow=1.13.1=hfddd6c2_8

- tensorflow-base=1.13.1=py37_8

- tensorflow-estimator=1.13.0=py37h24bf2e0_0

- termcolor=1.1.0=py_2

- terminado=0.8.3=py37_0

- testpath=0.4.4=py_0

- theano=1.0.4=py37h0a44026_1000

- thinc=7.3.0=py37ha1b3eb9_0

- tk=8.6.10=hbbe82c9_0

- tornado=6.0.3=py37h0b31af3_0

- tqdm=4.41.1=py_0

- traitlets=4.3.3=py37_0

- urllib3=1.25.7=py37_0

- wasabi=0.6.0=py_0

- wcwidth=0.1.8=py_0

- webencodings=0.5.1=py_1

- werkzeug=0.16.0=py_0

- wheel=0.33.6=py37_0

- wordcloud=1.6.0=py37h0b31af3_0

- wrapt=1.11.2=py37h0b31af3_0

- xz=5.2.4=h1de35cc_1001

- yaml=0.2.2=h0b31af3_1

- zeromq=4.3.2=h6de7cb9_2

- zipp=0.6.0=py_0

- zlib=1.2.11=h0b31af3_1006

- zstd=1.4.4=he7fca8b_1

- pip:

- en-core-web-sm==2.2.5

prefix: /Users/xiangyutong/opt/anaconda3/envs/env_pro_ds
```
