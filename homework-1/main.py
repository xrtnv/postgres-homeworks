"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2
from psycopg2 import sql


def create_connection():
    """
    Функция для создания подключения к PostgreSQL
    :return: подключение к PostgreSQL
    """
    return psycopg2.connect(
        host="localhost",
        database="north",
        user="postgres",
        password="asBF_13cam"
    )


def execute_query(connection, query):
    """
    Функция для выполнения SQL-запросов
    :param connection:
    :param query:
    :return:
    """
    with connection.cursor() as cursor:
        cursor.execute(query)
    connection.commit()

def insert_data_from_csv(connection, table_name, csv_file):
    """
    Функция для вставки данных из CSV в таблицу PostgreSQL
    :param connection:
    :param table_name:
    :param csv_file:
    :return:
    """
    with open(csv_file, 'r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        columns = reader.fieldnames
        query = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
            sql.Identifier(table_name),
            sql.SQL(', ').join(map(sql.Identifier, columns)),
            sql.SQL(', ').join([sql.Placeholder()] * len(columns))  # Изменение здесь
        )

        with connection.cursor() as cursor:
            for row in reader:
                cursor.execute(query, list(row.values()))  # Изменение здесь

        connection.commit()

if __name__ == "__main__":
    try:
        # Создаем подключение
        connection = create_connection()

        # Заполняем таблицы данными из CSV
        insert_data_from_csv(connection, "customers", "north_data/customers_data.csv")
        insert_data_from_csv(connection, "employees", "north_data/employees_data.csv")
        insert_data_from_csv(connection, "orders", "north_data/orders_data.csv")

        print("Данные успешно добавлены в таблицы.")
    except Exception as e:
        print(f"Произошла ошибка: {e}")
    finally:
        if connection:
            connection.close()
