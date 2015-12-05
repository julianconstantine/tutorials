# Using the Twitter API
# Link: http://adilmoujahid.com/posts/2014/07/twitter-analytics/

import re
import os
import pandas as pd
import matplotlib.pyplot as plt

__author__ = 'j_caracotsios'

# Set working directory to the python-twitter-api subfolder
path = os.getcwd()

if re.search('python-twitter-api', path):
    print("We're in the right place y'all.")
else:
    os.chdir(path + '\\python-twitter-api')

# Read in data
tweets = pd.read_csv('tweets.csv')


def word_in_text(word, text):
    word = word.lower()
    text = str(text).lower()

    match = re.search(word, text)

    if match:
        return True
    else:
        return False

tweets['python'] = tweets['text'].apply(lambda t: word_in_text('python', t))
tweets['ruby'] = tweets['text'].apply(lambda t: word_in_text('ruby', t))
tweets['javascript'] = tweets['text'].apply(lambda t: word_in_text('javascript', t))

# We have 860 tweets with the word 'python' in them; 1887 with 'ruby'; and 1267 with 'javascript'
print(tweets['python'].value_counts()[True])
print(tweets['ruby'].value_counts()[True])
print(tweets['javascript'].value_counts()[True])

prg_langs = ['python', 'ruby', 'javascript']

tweets_by_prg_lang = [tweets['python'].value_counts()[True], tweets['ruby'].value_counts()[True],
                      tweets['javascript'].value_counts()[True]]

x_pos = list(range(len(prg_langs)))
width = 0.8

fig, ax = plt.subplots()
plt.bar(x_pos, tweets_by_prg_lang, width, alpha=1, color='g')


ax.set_ylabel('Number of tweets: ', fontsize=15)
ax.set_title('Ranking: python vs. ruby vs. javascript (Raw data)', fontsize=10, fontweight='bold')
ax.set_xticks([p + 0.4*width for p in x_pos])
ax.set_xticklabels(prg_langs)
plt.grid()


tweets['programming'] = tweets['text'].apply(lambda t: word_in_text('programming', t))
tweets['tutorial'] = tweets['text'].apply(lambda t: word_in_text('tutorial', t))

tweets['relevant'] = tweets['text'].apply(lambda t: word_in_text('programming', t) or word_in_text('tutorial', t))

# There are 77 tweets containing "programming," 45 containing "tutorial," and 121 containing at least one
print(tweets['programming'].value_counts()[True])
print(tweets['tutorial'].value_counts()[True])
print(tweets['relevant'].value_counts()[True])

# There are 40 relevant Python tweets, 14 relevant Ruby tweets, and 69 relevant JavaScript tweets
print(tweets[tweets['relevant'] == True]['python'].value_counts()[True])
print(tweets[tweets['relevant'] == True]['ruby'].value_counts()[True])
print(tweets[tweets['relevant'] == True]['javascript'].value_counts()[True])


relevant_tweets_by_prg_lang = [tweets[tweets['relevant'] == True]['python'].value_counts()[True],
                               tweets[tweets['relevant'] == True]['ruby'].value_counts()[True],
                               tweets[tweets['relevant'] == True]['javascript'].value_counts()[True]]
fig, ax = plt.subplots()
plt.bar(x_pos, relevant_tweets_by_prg_lang, width, alpha=1, color='g')


ax.set_ylabel('Number of tweets: ', fontsize=15)
ax.set_title('Ranking: python vs. ruby vs. javascript (Relevant data)', fontsize=10, fontweight='bold')
ax.set_xticks([p + 0.4*width for p in x_pos])
ax.set_xticklabels(prg_langs)
plt.grid()


def extract_link(text):
    regex = r'https?://[^\s<>"]+|www.[^\s<>"]+'
    match = re.search(regex, text)

    if match:
        return match.group()
    else:
        return ''

tweets['link'] = tweets['text'].apply(lambda t: extract_link(t))

tweets_relevant = tweets[tweets['relevant'] == True]
tweets_relevant_with_links = tweets_relevant[tweets_relevant['link'] != '']

print(tweets_relevant_with_links[tweets_relevant_with_links['python'] == True]['link'])
print(tweets_relevant_with_links[tweets_relevant_with_links['ruby'] == True]['link'])
print(tweets_relevant_with_links[tweets_relevant_with_links['javascript'] == True]['link'])


