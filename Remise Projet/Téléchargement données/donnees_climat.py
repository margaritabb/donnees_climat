#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 13:30:58 2023

@author: margaritabozhinova
"""

weather = []
    

def get_weather(latitude, longitude, datetime, weather_list):
    """

    Returns
    -------
    None.

    """
    
    import csv
    import codecs
    import urllib.request
    import urllib.error
    import sys
    
    # This is the core of our weather query URL
    BaseURL = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/'
    
    ApiKey='XXXX' # j'ai enlevé mon API key étant donné que le nombre d'observations qu'on peut télécharger gratuitement est limité 

    UnitGroup='metric'
    
    #Location for the weather data
    Location=str(latitude)+","+str(longitude)
    
    #Optional start and end dates
    #If nothing is specified, the forecast is retrieved. 
    #If start date only is specified, a single historical or forecast day will be retrieved
    #If both start and and end date are specified, a date range will be retrieved
    StartDate = str(datetime)
    EndDate=''
    
    #JSON or CSV 
    #JSON format supports daily, hourly, current conditions, weather alerts and events in a single JSON package
    #CSV format requires an 'include' parameter below to indicate which table section is required
    ContentType="csv"
    
    #include sections
    #values include days,hours,current,alerts
    Include="current"
    
    
    print('')
    print(' - Requesting weather : ')
    
    #basic query including location
    ApiQuery=BaseURL + Location
    
    #append the start and end date if present
    if (len(StartDate)):
        ApiQuery+="/"+StartDate
        if (len(EndDate)):
            ApiQuery+="/"+EndDate
    
    #Url is completed. Now add query parameters (could be passed as GET or POST)
    ApiQuery+="?"
    
    #append each parameter as necessary
    if (len(UnitGroup)):
        ApiQuery+="&unitGroup="+UnitGroup
    
    if (len(ContentType)):
        ApiQuery+="&contentType="+ContentType
    
    if (len(Include)):
        ApiQuery+="&include="+Include
    
    ApiQuery+="&key="+ApiKey
    
    
    
    print(' - Running query URL: ', ApiQuery)
    print()
    
    try: 
        CSVBytes = urllib.request.urlopen(ApiQuery)
    except urllib.error.HTTPError  as e:
        ErrorInfo= e.read().decode() 
        print('Error code: ', e.code, ErrorInfo)
        sys.exit()
    except  urllib.error.URLError as e:
        ErrorInfo= e.read().decode() 
        print('Error code: ', e.code,ErrorInfo)
        sys.exit()
    
    
    # Parse the results as CSV
    CSVText = csv.reader(codecs.iterdecode(CSVBytes, 'utf-8'))
    
    RowIndex = 0
    
    # The first row contain the headers and the additional rows each contain the weather metrics for a single day
    # To simply our code, we use the knowledge that column 0 contains the location and column 1 contains the date.  The data starts at column 4
    # Create a dictionary with the requested data and add it to a list that will later become a dataframe
        
    for Row in CSVText:
        if RowIndex == 0:
            FirstRow = Row
        else:
            d = {}
            d.update({"Request_datetime": datetime,
                      "Location": Row[0],
                      "Datetime": Row[1]})
    
            ColIndex = 0
            for Col in Row:
                if ColIndex >= 4:
                    d.update({FirstRow[ColIndex]: Row[ColIndex]})
                ColIndex += 1
            weather_list.append(d)
        RowIndex += 1
        
    return weather_list
    

for index, row in flight_dataframe.iterrows():
    get_weather(row["flight_lat"], row["flight_long"], row["flight_time"], weather)

weather_dataframe = pd.DataFrame(weather)
