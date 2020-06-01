# look into being able to check if member data is used already for test

from lib.py.common import get_auts, regions
from lib.py.gui import CardFrame, EditableTreeview, center
from lib.py.postgres import DatabaseConnBase, IntegrityError, ProgrammingError

import os
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


class DatabaseConn(DatabaseConnBase):

    def insert_row(self, aut, test, region, parameter, argument):
        try:
            cursor = self.conn.cursor()
            q = "insert into {}.data (test, region, parameter, argument) values (%s, %s, %s, %s)".format(aut)
            cursor.execute(q, (test, region, parameter, argument))
            self.conn.commit()
        except IntegrityError as e:
            tkMessageBox.showerror('Error', 'Unable to create duplicate entry.')
            self.conn.commit()
            return False
        return True

    def modify_row(self, aut, test, region, parameter, argument, key):
        try:
            cursor = self.conn.cursor()
            q = "update {}.data set parameter=%s,argument=%s where test=%s and region=%s and parameter=%s".format(aut)
            cursor.execute(q, (parameter, argument, test, region, key))
            self.conn.commit()
        except IntegrityError as e:
            tkMessageBox.showerror('Error', 'Unable to create duplicate entry.')
            self.conn.commit()
            return False
        return True

    def delete_row(self, aut, test, region, key):
        try:
            cursor = self.conn.cursor()
            q = "delete from {}.data where test=%s and region=%s and parameter=%s".format(aut)
            cursor.execute(q, (test, region, key))
            self.conn.commit()
        except IntegrityError as e:
            # tkMessageBox.showerror('Error', 'Unable to create duplicate entry.')
            self.conn.commit()
            return False
        return True

    def get_test_data(self, aut, region, test):
        try:
            cursor = self.conn.cursor()
            q = 'select parameter, argument from {}.data where test = %s and region = %s'.format(aut)
            print('query: {}  test: {}  region: {}'.format(q, test, region))
            cursor.execute(q, (test, region))
        except ProgrammingError as e:
            self.conn.rollback()
            tkMessageBox.showerror('Error', str(e))
            return
        records = cursor.fetchall()
        return records


