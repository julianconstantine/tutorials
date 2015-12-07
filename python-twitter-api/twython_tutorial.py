# Twython Tutorial
# Link: https://twython.readthedocs.org/en/latest/usage/starting_out.html

from twython import Twython

# User credentials to access Twitter API
access_token = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
access_token_secret = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

CONSUMER_KEY = '5JoigYcA2Mzb9tA1DGQPAQroi'
CONSUMER_SECRET = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'

# twitter = Twython(consumer_key, consumer_secret, access_token, access_token_secret)

twitter = Twython(CONSUMER_KEY, CONSUMER_SECRET, oauth_version=2)

ACCESS_TOKEN = twitter.obtain_access_token()

twitter = Twython(CONSUMER_KEY, access_token=ACCESS_TOKEN)

results = twitter.search(q='the man in the high castle')
