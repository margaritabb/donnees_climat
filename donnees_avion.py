#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 11:41:31 2023

@author: margaritabozhinova
"""

import pandas as pd
from FlightRadar24.api import FlightRadar24API

flight_dataframe = pd.DataFrame()

# Run this portion every hour:

fr_api = FlightRadar24API()

airline_code = "ACA"
flight_extraction = fr_api.get_flights(airline = airline_code)

flight_data = []

for flight in flight_extraction:
    flight_data.append(
        {
            "flight_nbr": flight.number,
             "flight_time": flight.time,
             "flight_lat": flight.latitude,
             "flight_long": flight.longitude
             }
        )
    
flight_data = pd.DataFrame(flight_data)

flight_dataframe = flight_dataframe.append(flight_data)

