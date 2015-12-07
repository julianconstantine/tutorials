from TwitterSearch import *
import pandas as pd

# User credentials to access Twitter API
ACCESS_TOKEN = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
ACCESS_TOKEN_SECRET = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

CONSUMER_KEY = '5JoigYcA2Mzb9tA1DGQPAQroi'
CONSUMER_SECRET = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'

# SEARCHING TWITTER
# Use a try-except condition to avoid things breaking down because of errors

tso = TwitterSearchOrder()

tso.set_keywords(['obama'])
tso.set_language('en')
tso.set_include_entities(False)

ts = TwitterSearch(
    consumer_key=CONSUMER_KEY,
    consumer_secret=CONSUMER_SECRET,
    access_token=ACCESS_TOKEN,
    access_token_secret=ACCESS_TOKEN_SECRET
)

raw_tweets_data = []

max_number_of_tweets = 500000

for tweet in ts.search_tweets_iterable(tso):
    raw_tweets_data.append(tweet)

    if len(raw_tweets_data) % 1000 == 0:
        print("%i tweets downloaded" % len(raw_tweets_data))

    if len(raw_tweets_data) >= max_number_of_tweets:
        break


print("Finished downloading %i tweets!" % len(raw_tweets_data))

tweets = pd.DataFrame()

tweets['user'] = map(lambda t: t['user']['screen_name'].encode('utf-8'), raw_tweets_data)
tweets['text'] = map(lambda t: t['text'].encode('utf-8'), raw_tweets_data)
tweets['date'] = map(lambda t: t['created_at'].encode('utf-8'), raw_tweets_data)
