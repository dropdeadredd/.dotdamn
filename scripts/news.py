#!/usr/bin/python

import requests
import os.path

#path where news are saved in txt (default current directory)
save_path = '/home/ddrx/.config/bspwm/data/'

#get your api key at https://newsapi.org/
api_key = "db3e065d672446b4b305a97694d7c99a"

#find sources & country codes at https://newsapi.org/sources
sources = ""
country = "US"

# save_url saves URL so that it is possible to open the news in the browser
# the url will always be the most recent, enable if number_news = 1
save_url = True
number_news = 1

try:
    data = requests.get('https://newsapi.org/v2/top-headlines?apiKey='+api_key+'&sources='+sources+'&country='+country).json()

    news_string = ""

    for x in range(number_news):
      sourceName = data['articles'][x]['source']['name']
      title = data['articles'][x]['title']
      news_string += '['+sourceName+ '] '+ title + ' '   
      
    path = os.path.join(save_path,"current_news.txt")         
    f = open(path, "w")
    f.write(news_string)
    f.close()
    
    if save_url == True:
      url = data['articles'][0]['url']
      path = os.path.join(save_path,"current_url.txt")         
      f = open(path, "w")
      f.write(url)
      f.close() 
      
      
except requests.exceptions.RequestException as e:
    print ('Something went wrong!')
    
    
    
    
    
    
    
    
    
  
    

