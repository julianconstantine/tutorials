# Using the Twitter API
# Link: http://adilmoujahid.com/posts/2014/07/twitter-analytics/

# Import modules to work with Twitter data
import json
import os
import re
import pandas as pd
import matplotlib.pyplot as plt

__author__ = 'j_caracotsios'

# Set working directory to the python-twitter-api subfolder
path = os.getcwd()

if re.search('python-twitter-api', path):
    print("We're in the right place y'all.")
else:
    os.chdir(path + '\\python-twitter-api')

tweets_file = open('twitter_data.txt', 'r')
tweets_data = []

# Read in each line of our twitter data file
for line in tweets_file:
    try:
        tweet = json.loads(line)
        tweets_data.append(tweet)
    except:
        continue

# There are 4261 items in our tweets_data list
print(len(tweets_data))

# Initialize pandas DataFrame
tweets = pd.DataFrame()

# Each element of the tweets_data list is itself a dictionary
type(tweets_data[0])  # Returns: dict

# These dictionaries have keys labeled text, lang, and country
tweets_data[0].keys()

# Extracts all dictionary elements with a certain key from a list of dictionaries
# map(lambda t: some_function(t), list) is basically just lapply() in R
tweets['text'] = map(lambda t: t['text'], tweets_data)
tweets['lang'] = map(lambda t: t['lang'], tweets_data)
tweets['country'] = map(lambda t: t['place']['country'] if t['place'] is not None else "NONE", tweets_data)

# Get frequencies of tweets by language
tweets_by_lang = tweets['lang'].value_counts()

# Set up bar graph
fig, ax = plt.subplots()
ax.tick_params('x', labelsize=15)
ax.tick_params('y', labelsize=10)
ax.set_xlabel('Language', fontsize=15)
ax.set_ylabel('Number of tweets', fontsize=15)
ax.set_title('Top 5 languages', fontsize=15, fontweight='bold')

# Plot top five tweets by language
tweets_by_lang[:5].plot(ax=ax, kind='bar', color='red')


# Now do this for tweets by country
tweets_by_country = tweets[tweets['country'] != "NONE"]['country'].value_counts()

fig, ax = plt.subplots()
ax.tick_params('x', labelsize=15)
ax.tick_params('y', labelsize=10)
ax.set_xlabel('Countries', fontsize=15)
ax.set_ylabel('Number of tweets', fontsize=15, fontweight='bold')

tweets_by_country[:5].plot(ax=ax, kind='bar', color='blue')

# Save tweets DataFrame to CSV file
# First, convert to UTF-8 from some other version of Unicode
tweets['text'] = tweets['text'].apply(lambda t: t.encode('utf-8', 'ignore'))
tweets['lang'] = tweets['lang'].apply(lambda t: t.encode('utf-8', 'ignore'))
tweets['country'] = tweets['country'].apply(lambda t: t.encode('utf-8', 'ignore'))

tweets.to_csv('tweets.csv', index=False)
