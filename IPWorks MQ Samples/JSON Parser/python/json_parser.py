# 
# IPWorks MQ 2022 Python Edition - Sample Project
# 
# This sample project demonstrates the usage of IPWorks MQ in a 
# simple, straightforward way. It is not intended to be a complete 
# application. Error handling and other checks are simplified for clarity.
# 
# www.nsoftware.com/ipworksmq
# 
# This code is subject to the terms and conditions specified in the 
# corresponding product license agreement which outlines the authorized 
# usage and restrictions.
# 

import sys
import string
from ipworksmq import *

input = sys.hexversion<0x03000000 and raw_input or input


def fireCharacters(e):
  print(e.text)

def fireStartDoc(e):
  print("Started parsing file")

def fireEndDoc(e):
  print("Finished parsing file")

def fireError(e):
  print(e.message)


def fireStartElement(e):
  print("Element %s started"%e.element)

def fireEndElement(e):
  print("Element %s ended"%e.element)

json = JSON()

json.on_characters = fireCharacters
json.on_end_document = fireEndDoc
json.on_end_element = fireEndElement
json.on_error = fireError
json.on_start_document = fireStartDoc
json.on_start_element = fireStartElement

try:
  json.set_input_file('books.json')
  json.parse()
  json.x_path = "/json/store/books"
  bookCount = json.get_x_child_count()
  propCount = 0
  for x in range(1,bookCount+1):
    print("\r\nBook #" + str(x))
    json.x_path = "/json/store/books/[" + str(x) + "]"
    propCount = json.get_x_child_count()
    for y in range(1,propCount+1):
      json.x_path = "/json/store/books/[" + str(x) + "]/[" + str(y) + "]"
      print(json.x_element + ": " + json.x_text)
except IPWorksMQError as e:
    print("ERROR: %s"%e.message)

