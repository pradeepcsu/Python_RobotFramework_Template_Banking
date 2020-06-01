import sys

import py.postgres


class TestObject(object):

    def __init__(self, obj_keyword, obj_parent, obj_type, obj_id, obj_value):
        self.obj_keyword = obj_keyword
        self.obj_parent = obj_parent
        self.obj_type = obj_type
        self.obj_id = obj_id
        self.obj_value = obj_value


d = {}


def load_objects(aut):
    """Loads objects from the AUT object database."""
    con = None
    cur = None
    try:
        con = py.postgres.connect_db()
        cur = con.cursor()
        cur.execute("select keyword, parentframe, objecttype, id, value from "+aut+".objects")
        results = cur.fetchall()

        for row in results:
            # Temporary until object_ids is merged into objects table.
            oid = row[3]
            if row[2] == 'TeField' and oid != 'id':
                cur.execute("select id, value from host.object_ids where object_ids.object = %s", (row[0],))
                id_results = cur.fetchall()
                for id_row in id_results:
                    if str(id_row[0]) == 'start row':
                        r = int(id_row[1])
                    elif str(id_row[0]) == 'start column':
                        c = int(id_row[1])

                oid = str((r - 1) * 80 + c - 1)

            d[row[0]] = TestObject(row[0], row[1], row[2], oid, row[4])
    except:
        raise
    finally:
        if cur:
            cur.close()
        if con:
            con.close()


def get_object_id(keyword):
    """Retrieves the locator for an object stored in the OR database."""

    obj_id = d[keyword].obj_id
    obj_value = d[keyword].obj_value

    return obj_id + '=' + obj_value


def get_parents(obj_keyword, parent_type):
    """Returns the keyword of a parent of the object with a certain type."""

    parents = []
    parent = d[obj_keyword].obj_parent
    while parent != '':
        if d[parent].obj_type == parent_type:
            parents.append(parent)
        parent = d[parent].obj_parent
    if parents:
        parents.reverse()
    return parents


if __name__ == '__main__':
    args = sys.argv
    if len(args) != 2:
        print('Usage: python ObjectRepository.py <aut>')
        sys.exit()

    if args[1] not in ['myBranch', 'Omnia', 'Mobile', 'QuickApprove']:
        print(args[1] + ' is not a defined AUT.')
        sys.exit()

    load_objects(args[1])
    for k, v in d.iteritems():
        print(v.obj_keyword, v.obj_parent, v.obj_type, v.obj_id, v.obj_value)
