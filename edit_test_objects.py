from __future__ import print_function
from collections import defaultdict, OrderedDict
from lib.py.common import get_auts
from lib.py.gui import center
from lib.py.postgres import DatabaseConnBase, IntegrityError, ProgrammingError, InternalError
import hashlib
import sys
if sys.version_info[0] < 3:
    import Tkinter as tk
    import tkMessageBox
    import ttk
else:
    import tkinter as tk
try:
    from robot.testdoc import TestSuiteFactory
except ImportError as e:
    tkMessageBox.showerror('Error', 'Robot Framework is not installed!')
    sys.exit(1)


class TestObject(object):

    def __init__(self, aut='', keyword='', parentframe='', id_type='', id_value=''):
        self.aut = aut
        self.keyword = keyword
        self.parentframe = parentframe
        self.id_type = id_type
        self.id_value = id_value


class DatabaseConn(DatabaseConnBase):

    def create_object(self, aut, keyword=None, parent=None, id=None, value=None):
        try:
            c = self.conn.cursor()
            c.execute('insert into "{}".objects (keyword,parent,id,value) values (%s,%s,%s,%s)'.format(aut.lower()), (keyword, parent, id, value))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def delete_object(self, aut, keyword):
        try:
            c = self.conn.cursor()
            c.execute('delete from {}.objects where keyword=%s'.format(aut.lower()), (keyword,))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def get_object_data(self, aut, keyword):
        try:
            c = self.conn.cursor()
            c.execute('select keyword, parentframe, id, value from {}.objects where keyword=%s'.format(aut.lower()), (keyword,))
            records = c.fetchone()
        except (ProgrammingError, IntegrityError) as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return TestObject(aut=aut)

        if len(records) == 0:
            return TestObject(aut=aut)

        parentframe = '' if records[1] is None else records[1]
        id_type = '' if records[2] is None else records[2]
        id_value = '' if records[3] is None else records[3]

        return TestObject(aut, keyword, parentframe, id_type, id_value)

    def set_object_parent(self, aut, keyword, new_parent):
        c = self.conn.cursor()
        try:
            c.execute('update {}.objects set parent=%s where keyword=%s'.format(aut.lower()), (new_parent, keyword))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            c.close()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def set_object_keyword(self, aut, keyword, new_keyword):
        c = self.conn.cursor()
        try:
            c.execute('update {}.objects set keyword=%s where keyword=%s'.format(aut.lower()), (new_keyword, keyword))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            c.close()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def set_object_id(self, aut, keyword, id_):
        try:
            with self.conn.cursor() as c:
                c.execute('update {}.objects set id=%s where keyword=%s'.format(aut.lower()), (id_, keyword))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def update_object(self, aut, old_keyword, new_keyword, parent, id_type, id_value):
        query = 'update {}.objects set keyword=%s,parentframe=%s,id=%s,value=%s where keyword=%s'.format(aut.lower())
        try:
            with self.conn.cursor() as c:
                c.execute(query, (new_keyword, parent, id_type, id_value, old_keyword))
            self.conn.commit()
        except (ProgrammingError, IntegrityError, InternalError) as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return False
        return True

    def get_all_objects(self, aut):
        query = 'select keyword, parentframe from {}.objects order by keyword'.format(aut.lower())
        try:
            with self.conn.cursor() as c:
                c.execute(query)
                records = c.fetchall()
        except Exception as e:
            self.conn.rollback()
            tkMessageBox.showerror('Database Error', str(e))
            return None
        return records


