import pytest 
import requests
import json
import uuid 
import os

@pytest.fixture 
def books_api_endpoint():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    full_path = os.path.join(dir_path, 'infrastructure/tf-outputs.json')
    with open(full_path, 'r') as outputs_file:
        outputs = json.load(outputs_file)

    endpoint = outputs['api_invoke_url']['value']
    return f'{endpoint}/books'


def test_create_book(books_api_endpoint):
    post_data = {
        'title': 'title POST',
        'author': 'author POST' 
    }
    headers = {'Content-Type': 'application/json'}

    response = requests.post(books_api_endpoint, data=json.dumps(post_data), headers=headers)
    body = response.json()

    assert response.status_code == 200
    assert 'book_id' in body 


def test_get_book(books_api_endpoint):
    book_id = '16fc9742-21c5-48a1-a5c1-054aa65beb9a'
    get_response = requests.get(f'{books_api_endpoint}/{book_id}')
    get_response_body = get_response.json() 

    assert get_response.status_code == 200
    assert get_response_body.get('book_id', None) == book_id
    assert get_response_body.get('title') == 'title GET'
    assert get_response_body.get('author') == 'author GET'
    

# def test_get_books(books_api_endpoint):
#     get_response = requests.get(books_api_endpoint)
#     get_response_body = get_response.json() 

#     assert len(get_response_body) >= 2 

#     book_ids = [item['book_id'] for item in get_response_body]
#     assert '221701b8-9569-4db2-a3c3-2f3ebc29d3bb' in book_ids
#     assert '1bf0ef3c-c0e9-4422-9abf-9c6d438916f3' in book_ids 


def test_put_book(books_api_endpoint):
    book_id = '1befb57b-cb72-470b-844f-fda69f806d3b'
    put_data = {
        'title': 'title updated',
        'author': 'author updated'
    }
    headers = {'Content-Type': 'application/json'}
    put_url = f'{books_api_endpoint}/{book_id}'
    put_response = requests.put(put_url, data=json.dumps(put_data), headers=headers)
    put_response_body = put_response.json()

    assert put_response.status_code == 200
    assert put_response_body.get('book_id', None) == book_id
    assert put_response_body.get('title', None) == 'title updated'
    assert put_response_body.get('author', None) == 'author updated' 