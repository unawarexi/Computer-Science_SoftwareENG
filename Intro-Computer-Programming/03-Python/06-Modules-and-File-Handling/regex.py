import re

"""
Common Functions
1. re.search(pattern, string)
Searches for the first occurrence of a pattern in a string.

2. re.match(pattern, string)
Matches a pattern at the beginning of the string.

3. re.findall(pattern, string)
Finds all occurrences of a pattern in a string and returns them as a list of strings.

4. re.sub(pattern, repl, string) 

"""

# ------------------------ SEARCHING FOR A PATTERN
pattern = r'dog'
text1 = 'The quick brown fox jumps over the lazy dog.'

match = re.search(pattern, text1)
if match:
    print('Pattern found:', match.group())
else:
    print('Pattern not found.')


# ---------------------- FINDIND ALL MATCH

pattern = r'\b\w{4,}\b'
text2 = 'Python is an amazing language for programming.'

matches = re.findall(pattern, text2)
print('Matches:', matches)

# ------------------------ REPLACING PATTERNS

pattern = r'\bcat\b'
replacement = 'dog'
text3 = 'I have a cat. My cat is black.'

new_text = re.sub(pattern, replacement, text3)
print('New text:', new_text)