class ObjectDataFrame(tk.Frame):

    def __init__(self, parent, dbc, test_object, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, relief=tk.SUNKEN, borderwidth=1, **kwargs)

        self.dbc = dbc
        self.aut = test_object.aut
        self.obj_name = test_object.keyword
        self.obj_parent = test_object.parentframe
        self.id_type = test_object.id_type
        self.id_value = test_object.id_value

        # object_data_frm = tk.LabelFrame(data_frame, text='Object Details')
        self.save_btn = tk.Button(self, text='Save', state='disabled', command=self.save)
        self.save_btn.grid(row=0, column=2, rowspan=4, sticky='nsew')

        # Name
        name_lbl = tk.Label(self, text='Keyword:')
        name_lbl.grid(row=0, column=0, sticky='e', padx=(50, 5), pady=5)

        self.name_val = tk.StringVar()
        self.name_val.set(self.obj_name)
        self.name_val.trace('w', lambda name, index, mode, sv=self.name_val: self.on_obj_keyword_filter_changed())

        self.name_cmbox = ttk.Combobox(self, textvariable=self.name_val)
        self.name_cmbox.bind('<Tab>', lambda *ignore: self.parent_combo.event_generate('<Button-1>'))
        self.name_cmbox.bind('<Return>', lambda *ignore: self.parent_combo.event_generate('<Button-1>'))
        # self.parent_combo.bind('<<ComboboxSelected>>', self.update_object_parent)
        # self.parent_combo.bind('<FocusOut>', self.update_object_parent)
        self.name_cmbox.grid(row=0, column=1, sticky='ew', padx=5, pady=5)

        # Parent
        parent_label = tk.Label(self, text='Frame:')
        parent_label.grid(row=1, column=0, sticky='e', padx=5, pady=5)

        self.parent_val = tk.StringVar()
        self.parent_val.set(self.obj_parent)
        self.parent_val.trace('w', lambda name, index, mode, sv=self.parent_val: self.on_obj_parent_filter_changed())

        self.parent_combo = ttk.Combobox(self, textvariable=self.parent_val)
        self.parent_combo.bind('<Tab>', lambda *ignore: self.parent_combo.event_generate('<Button-1>'))
        self.parent_combo.bind('<Return>', lambda *ignore: self.parent_combo.event_generate('<Button-1>'))
        # self.parent_combo.bind('<<ComboboxSelected>>', self.update_object_parent)
        # self.parent_combo.bind('<FocusOut>', self.update_object_parent)
        self.parent_combo.grid(row=1, column=1, sticky='ew', padx=5, pady=5)

        identifier_type_lbl = tk.Label(self, text='Strategy:')
        identifier_type_lbl.grid(row=2, column=0, sticky='e', padx=5, pady=5)

        type_vals = ['id', 'css', 'xpath', 'name']
        self.identifier_type_combo = ttk.Combobox(self, state='readonly', values=type_vals)
        self.identifier_type_combo.bind('<<ComboboxSelected>>', self.on_object_value_changed)
        # self.identifier_type_combo.bind('<FocusOut>', self.update_object_parent)
        self.identifier_type_combo.grid(row=2, column=1, sticky='ew', padx=5, pady=5)
        # try:
        self.identifier_type_combo.set(self.id_type)
        # except:
        #     print('err: {}'.format(obj_name))
        #     print('id_type: {}'.format(id_type))
        #     return

        identifier_text_lbl = tk.Label(self, text='Locator:')
        identifier_text_lbl.grid(row=3, column=0, sticky='ne', padx=5, pady=5)

        self.identifier_text = tk.Text(self, height=3)
        # self.identifier_text.bind('<Return>', lambda *ignore: self.parent_combo.event_generate('<Button-1>'))
        # self.identifier_text.bind('<<ComboboxSelected>>', self.update_object_parent)
        # self.identifier_text.bind('<FocusOut>', self.update_object_parent)
        self.identifier_text.bind('<KeyRelease>', self.on_object_value_changed)
        self.identifier_text.grid(row=3, column=1, sticky='ew', padx=5, pady=5)
        print('setting id_val: "{}"'.format(self.id_value))
        self.set_identifier_text(self.id_value)

        self.columnconfigure(1, weight=1)

    def on_obj_keyword_filter_changed(self, event=None):
        records = self.dbc.get_all_objects(self.aut)
        g = self.name_val.get()
        keyword = self.obj_name
        gl = ['']
        for r in records:
            if g.lower() == r[0].lower()[:len(g)]:
                if keyword != r:
                    gl.append(r[0])
        self.name_cmbox['values'] = gl
        self.on_object_value_changed()

    def on_obj_parent_filter_changed(self, event=None):
        records = self.dbc.get_all_objects(self.aut)
        g = self.parent_val.get()
        keyword = self.obj_name
        gl = ['']
        for r in records:
            if g.lower() == r[0].lower()[:len(g)]:
                if keyword != r:
                    gl.append(r[0])
        self.parent_combo['values'] = gl
        self.on_object_value_changed()

    def on_object_value_changed(self, event=None):
        if self.check_all_for_changes():
            self.save_btn.config(state='normal')
        else:
            self.save_btn.config(state='disabled')

    def check_all_for_changes(self):
        if self.obj_name != self.name_val.get():
            print('Object Name: "{}" != "{}"'.format(self.obj_name, self.name_val.get()))
            return True
        elif self.obj_parent != self.parent_combo.get():
            print('Object Parent: "{}" != "{}"'.format(self.obj_parent, self.parent_combo.get()))
            return True
        elif self.id_type != self.identifier_type_combo.get():
            print('Object ID Type: "{}" != "{}"'.format(self.id_type, self.identifier_type_combo.get()))
            return True
        elif self.id_value != self.identifier_text.get(1.0, 'end').encode('utf8')[:-1]:
            print('Object ID Value: "{}" != "{}"'.format(self.id_value, self.identifier_text.get(1.0, 'end').encode('utf8')[:-1]))
            return True
        else:
            return False

    def set_enabled(self, enable=True):
        if enable:
            self.name_cmbox.config(state='normal')
            self.parent_combo.config(state='normal')
            self.identifier_type_combo.config(state='normal')
            self.identifier_text.config(state='normal')
        else:
            self.name_cmbox.config(state='disabled')
            self.parent_combo.config(state='disabled')
            self.identifier_type_combo.config(state='disabled')
            self.identifier_text.config(state='disabled')

    def set_identifier_text(self, value):
        self.identifier_text.delete(1.0, tk.END)
        self.identifier_text.insert(1.0, value)

    def get_locator(self):
        return self.identifier_text.get(1.0, 'end').encode('utf8')[:-1]

    def save(self):
        aut = self.aut.lower()
        old_keyword = self.obj_name
        new_keyword = self.name_val.get()
        parent_frame = self.parent_val.get()
        id_type = self.identifier_type_combo.get()
        id_val = self.get_locator()

        if self.obj_name == '':
            print('new object')
            if not self.dbc.create_object(aut, new_keyword, parent_frame, id_type, id_val):
                return
        else:
            print('old object: {}'.format(old_keyword))
            if not self.dbc.update_object(aut, old_keyword, new_keyword, parent_frame, id_type, id_val):
                return






