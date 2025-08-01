import csv
from ics import Calendar, Event
from datetime import datetime

def csv_to_ics(csv_file, ics_file):
    calendar = Calendar()
    with open(csv_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            event = Event()
            event.name = row['Event Name']
            event.begin = datetime.strptime(f"{row['Date']} {row['Start Time']}", "%Y-%m-%d %I:%M %p")
            event.end = datetime.strptime(f"{row['Date']} {row['End Time']}", "%Y-%m-%d %I:%M %p")
            event.location = row['Location']
            calendar.events.add(event)
    with open(ics_file, 'w') as my_file:
        my_file.writelines(calendar)

csv_to_ics('events.csv', 'events.ics')