from datetime import datetime
import pandas as pd

saturday_df = pd.read_csv('data_2023-02-11.csv', sep=";")
sunday_df = pd.read_csv('data_2023-02-12.csv', sep=";")

weekend_report = pd.concat([saturday_df, sunday_df], ignore_index=True)

# Assuming the task would be scheduled every Monday
weekend_report['generation_date'] = datetime.now().strftime('%Y-%m-%d')

# Include current weekend number in title
weekend_report.to_csv(f'weekend_{datetime.now().isocalendar()[1]}_report.csv', sep=";")

