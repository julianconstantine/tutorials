import tweepy
import json

# User credentials to access Twitter API
access_token = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
access_token_secret = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

consumer_key = '5JoigYcA2Mzb9tA1DGQPAQroi'
consumer_secret = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

results = api.search("Man in the High Castle", rpp=100)


for result in results:
    print(result.text)
