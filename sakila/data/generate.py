import random

import psycopg2
import psycopg2.extras
from faker import Faker

# Insert into film
#  (film_id,title,description,release_year,language_id,original_language_id,rental_duration,rental_rate,length,replacement_cost,rating,special_features,last_update)
# Values
#  ('1','ACADEMY DINOSAUR','A Epic Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies','2006','1',NULL,'6','0.99','86','20.99','PG',string_to_array('Deleted Scenes,Behind the Scenes',','),'2006-02-15 05:03:42.000')
# ;

insert_film_query = 'insert into film (title, description, release_year, language_id, rental_duration, rental_rate, length,replacement_cost, rating) values %s'
insert_film_category_query = 'insert into film_category (film_id, category_id) values %s'
insert_actor_query = 'insert into actor (first_name, last_name) values %s'

release_years = [i for i in range(1980, 2020)]
language_ids = [i for i in range(1, 7)]
rental_durations = [i for i in range(0, 100)]
lengths = [i for i in range(1, 300)]
replacement_consts = [i for i in range(5, 60)]
ratings = ['NC-17', 'R', 'PG-13', 'G']

category_ids = [i for i in range(1, 17)]
film_ids = [i for i in range(1, 1001)]
new_film_ids = [i for i in range(5000, 30000)]


def generate_movies(number_of_entries=10):
    fake = Faker()
    data = []
    for _ in range(number_of_entries):
        title = fake.name()
        description = fake.text()
        release_year = random.choice(release_years)
        language_id = random.choice(language_ids)
        original_language_id = random.choice(language_ids)
        rental_duration = random.choice(rental_durations)
        length = random.choice(lengths)
        replacement_cost = random.choice(replacement_consts)
        rating = random.choice(ratings)
        data.append((title, description, release_year, language_id, original_language_id, rental_duration, length,
                     replacement_cost, rating))
    return data


def generate_film_categories(number_of_entries=10):
    data = []
    for _ in range(number_of_entries):
        film_id = new_film_ids.pop()
        category = random.choice(category_ids)
        data.append((film_id, category))
    return data


def generate_actors(number_of_entries=10):
    fake = Faker()
    data = []
    for _ in range(number_of_entries):
        name = fake.name().split(" ")
        first_name = name[0]
        last_name = name[1]
        data.append((first_name, last_name))
    return data


def run():
    connection_string = "host='172.17.2' dbname='dvdrental' user='postgres' password='mysecretpassword'"
    connection = psycopg2.connect(connection_string)
    cursor = connection.cursor()
    # movies = generate_movies(100000)
    actors = generate_actors(60000)
    # film_categories = generate_film_categories(20000)
    # psycopg2.extras.execute_values(cursor, insert_film_query, movies, template=None, page_size=100)
    # psycopg2.extras.execute_values(cursor, insert_film_category_query, film_categories, template=None, page_size=100)
    psycopg2.extras.execute_values(cursor, insert_actor_query, actors, template=None, page_size=100)
    connection.commit()


if __name__ == "__main__":
    run()
