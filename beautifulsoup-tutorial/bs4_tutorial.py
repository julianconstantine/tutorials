import re

from bs4 import BeautifulSoup

# Load sample HTML document
html_doc = """
    <html><head><title>The Dormouse's story</title></head>
    <body>
    <p class="title"><b>The Dormouse's story</b></p>

    <p class="story">Once upon a time there were three little sisters; and their names were
    <a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
    <a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
    <a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
    and they lived at the bottom of a well.</p>

    <p class="story">...</p>
"""

# Create BeautifulSoup object
soup = BeautifulSoup(html_doc, 'html.parser')

# Examples of filter types
# STRINGS: Matches against exact string
soup.find_all('b')  # Finds all <b> ... </b> tags

# REGULAR EXPRESSIONS: Filter against regrex using match() method
# Get names of all tags starting with the letter 'b'
for tag in soup.find_all(re.compile('^b')):
    print(tag.name)

# LISTS: String match against any element in the list
# Find all <a> and <b> tags
soup.find_all(['a', 'b'])

# TRUE: Finds all tags in document
# Find and print names of all tags in document (but no text strings)
for tag in soup.find_all(True):
    print(tag.name)

# FUNCTION: Filters by function that takes in an element as its only argument and returns True if a match is
# found/False otherwise


def has_class_but_no_id(tag):
    return tag.has_attr('class') and not tag.has_attr('id')

# Find all tags with 'class' attribute but no 'id' attribute
soup.find_all(has_class_but_no_id)


# NOTE: f you pass in a function to filter on a specific attribute like href, the argument passed into the function
# will be the attribute value, not the whole tag.
def not_lacie(href):
    return href and not re.compile('lacie').search(href)

# Find all <a> tags whose href attribute does not match the regex compiled from 'lacie'
soup.find_all(href=not_lacie)


# THE find_all() METHOD
# find_all() searches through a tag's descendents and returns all descendents that match the filter

# Examples of find_all():
# Finds all <title> tags
soup.find_all('title')

# Find all <p> tags with class="title"
# I DIDN'T KNOW IT WOULD AUTO-DEFAULT TO SEARCHING BY CLASS LIKE THIS. COOL
soup.find_all('p', 'title')

# Finds all <a> tags
soup.find_all('a')

# Finds (first?) tag whose NavigableString text contains the word 'sisters'
soup.find(string=re.compile('sisters'))

# Keyword Arguments
# Any argument not recognized will get turned into a filter on one of the tag's attributes
# Finds all tags with id="link2"
soup.find_all(id='link2')

# Finds all tags with attribute href containing "elsie"
soup.find_all(href=re.compile('elsie'))

# Finds all tags with an id attribute
soup.find_all(id=True)

# Filter multiple attributes at once
soup.find_all(href=re.compile("elsie"), id='link1')

