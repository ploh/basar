import csv
import os
import yaml



DATA_FILE = '/home/peter/Dropbox/peter/basar_documents/2019_09/data_20200202_065700.yml'


if __name__ == '__main__':
    with open(DATA_FILE) as f:
        data = list(yaml.safe_load_all(f))

    for doc in data:
        if 'users' in doc:
            user_doc = doc['users']
            break

    user_fields = user_doc['columns']

    users = []
    for u in user_doc['records']:
        user = {}
        for field, u_val in zip(user_fields, u):
            user[field] = u_val
        users.append(user)

    users.sort(key=lambda u: u['old_number'] or -1)

    for u in users:
        if u.get('old_number'):
            u_str = ','.join([
                "{}{:02d}".format(u['old_initials'], u['old_number']),
                "{} {}".format(u['first_name'], u['last_name']),
                u['email'],
            ])
            print(u_str)
