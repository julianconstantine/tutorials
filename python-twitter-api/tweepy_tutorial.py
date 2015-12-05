# TWEEPY TUTORIAL
# Link: http://docs.tweepy.org/en/v3.4.0/getting_started.html

import tweepy

__author__ = 'j_caracotsios'

# My Twitter authentication credentials
myAccessToken = '4364945415-Ez38de5EYcRmEYIbtUsS8LDy0LhZwypoogypXjD'
myAccessTokenSecret = 'mCM3IF1Aele7WogZqmLWxEOaU9G1sV6s1MHIPxHlUKyXr'

myConsumerKey = '5JoigYcA2Mzb9tA1DGQPAQroi'
myConsumerSecret = 'ZDTJ14yIKHyDLeLlWXDNNAEDzOCg6nHz8z9c6eISFHLZ2oDBkV'

#######################################################################################################
# TWEEPY BASICS
#######################################################################################################

auth = tweepy.OAuthHandler(consumer_key=myConsumerKey, consumer_secret=myConsumerSecret)

auth.set_access_token(key=myAccessToken, secret=myAccessTokenSecret)

api = tweepy.API(auth)

public_tweets = api.home_timeline()

for tweet in public_tweets:
    print(tweet)


user = api.get_user("theApost8te")

# user is a tweepy.models.User object
type(user)

print(user.screen_name)
print(user.followers_count)

for friend in user.friends():
    print(friend.screen_name)


#######################################################################################################
# AUTHENTICATION
#######################################################################################################


#######################################################################################################
# CODE SNIPPETS
#######################################################################################################

# Login and get API
auth = tweepy.OAuthHandler(consumer_key=myConsumerKey, consumer_secret=myConsumerSecret)
auth.set_access_token(key=myAccessToken, secret=myAccessTokenSecret)
api = tweepy.API(auth)


# Pagination
# Pagination is the process of breaking a document down into discrete pages
for friend in tweepy.Cursor(api.friends).items():
    print(friend.screen_name)

for friend in tweepy.Cursor(api.friends).items():
    # Prints 20 most recent statuses for each of my friends
    print(api.user_timeline(friend.screen_name))

# These are all of my tweets
api.user_timeline("theApost8te")


# FollowAll
# CAREFUL: This code will follow everyone that is following me

# for follower in tweepy.Cursor(api.followers).items():
#     follower.follow()


#######################################################################################################
# CURSORS
#######################################################################################################

# Login and get API
auth = tweepy.OAuthHandler(consumer_key=myConsumerKey, consumer_secret=myConsumerSecret)
auth.set_access_token(key=myAccessToken, secret=myAccessTokenSecret)
api = tweepy.API(auth)


# Iterate through user's tweets without Cursors
page = 1

while True:
    statuses = api.user_timeline(page=page)

    if statuses:
        for status in statuses:
            # Process status
            print(status)
    else:
        # If there are no more statuses, end the loop
        break

    page += 1

# Now do it using Cursors
# Cursors take care of pagination for you
for status in tweepy.Cursor(api.user_timeline).items():
    # Process status
    print(status)


# Passing parameters into the API method
# Need to pass into Cursor constructor method
tweepy.Cursor(api.user_timeline, id="theApost8te")


# We cannot do this:
# tweepy.Cursor(api.user_timeline(id="twitter"))


# Items or Pages
# This will process pages instead of items. Not sure what exactly it does.
for page in tweepy.Cursor(api.user_timeline).pages():
    # Process page
    print(page)


# Limits
# If you don't want to splurge everything, it's easy to pass in a limit parameter

# This will only print out my last three statuses
for status in tweepy.Cursor(api.user_timeline).items(limit=3):
    print(status)

# The same works with .pages(limit=n)