class TestDataEditor(tk.Tk):

    def __init__(self):
        tk.Tk.__init__(self)

        self.main_frame = None
        # Some combos
        self.aut_combo = None
        self.region_combo = None
        self.argument_combo = None
        self.parameter_combo = None
        self.test_tree = None

        # string vars
        self.active_suite = tk.StringVar()
        self.active_suite_tests = tk.StringVar()

        self.initialize()
        self.protocol("WM_DELETE_WINDOW", self.on_exit)
        # style = ttk.Style()
        # style.theme_settings("default", {
        #    "TCombobox": {
        #        "configure": {"padding": 25}
        #    }
        # })

        self.dbc = DatabaseConn()
        self.dbc.connect()
        self.aut_combo.event_generate('<<ComboboxSelected>>')

    def initialize(self):
        self.title('Edit Test Data')
        center(self, 1000, 700)
        root = tk.PanedWindow(self, orient=tk.HORIZONTAL, sashpad=4, sashrelief=tk.RAISED)

        # tests frame
        # ====
        tests_frame = tk.Frame(root)

        # aut combobox
        self.aut_combo = ttk.Combobox(tests_frame, state='readonly')
        self.aut_combo['values'] = get_auts()
        self.aut_combo.bind('<<ComboboxSelected>>', self.refresh_tests)
        self.aut_combo.current(0)
        self.aut_combo.grid(row=0, column=0, sticky='ew', padx=5, pady=5)

        # test tree frame
        tf = tk.Frame(tests_frame)
        self.test_tree = ttk.Treeview(tf, selectmode='browse')
        ysb = ttk.Scrollbar(tf, orient='vertical', command=self.test_tree.yview)
        self.test_tree.configure(yscroll=ysb.set)
        self.test_tree.heading('#0', text='Tests', anchor='center')
        self.test_tree.bind('<<TreeviewSelect>>', self.refresh_test_data)
        self.test_tree.grid(row=0, column=0, sticky='nsew')
        ysb.grid(row=0, column=1, sticky='ns')
        tf.rowconfigure(0, weight=1)
        tf.columnconfigure(0, weight=1)
        tf.grid(row=1, column=0, sticky='nsew', padx=5, pady=5)

        # filter
        # self.test_filter = tk.StringVar()
        # test_filter_edit = tk.Entry(tests_frame, textvariable=self.test_filter)
        # test_filter_edit.grid(row=2, column=0, columnspan=2, sticky='ew', padx=5, pady=5)
        # self.test_filter.trace('w', self.on_test_filter_changed)

        tests_frame.rowconfigure(1, weight=1)
        tests_frame.columnconfigure(0, weight=1)
        # root.add
        # tests_frame.grid(row=0, column=0, sticky='nsew', padx=5, pady=5)

        # data frame
        # ====
        self.right_pane = CardFrame(root)
        data_frame = tk.Frame(self.right_pane)

        # region combobox
        self.region_combo = ttk.Combobox(data_frame, state='readonly')
        self.region_combo['values'] = regions
        self.region_combo.bind('<<ComboboxSelected>>', self.refresh_test_data)
        self.region_combo.current(0)
        self.region_combo.grid(row=0, column=0, columnspan=2, sticky='ew', padx=5, pady=5)

        # data tree frame
        self.data_view_data = EditableTreeview(data_frame, selectmode='browse')
        self.data_view_data['show'] = 'headings'
        self.data_view_data['columns'] = ('parameter', 'argument')
        # self.data_view_data.column('parameter', width=200)
        # self.data_view_data.column('argument', width=200)
        self.data_view_data.heading('parameter', text='Parameter')
        self.data_view_data.heading('argument', text='Argument')
        self.data_view_data.bind('<<TreeviewSelect>>', self.refresh_data_entry)
        # self.data_view_data.set_save_callback(self.submit_data_changes)
        self.data_view_data.grid(row=1, column=0, columnspan=2, sticky='nsew', padx=5, pady=5)

        # def on_entry_changed(row, col, old_val, new_val):
        self.data_view_data.on_entry_changed = self.on_entry_changed
        self.data_view_data.delete_row = self.delete_row

        data_frame.columnconfigure(0, weight=1)
        data_frame.columnconfigure(1, weight=1)
        data_frame.rowconfigure(1, weight=1)
        # data_frame.grid(row=0, column=0, sticky='nsew', padx=5, pady=5)
        self.right_pane.add('test_data', data_frame)

        # Test Suite: <suite>
        # Tests in Suite: <testcount>

        test_suite_pane = tk.Frame(self.right_pane)
        # suite name
        suite_label = tk.Label(test_suite_pane, text='Test Suite:')
        suite_label.grid(row=0, column=0, sticky='e', padx=20, pady=20)
        suite_value = tk.Label(test_suite_pane, textvariable=self.active_suite)
        suite_value.grid(row=0, column=1, stick='w', padx=20, pady=20)
        # test count
        count_label = tk.Label(test_suite_pane, text='Tests in Suite:')
        count_label.grid(row=1, column=0, sticky='e', padx=20, pady=20)
        count_value = tk.Label(test_suite_pane, textvariable=self.active_suite_tests)
        count_value.grid(row=1, column=1, stick='w', padx=20, pady=20)
        self.right_pane.add('suite_data', test_suite_pane)

        root.add(tests_frame)
        root.add(self.right_pane)
        root.paneconfigure(tests_frame, minsize=400)
        root.paneconfigure(self.right_pane, minsize=400)
        root.pack(fill=tk.BOTH, expand=True)

    def on_exit(self):
        self.dbc.disconnect()
        self.destroy()

    def refresh_regions(self):
        self.refresh_tests()

    def refresh_tests(self, event=None):
        aut = self.aut_combo.get()
        suite = TestSuiteFactory(os.path.join('test', aut))
        for i in self.test_tree.get_children():
            self.test_tree.delete(i)

        self.walk_tests(self.test_tree, suite, '')

        self.refresh_test_data()

    def walk_tests(self, tv, suite, parent):
        parent = tv.insert(parent, 'end', text=suite.name, open=True)
        for t in suite.tests:
            tv.insert(parent, 'end', text=t.name, open=True)
        for p in suite.suites:
            self.walk_tests(tv, p, parent)
        # filter_ = self.test_filter.get()
        # new_parent = None
        # for t in suite.tests:
        #     if filter_:
        #         if filter_.lower() in t.name.lower():
        #             if not new_parent:
        #                 new_parent = tv.insert(parent, 'end', text=suite.name, open=True)
        #             tv.insert(new_parent, 'end', text=t.name, open=True)
        #     else:
        #         if not new_parent:
        #             print('parent: {}'.format(parent))
        #             print('suite name: {}'.format(suite.name))
        #             new_parent = tv.insert(parent, 'end', text=suite.name, open=True)
        #         tv.insert(new_parent, 'end', text=t.name, open=True)
        #
        # for p in suite.suites:
        #     self.walk_tests(tv, p, new_parent)

    def process_update(self, data_row, parameter, argument=None):
        pass

    def process_insert(self, data_row, parameter, argument):
        pass

    def on_test_filter_changed(self, *args):
        print(args)

    def delete_row(self, rowid):
        idx = self.test_tree.selection()
        if len(idx) == 0:
            return
        test = self.test_tree.item(idx, 'text')
        # get the selected aut
        aut = self.aut_combo.get()
        # get the selected region
        region = self.region_combo.get()
        # get the row

        row_data = self.data_view_data.item(rowid)
        idx = self.data_view_data.index(rowid)
        if idx == 0:
            next = 0
        else:
            next = idx - 1
        print('idx: {}'.format(idx))
        print('next: {}'.format(next))

        is_new = 'new' in row_data['tags']
        if is_new:
            return

        param_key = row_data['values'][0]
        self.dbc.delete_row(aut, test, region, param_key)

        self.refresh_test_data()
        # self.refresh_data_tree(None)
        #
        last = self.data_view_data.get_children()[next]
        self.data_view_data.selection_set(last)

    def on_entry_changed(self, row, col, old_val, new_val):
        # get the test selected on the left
        idx = self.test_tree.selection()
        if len(idx) == 0:
            return
        test = self.test_tree.item(idx, 'text')
        # get the selected aut
        aut = self.aut_combo.get()
        # get the selected region
        region = self.region_combo.get()
        # get the row
        data_row = self.data_view_data.item(row)

        # check if we're inserting a new row
        if col == '#1':
            parameter = new_val
            try:
                argument = data_row['values'][1]
            except IndexError:
                argument = ''
        else:
            try:
                parameter = data_row['values'][0]
            except IndexError:
                parameter = ''
            argument = new_val

        is_new = 'new' in data_row['tags']
        if is_new:
            self.dbc.insert_row(aut, test, region, parameter, argument)
        else:
            param_key = data_row['values'][0]
            self.dbc.modify_row(aut, test, region, parameter, argument, param_key)

        self.refresh_test_data()
        l = self.data_view_data.get_children()
        for idx in l:
            item = self.data_view_data.item(idx)
            if 'new' in item['tags']:
                if is_new:
                    self.data_view_data.selection_set(idx)
                break
            try:
                parameter_ = item['values'][0]
            except IndexError:
                parameter_ = ''
            try:
                argument_ = item['values'][1]
            except IndexError:
                argument_ = ''
            if parameter_ == parameter and argument_ == argument:
                self.data_view_data.selection_set(idx)
                break

    def clear_test_data(self):
        for idx in self.data_view_data.get_children():
            self.data_view_data.delete(idx)

    def refresh_test_data(self, event=None):
        tree = self.test_tree
        idx = tree.selection()
        if not idx:
            return
        if tree.get_children(idx):
            self.show_suite_data()
        else:
            self.populate_data()

    def show_suite_data(self):
        tree = self.test_tree
        idx = tree.selection()
        test = tree.item(idx)['text']
        self.active_suite.set(test)
        count = len(tree.get_children(idx))
        self.active_suite_tests.set(count)
        self.right_pane.show('suite_data')

    def populate_data(self):
        self.right_pane.show('test_data')

        tree = self.test_tree
        idx = tree.selection()
        test = tree.item(idx)['text']
        region = self.region_combo.get()

        aut = self.aut_combo.get().lower()

        records = self.dbc.get_test_data(aut, region, test)

        # clear tree first
        self.clear_test_data()
        # now populate it
        print('Length of Results: %s' % len(records))
        for r in records:
            print('var: {}  type: {}'.format(r[1], type(r[1])))
            self.data_view_data.insert('', 'end', values=(r[0], r[1]))
        self.data_view_data.insert('', 'end', tags=('new'))
        self.data_view_data.tag_configure('new', background='#ececec')

    def refresh_data_entry(self, event):
        idx = self.data_view_data.selection()
        item = self.data_view_data.item(idx)
        if 'new' in item['tags']:
            self.data_view_data.tag_configure('new', background='')
        else:
            self.data_view_data.tag_configure('new', background='#ececec')

    def set_results_edit(self, event):
        tree = event.widget
        item = tree.selection()
        test_or_suite = tree.item(item)['text']
        self.run_results_location.set(test_or_suite)


if __name__ == '__main__':
    l = TestDataEditor()
    l.mainloop()

