import psycopg2
import os
 
DB_USER = os.getenv('DB_USER')
DB_PASS = os.getenv('DB_PASS')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')
 
connection = psycopg2.connect(user     = DB_USER,
                              password = DB_PASS,
                              host     = DB_HOST,
                              port     = DB_PORT,
                              database = DB_NAME
                              )
 
def insertAuditLog(login, operation):
  try:
    cursor = connection.cursor()
 
    postgres_insert_query = """ INSERT INTO backend_logs (DATE, LOGIN, OPERATION) VALUES (%s,%s,%s)"""
    record_to_insert = ("now", login, operation)
    cursor.execute(postgres_insert_query, record_to_insert)
 
    connection.commit()
    count = cursor.rowcount
    print(count, "Record inserted successfully into mobile table")
 
  except (Exception, psycopg2.Error) as error:
    print("Failed to insert record into mobile table", error)
 
  finally:
    if connection:
      cursor.close()
      connection.close()
      print("PostgreSQL connection is closed")