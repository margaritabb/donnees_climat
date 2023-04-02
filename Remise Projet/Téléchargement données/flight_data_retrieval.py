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
             "flight_long": flight.longitude,
             "flight_origin": flight.origin_airport_iata,
             "flight_destin": flight.destination_airport_iata
             }
        )
    
flight_data = pd.DataFrame(flight_data)

flight_dataframe = flight_dataframe.append(flight_data)

# Export

flight_dataframe.to_csv("/Users/margaritabozhinova/Desktop/Hiver 2023/IFT 2821/Projet/donnees_vols.csv")

# Data clean up and save

## Entite Mobile

entitemobile = pd.DataFrame(flight_dataframe.loc[:, ("flight_nbr", "flight_origin", "flight_destin")])
entitemobile = entitemobile.drop_duplicates(subset = "flight_nbr")

entitemobile = entitemobile[0:50]

entitemobile.to_csv("/Users/margaritabozhinova/Desktop/Hiver 2023/IFT 2821/Projet/entitemobile.csv", index = False)

## Positions
positions = flight_dataframe[flight_dataframe["flight_nbr"].isin(entitemobile["flight_nbr"])]
positions = positions.loc[:, ("flight_nbr", "flight_time", "flight_lat", "flight_long")]

positions.to_csv("/Users/margaritabozhinova/Desktop/Hiver 2023/IFT 2821/Projet/positions.csv", index = False)

## Adoption
adoption_1 = pd.DataFrame(entitemobile.loc[:,("flight_nbr")])
adoption_1["IdClient"] = 2

adoption_2 = adoption_1.copy()[7:12]
adoption_2["IdClient"] = 3

adoption_3 = adoption_2.copy()
adoption_3["IdClient"] = 1

adoption_4 = adoption_1.copy()[38:40]
adoption_4["IdClient"] = 5

adoption = pd.concat([adoption_1, adoption_2, adoption_3, adoption_4])

# Créer chaînes de caractères pour INSERT

def SQL_INSERT_STATEMENT_FROM_DATAFRAME(SOURCE, TARGET):
    sql_texts = ''
    for index, row in SOURCE.iterrows():       
        sql_texts += """
""" + str(tuple(row.values)) + ","       
    return sql_texts

insert_entite = SQL_INSERT_STATEMENT_FROM_DATAFRAME(entitemobile, "position")
insert_entite = insert_entite.replace("nan", "NULL")

insert_position = SQL_INSERT_STATEMENT_FROM_DATAFRAME(positions, "position")
insert_position = insert_position.replace("nan", "NULL")

insert_adoption = SQL_INSERT_STATEMENT_FROM_DATAFRAME(adoption, "adoption")
insert_adoption = insert_adoption.replace("nan", "NULL")