class TestObjectEditor(tk.Tk):

    def __init__(self):
        tk.Tk.__init__(self)

        self._clipboard = None
        self.active_object = None
        self.active_object_id = None
        self.active_object_keyword = None
        self.active_objects = defaultdict(OrderedDict)
        self.title('Edit Test Objects')
        center(self, 1000, 700)
        root = tk.PanedWindow(self, orient=tk.HORIZONTAL, sashpad=4, sashrelief=tk.RAISED)

        # objects frame
        object_frame = tk.Frame(root)

        # aut combobox
        self.aut_combo = ttk.Combobox(object_frame, state='readonly')
        self.aut_combo['values'] = get_auts()
        self.aut_combo.bind('<<ComboboxSelected>>', self.on_aut_selected)
        self.aut_combo.current(0)
        self.aut_combo.grid(row=0, column=0, columnspan=2, sticky='ew', padx=5, pady=5)

        # filter
        self.object_filter = tk.StringVar()
        object_filter_edit = tk.Entry(object_frame, textvariable=self.object_filter)
        object_filter_edit.grid(row=1, column=0, columnspan=2, sticky='ew', padx=5, pady=5)
        self.object_filter.trace('w', lambda name, index, mode, sv=self.object_filter: self.on_object_filter_changed())

        # object tree frame
        tf = tk.Frame(object_frame)
        self.object_tree = ttk.Treeview(tf, selectmode='browse')
        ysb = ttk.Scrollbar(tf, orient='vertical', command=self.object_tree.yview)
        self.object_tree.configure(yscroll=ysb.set)
        self.object_tree.heading('#0', text='Objects', anchor='center')
        self._object_cache = []

        # when a selection is made in object tree, change the active object information on the right
        self.object_tree.bind('<Button-3>', self.post_refresh_menu)
        self.object_tree.bind('<<TreeviewSelect>>', self.on_object_selected)
        self.object_tree.bind('<Double-Button-1>', self.on_double_click)

        self.object_tree.grid(row=0, column=0, sticky='nsew')
        ysb.grid(row=0, column=1, sticky='ns')
        tf.rowconfigure(0, weight=1)
        tf.columnconfigure(0, weight=1)
        tf.grid(row=2, column=0, columnspan=2, sticky='nsew', padx=5, pady=5)

        self.new_object_btn = tk.Button(object_frame, text='New', command=self.on_new_object_btn_pressed)
        self.new_object_btn.grid(row=3, column=0, sticky='ew', padx=5, pady=5)

        self.refresh_btn = tk.Button(object_frame, text='Refresh', command=self.refresh_objects)
        self.refresh_btn.grid(row=3, column=1, sticky='ew', padx=5, pady=5)

        object_frame.rowconfigure(2, weight=1)
        object_frame.columnconfigure(0, weight=1)
        object_frame.columnconfigure(1, weight=1)

        # root.add
        # tests_frame.grid(row=0, column=0, sticky='nsew', padx=5, pady=5)

        # data frame
        data_frame = tk.Frame(root)

        # region combobox
        self.region_combo = ttk.Combobox(data_frame, state='disabled')
        # self.region_combo['values'] = regions
        # self.region_combo.bind('<<ComboboxSelected>>', self.refresh_test_data)
        # self.region_combo.current(0)
        self.region_combo.grid(row=0, column=0, columnspan=2, sticky='ew', padx=5, pady=5)

        self.active_object_frm = tk.Frame(data_frame)
        self.active_object_frm.columnconfigure(0, weight=1)
        self.active_object_frm.grid(row=1, column=0, sticky='new', padx=10, pady=10)

        temp_frm = tk.LabelFrame(data_frame, text='Cached Objects')

        my_objects_cvs = tk.Canvas(temp_frm)
        self.cached_object_frm = tk.Frame(temp_frm)
        self.cached_object_frm.columnconfigure(0, weight=1)
        # self.cached_object_frm.grid(row=0, column=0, sticky='nsew', padx=10, pady=10)
        self.ysb = ttk.Scrollbar(temp_frm, orient='vertical', command=my_objects_cvs.yview)
        self.ysb.grid(row=0, column=1, sticky='ns')
        my_objects_cvs.configure(yscrollcommand=self.ysb.set)
        my_objects_cvs.rowconfigure(0, weight=1)
        my_objects_cvs.columnconfigure(0, weight=1)

        _id = my_objects_cvs.create_window((0, 0), window=self.cached_object_frm, anchor='nw', tags='self.cached_object_frm')

        def _config_interior(event):
            min_height = self.cached_object_frm.winfo_reqheight()
            # print('bbox: {}'.format(self.cached_object_frm.bbox('all')))
            if temp_frm.winfo_height() >= min_height:
                self.ysb.grid_remove()
            else:
                self.ysb.grid(row=0, column=1, sticky='ns')

            size = (self.cached_object_frm.winfo_reqwidth(), self.cached_object_frm.winfo_reqheight())
            my_objects_cvs.config(scrollregion='0 0 {} {}'.format(*size))
            if self.cached_object_frm.winfo_reqwidth() != self.cached_object_frm.winfo_width():
                my_objects_cvs.config(width=self.cached_object_frm.winfo_reqwidth())

        self.cached_object_frm.bind('<Configure>', _config_interior)

        def _config_canvas(event):
            if self.cached_object_frm.winfo_reqwidth() != my_objects_cvs.winfo_width():
                my_objects_cvs.itemconfigure(_id, width=my_objects_cvs.winfo_width())

        my_objects_cvs.bind('<Configure>', _config_canvas)
        my_objects_cvs.grid(row=0, column=0, sticky='nsew', padx=(0, 5), pady=(5, 0))

        temp_frm.rowconfigure(0, weight=1)
        temp_frm.columnconfigure(0, weight=1)
        temp_frm.grid(row=2, column=0, sticky='nsew', padx=5, pady=5)

        data_frame.columnconfigure(0, weight=1)
        data_frame.rowconfigure(2, weight=1)

        # Test Suite: <suite>
        # Tests in Suite: <testcount>

        root.add(object_frame)
        root.add(data_frame)
        root.paneconfigure(object_frame, minsize=400)
        root.paneconfigure(data_frame, minsize=400)
        root.pack(fill=tk.BOTH, expand=True)

        self.dbc = DatabaseConn()
        self.dbc.connect()

        self.protocol("WM_DELETE_WINDOW", self._on_exit)
        self.aut_combo.event_generate('<<ComboboxSelected>>', when='tail')

    # object treeview
    def on_object_selected(self, event=None):
        idx = self.object_tree.selection()
        if len(idx) == 0:
            return
        if idx == self.active_object_id:
            return
        row_data = self.object_tree.item(idx)
        if 'new' in row_data['tags']:
            self.new_object()
            return

        keyword = row_data['text']
        aut = self.aut_combo.get()
        test_object = self.dbc.get_object_data(aut, keyword)

        self.active_object_id = idx
        self.active_object_keyword = keyword
        if self.active_object:
            self.active_object.grid_forget()

        self.active_object = ObjectDataFrame(self.active_object_frm, self.dbc, test_object)
        self.active_object.grid(row=0, column=0, sticky='new', padx=5, pady=5)

        aut_objs = self.active_objects[aut]
        for key, obj in aut_objs.items():
            if key == keyword:
                obj.set_enabled(False)
            else:
                obj.set_enabled()

    def refresh_cached_objects(self):
        for aut_objects in self.active_objects.values():
            for key, obj in aut_objects.items():
                print('refreshing: {}'.format(key))
                obj.pack_forget()

        aut = self.aut_combo.get()
        aut_objects = self.active_objects[aut]
        for key, obj in aut_objects.items():
            print('refreshing: {}'.format(key))
            obj.pack(fill='x', padx=10, pady=5)

    def on_new_object_btn_pressed(self):
        idx = self.object_tree.get_children()[-1]
        item = self.object_tree.item(idx)
        assert 'new' in item['tags']
        self.object_tree.selection_set(idx)
        self.object_tree.see(idx)
        self.new_object()

    def new_object(self):
        aut = self.aut_combo.get()
        self.active_object_id = None
        self.active_object_keyword = None
        if self.active_object:
            self.active_object.grid_forget()
        self.active_object = ObjectDataFrame(self.active_object_frm, self.dbc, TestObject(aut=aut))
        self.active_object.grid(row=0, column=0, sticky='new', padx=5, pady=5)

    def post_refresh_menu(self, event):
        rowid = self.object_tree.identify_row(event.y)
        menu = tk.Menu(self, tearoff=0)
        menu.add_command(label='Create Child', command=lambda: self.on_create_child_selected(rowid))
        menu.add_command(label='Delete', command=lambda: self.on_delete_object_selected(rowid))
        menu.post(event.x_root, event.y_root)

    def on_create_child_selected(self, rowid):
        item = self.item(rowid)
        new_item_text = item['text'] + ' - Child'
        parent = self.item(rowid)['text']

        if not self.main.create_child(new_item_text, '', parent):
            tkMessageBox.showerror('Error', str(e))
            return

        tree = self.object_tree
        idx = tree.insert(rowid, 'end', text=new_item_text)
        tree.selection_set(idx)
        tree.see(idx)
        self.refresh_objects()

    def on_duplicate_object_selected(self, rowid):
        tree = self.object_tree
        item = tree.item(rowid)
        new_item_text = item['text'] + ' - Sibling'
        parent_idx = tree.parent(rowid)
        parent = tree.item(parent_idx)['text']
        if not self.db.add_object(self._current_aut, new_item_text, self.object_type_combo.get(), parent):
            tkMessageBox.showerror('Error', 'Error adding object sibling')
            return
        properties = self.db.get_object_properties(self._current_aut, item['text'])
        for p in properties:
            if not self.db.add_object_property(self._current_aut, new_item_text, p[0], p[1]):
                tkMessageBox.showerror('Error', 'Error adding sibling property')
                return
        idx = tree.insert(parent_idx, 'end', text=new_item_text)
        tree.selection_set(idx)
        tree.see(idx)
        self.refresh_objects()

    def on_delete_object_selected(self, rowid):
        if rowid == '':
            return
        item = self.object_tree.item(rowid)
        if 'new' in item['tags']:
            return
        keyword = item['text']
        if not tkMessageBox.askyesno('Confirm Delete', 'Delete "{}" object?'.format(keyword)):
            return
        keyword = item['text']
        aut = self.aut_combo.get()
        if not self.dbc.delete_object(aut, keyword):
            return
        next_row = self.object_tree.next(rowid)
        if 'new' in self.object_tree.item(next_row)['tags']:
            next_row = self.object_tree.prev(rowid)
        self.object_tree.delete(rowid)
        self.object_tree.selection_set(next_row)
        self.refresh_objects()
        # t.event_generate('<<TreeviewSelect>>')

    def on_double_click(self, event):
        """
        Executed, when a row is double-clicked.
        """
        # what row and column was clicked on
        tree = self.object_tree
        rowid = tree.identify_row(event.y)
        row = tree.item(rowid)
        if 'new' in row['tags']:
            return
        keyword = row['text']
        aut = self.aut_combo.get()
        aut_objs = self.active_objects[aut]
        if keyword in aut_objs:
            print('object already cached!')
            return

        idx = len(aut_objs)
        test_object = self.dbc.get_object_data(aut, keyword)
        new_obj = ObjectDataFrame(self.cached_object_frm, self.dbc, test_object)
        # new_obj.grid(row=idx, column=0, sticky='nsew', padx=10, pady=10)
        new_obj.pack(fill='x', padx=10, pady=5)

        x, y, width, height = self.bbox()
        close_btn = tk.Button(new_obj, text='X', command=lambda: self.close_object(aut, keyword))
        close_btn.place(x=x, y=y, bordermode='outside')

        aut_objs[keyword] = new_obj
        print('active object keyword: {}'.format(self.active_object_keyword))
        print('keyword: {}'.format(keyword))
        if self.active_object_keyword == keyword:
            new_obj.set_enabled(False)

    def close_object(self, aut, keyword):
        print('closing object: {}'.format(keyword))
        aut_objs = self.active_objects[aut]
        obj = aut_objs[keyword]
        obj.pack_forget()
        del aut_objs[keyword]

    def on_aut_selected(self, event=None):
        self.refresh_objects()
        self.refresh_cached_objects()

    def on_object_filter_changed(self):
        self.refresh_objects()

    def refresh_objects(self):
        aut = self.aut_combo.get()

        # first save what object is selected so it can be highlighted afterwards
        s = self.object_tree.selection()
        if len(s) > 0:
            saved_k = self.object_tree.item(s, 'text')
        else:
            saved_k = ''

        q = self.object_filter
        records = self.dbc.get_all_objects(aut)

        # clear the visible tree and the object cache
        for idx in self.object_tree.get_children():
            self.object_tree.delete(idx)
        self._object_cache = []

        # apply filter
        d = {}
        for r in records:
            d[r[0]] = r[1]

        filtered_list = []
        if q is not None and q.get() != '':
            for k in d:
                if q.get().lower() in k.lower():
                    filtered_list.append(k)
            # for k in d:
            #     if d[k][1] is not None:
            #         if q.get().lower() in d[k][1].lower():
            #             qd[k] = d[k]
        else:
            filtered_list = d.keys()

        new_selection = None
        self._object_cache.append({})
        filtered_list.sort()
        for k in filtered_list:
            o = self.add_object_to_tree(d, k)
            # check if this was the selection before the refresh
            if k == saved_k:
                new_selection = o

        if len(self.object_tree.get_children()) > 0:
            if new_selection is not None:
                self.object_tree.selection_set(new_selection)
                self.object_tree.see(new_selection)
            else:
                self.object_tree.selection_set(self.object_tree.get_children()[0])

        self.object_tree.insert('', 'end', text='<New Object>', tags='new')
        self.object_tree.tag_configure('new', background='#ececec', foreground='#000000')

    def add_object_to_tree(self, parent_dict, keyword, object_hierarchy=None):
        object_hierarchy = object_hierarchy if object_hierarchy else []

        if keyword in self._object_cache[0]:
            return self._object_cache[0][keyword]

        if keyword not in parent_dict:
            print('The object "{}" was not found in the objects table.'.format(keyword))
            return ''

        parent = parent_dict[keyword]
        if parent:
            if parent in object_hierarchy:
                print('An infinite recursion error occurred with this object: {}'.format(keyword))
                parent = ''
            else:
                object_hierarchy.append(parent)
                if parent in self._object_cache[0]:
                    parent = self._object_cache[0][parent]
                else:
                    parent = self.add_object_to_tree(parent_dict, parent_dict[keyword], object_hierarchy=object_hierarchy)
                    if parent is None:
                        print('Error inserting object "{}"'.format(parent_dict[keyword]))
                        return ''

        print('parent: {}'.format(parent))
        print('keyword: {}'.format(keyword))

        parent = '' if parent is None else parent
        self._object_cache[0][keyword] = self.object_tree.insert(parent, 'end', text=keyword, open=True)
        return self._object_cache[0][keyword]

    def create_object(self, rowid, text):
        t = self.object_tree
        # if self.tree_contains(self.object_tree, text, col=0):
        if text in self._object_cache[0]:
            tkMessageBox.showerror('Error', 'Keyword already exists.')
            return
        objecttype = self.object_type_combo.get()
        parent = self.parent_combo.get()
        if not self.db.add_object(self._current_aut, text, objecttype, parent):
            tkMessageBox.showerror('Error', 'Could not insert object')
            return
        t.delete(rowid)
        idx = t.insert('', 'end', text=text)
        t.insert('<New Object>', 'end', tags='new')
        t.tag_configure('new', background='#ececec', foreground='#000000')
        t.selection_set(idx)

    def create_child(self, keyword, parent):
        return self.db.add_object(self._current_aut, keyword, '', parent)

    def _on_exit(self):
        self.dbc.disconnect()
        self.destroy()


if __name__ == '__main__':
    l = TestObjectEditor()
    l.mainloop()
