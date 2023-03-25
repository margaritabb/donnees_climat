#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 25 11:18:30 2023

@author: margaritabozhinova
"""

import tkinter as tk
import sqlite3



# Requetes de Camilo

# Fonction pour exécuter une requête et afficher les résultats dans une zone de texte
# def execute_query(query):
#     cursor = conn.cursor()
#     cursor.execute(query)
#     rows = cursor.fetchall()
#     result_text.delete('1.0', tk.END)  # Effacer le contenu précédent de la zone de texte
#     result_text.insert(tk.END, '\n'.join([str(row) for row in rows]))

# Fonction pour exécuter la première requête
# def query1():
#     query = """
#     SELECT c.Nom, COUNT(DISTINCT a.flight_nbr) AS NombreEntites, STRING_AGG(e.flight_nbr, ',') AS NumerosEntites
#     FROM Client c
#     LEFT JOIN Adoption a ON c.IdClient = a.IdClient
#     LEFT JOIN EntiteMobile e ON a.flight_nbr = e.flight_nbr
#     LEFT JOIN Climat cl ON e.flight_nbr = cl.flight_nbr
#     GROUP BY c.Nom;
#     """
#     execute_query(query)

# # Fonction pour exécuter la deuxième requête
# def query2():
#     query = """
#     SELECT c.Nom, em.flight_nbr, cl.windspeed
#     FROM Client c
#     INNER JOIN Adoption a ON c.IdClient = a.IdClient
#     INNER JOIN EntiteMobile em ON a.flight_nbr = em.flight_nbr
#     INNER JOIN Climat cl ON em.flight_nbr = cl.flight_nbr
#     INNER JOIN Position p ON cl.flight_nbr = p.flight_nbr AND cl.request_datetime = p.flight_time
#     WHERE cl.windspeed > 40;
#     """
#     execute_query(query)

# Connection à la base de données ### À CHANGER SI SUR WINDOWS ###
conn = sqlite3.connect("/Users/margaritabozhinova/Desktop/Hiver 2023/IFT 2821/Projet/Application/db_locale.db")

# Création de la fenêtre
window = tk.Tk()
window.title("Application de base de données")

# Requete 1: vitesse du vent moyenne
def query1_new_window():
     
    # Toplevel object which will
    # be treated as a new window
    newWindow = tk.Toplevel(window)
 
    # sets the title of the
    # Toplevel widget
    newWindow.title("Vitesse du vent moyenne pour un vol")
 
    # sets the geometry of toplevel
    newWindow.geometry("200x200")
    
    #nom_client = ent_client.get()
    flight_nbr = ent_flight.get()
    
    query = """SELECT flight_nbr,
            AVG(windspeed) AS avg_windspeed 
            FROM Climat  
            WHERE flight_nbr = '""" + flight_nbr +"""';"""
            
    r_set = conn.execute(query)
    
    # Print as a grid in the new window
    i=0 
    for ligne in r_set: 
        for j in range(len(ligne)):
            e = tk.Entry(newWindow, width=10, fg='blue') 
            e.grid(row=i, column=j) 
            e.insert(tk.END, ligne[j])
        i=i+1


# Entrée du vol:
flight_entry = tk.Frame(master=window)
lbl_flight = tk.Label(master=flight_entry, text="Numéro de vol:")
ent_flight = tk.Entry(master=flight_entry, width=10)


# Création des widgets
query1_button = tk.Button(window, text="Vitesse moyenne du vent lors du vol", command= query1_new_window)

# Placement des widgets
lbl_flight.pack(pady=5)
ent_flight.pack(side = tk.LEFT)

flight_entry.pack(pady=5)

query1_button.pack(pady=10)


# Lancement de la boucle principale
window.mainloop()

# Fermeture de la connexion à la base de données
conn.close()