from TwitterSearch import *


# User credentials to access Twitter API
ACCESS_TOKEN = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
ACCESS_TOKEN_SECRET = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

CONSUMER_KEY = '5JoigYcA2Mzb9tA1DGQPAQroi'
CONSUMER_SECRET = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'

# SEARCHING TWITTER
# Use a try-except condition to avoid things breaking down because of errors

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


# ACCESSING USER TIMELINES
# Basically works the same as before

try:
    tuo = TwitterUserOrder('theApost8te')

    # Syntax is exactly the same as before, except using a TwitterUserOrder object instead of a TwitterSearchOrder
    # object
    ts = TwitterSearch(
        consumer_key=CONSUMER_KEY,
        consumer_secret=CONSUMER_SECRET,
        access_token=ACCESS_TOKEN,
        access_token_secret=ACCESS_TOKEN_SECRET
    )

    # This will print all of my tweets
    for tweet in ts.search_tweets_iterable(tuo):
        print("@%s tweeted: %s" % (tweet['user']['screen_name'], tweet['text']))
except TwitterSearchException as e:
    print(e)


