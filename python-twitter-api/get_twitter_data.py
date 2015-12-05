# Using the Twitter API
# Link: http://adilmoujahid.com/posts/2014/07/twitter-analytics/

# Import functions from tweepy module
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

__author__ = 'j_caracotsios'

# User credentials to access Twitter API
access_token = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
access_token_secret = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

consumer_key = '5JoigYcA2Mzb9tA1DGQPAQroi'
consumer_secret = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'


# This is a basic Listener object that prints tweets it receives
# I believe this is overwriting the built-in definition, not sure why

class StdOutListener(StreamListener):
    def on_data(self, data):
        print(data)
        return True

    def on_error(self, status):
        print(status)

if __name__ == '__main__':
    # Takes care of Twitter authentication and connects you to the Twitter API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)

    # Filters data streams to capture data by keywords 'python', 'javascript', and 'ruby'
    stream.filter(track=['python', 'javascript', 'ruby'])
