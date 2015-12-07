from TwitterSearch import *


# User credentials to access Twitter API
ACCESS_TOKEN = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
ACCESS_TOKEN_SECRET = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

CONSUMER_KEY = '5JoigYcA2Mzb9tA1DGQPAQroi'
CONSUMER_SECRET = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'

try:
    tso = TwitterSearchOrder()

    tso.set_keywords(['man in the high castle'])
    tso.set_language('en')
    tso.set_include_entities(False)

    ts = TwitterSearch(
        consumer_key=CONSUMER_KEY,
        consumer_secret=CONSUMER_SECRET,
        access_token=ACCESS_TOKEN,
        access_token_secret=ACCESS_TOKEN_SECRET
    )

    for tweet in ts.search_tweets_iterable(tso):
        print("@%s tweeted: %s" % (tweet['user']['screen_name'], tweet['text']))
except TwitterSearchException as e:
    print(e)

