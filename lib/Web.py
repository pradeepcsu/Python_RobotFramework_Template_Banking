import pdb
import random
import re
import string
import sys
import time
from datetime import datetime
from datetime import timedelta
from decimal import Decimal

from robot.libraries.BuiltIn import BuiltIn
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import UnexpectedAlertPresentException
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.alert import Alert
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select

import ObjectRepository
import py.postgres

DEFAULT_TIMEOUT = 20


class Web(object):

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.aut = ''
        self.windows = []
        self.frames = []
        self.last_clicked = None
        self.last_action = []
        self.screenshots = False

    def save_batch(self, *batch_vars):
        test_name = BuiltIn().run_keyword('get variable value', '${TEST NAME}')
        aut = self.aut
        suite = 'temp'
        kw = {}
        for var in batch_vars:
            val = BuiltIn().run_keyword('get variable value', '${' + var + '}')
            kw[var] = val
            print('variable  "{}" value is "{}".'.format(var, kw[var]))
        py.postgres.save_batch_vars(aut, suite, test_name, **kw)

    def load_batch(self, test_name):
        aut = self.aut
        suite = 'temp'
        batch_vars = py.postgres.load_batch_vars(aut, suite, test_name)
        for var in batch_vars:
            BuiltIn().run_keyword('set test variable', '${' + var[0] + '}', var[1])

    def screenshot_page(self):
        # if not self.screenshots:
        #     return
        tmp = self.get_random_alphanumeric_string(16)
        BuiltIn().run_keyword('Capture Page Screenshot', tmp+'.png')

    def fail_test(self, reason):
        raise NotImplementedError

    def debug_test(self):
        for attr in ('stdin', 'stdout', 'stderr'):
            setattr(sys, attr, getattr(sys, '__%s__' % attr))
        pdb.set_trace()
        print('starting dbg')

    def pause_testing(self, duration=5):
        time.sleep(int(duration))
    
    def close_alert(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        try:
            Alert(driver).dismiss()
        except:
            print('No alert present.')
        
    def get_object_text(self, keyword, timeout=DEFAULT_TIMEOUT):
        obj = self._get_object(keyword)
        return obj.text
    
    def get_object_value(self, keyword, timeout=DEFAULT_TIMEOUT):
        obj = self._get_object(keyword)
        return obj.get_attribute('value')

    def get_table_cell_value(self, keyword, row, column, timeout=DEFAULT_TIMEOUT):
        print(keyword)
        print(row)
        print(column)
        table = self._get_object(keyword)
        return table.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, column)).text
    
    def get_test_args(self, aut, test, region):
        v = {}
        dbc = None
        cur = None
        try:
            dbc = py.postgres.connect_db()
            cur = dbc.cursor()
            cur.execute("select parameter, argument from "+aut+".data where test = %s and region = %s", (test, region))
            results = cur.fetchall()
            for row in results:
                v[row[0]] = row[1]
        except:
            raise
        finally:
            if cur:
                cur.close()
            if dbc:
                dbc.close()
        return v

    def load_test_data(self, aut, test, region):
        # use QAT data by default
        d = self.get_test_args(aut, test, 'qa')
        for k, v in d.iteritems():
            BuiltIn().run_keyword('Set Test Variable', '${' + k + '}', v)

        # overwrite with region specific data if exists
        d = self.get_test_args(aut, test, region)
        for k, v in d.iteritems():
            BuiltIn().run_keyword('Set Test Variable', '${' + k + '}', v)

    def get_table_row_count(self, keyword, timeout=DEFAULT_TIMEOUT):
        obj = self._get_object(keyword)
        rows = len(obj.find_elements_by_xpath('.//tbody/tr'))
        return rows

    def match_row(self, table, row, col_dict):
        for col_name, col_value in col_dict.items():
            col_idx = self.get_column_index_by_header(table, col_name)
            if not col_idx:
                self.fail_test("'{}' column not found in table '{}'.".format(col_name))
            found = table.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, col_idx)).text
            if found != col_value:
                print("Row did not match:  row: {}  target: {}  found: {}".format(row, col_value, found))
                return False
        return True

    def find_table_row_matching(self, keyword, col_dict, timeout=DEFAULT_TIMEOUT):
        """

        :param keyword:
        :param col_dict: A dictionary containing the table header names with the expected row values.
        :param timeout:
        :return: The last row matching all values specified.
        """
        start_time = time.time()
        while True:
            result = 0
            try:
                print('find_table_row_matching: new attempt')
                rows = self.get_table_row_count(keyword)
                table = self._get_object(keyword)
                for row in xrange(1, rows + 1):
                    print('looking at row: {}'.format(row))
                    if self.match_row(table, row, col_dict):
                        result = row
                return result
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def find_table_row_with_text_in_column(self, text, keyword, col_idx=None, col_name=None, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()

        while True:
            try:
                table = self._get_object(keyword)
                if col_name:
                    col_idx = self.get_column_index_by_header(table, col_name)
                    if not col_idx:
                        self.fail_test('{} column not found.'.format(col_name))
                rows = self.get_table_row_count(keyword)
                print("Looking for '%s' in column %s of table %s with %s rows." % (text, col_idx, keyword, rows))
                for row in xrange(1, rows + 1):
                    print('row: {}'.format(row))
                    t = table.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, col_idx)).text
                    print('t: {}'.format(t))
                    if t == text:
                        print("Match at row {}".format(row))
                        # BuiltIn().run_keyword('Capture Page Screenshot')
                        self.screenshot_page()
                        return row
                return 0
            except Exception as e:
                print(str(e))
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def get_column_index_by_header(self, table, header, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                cols = table.find_elements_by_xpath('.//tr[1]/th')
                for col_idx in xrange(1, len(cols) + 1):
                    # print('looking at header: {}'.format(cols[col_idx-1].text))
                    if cols[col_idx-1].text == header:
                        return col_idx
                return 0
            except Exception as e:
                time.sleep(1)
                print(str(e))
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def _get_object(self, keyword, required=True, timeout=DEFAULT_TIMEOUT):
        # uncomment below ONLY when you add @ before for all objects. eg: LogIn_UserID should be @LogIn_UserID
        #keyword = keyword[1:]
        #print('keyword is {}'.format(keyword))
        if keyword not in ObjectRepository.d:
            raise Exception('Object keyword not found: {}'.format(keyword))

        cache = BuiltIn().get_library_instance('Selenium2Library')
        start_time = datetime.now()
        try:
            object_id = self.get_object_id_and_select_frame(keyword)
            while True:
                obj = cache._element_find(object_id, True, False)
                if obj is not None:
                    return obj
                elif not required:
                    return None
                time.sleep(1)
                object_id = self.get_object_id_and_select_frame(keyword, reset=True)
                if (datetime.now() - start_time).total_seconds() > timeout:
                    self.fail_test("_get_object: timed out selecting '"+keyword+"'.")
        except UnexpectedAlertPresentException:
            msg = BuiltIn().run_keyword('Get Alert Message')
            self.fail_test('_get_object: alert appeared: %s' % msg)

    def get_object_id_and_select_frame(self, keyword, reset=False):
        """Retrieves the locator for an object stored in the OR database."""

        frames = ObjectRepository.get_parents(keyword, 'Frame')
        if reset:
            BuiltIn().run_keyword('Unselect Frame')
            for frame in frames:
                BuiltIn().run_keyword('Select Frame', ObjectRepository.d[frame].obj_value)
                self.frames.append(frame)
        else:
            idx = 0
            if len(frames) < len(self.frames):
                BuiltIn().run_keyword('Unselect Frame')
                self.frames = []
            else:
                for i in xrange(0, len(self.frames)):
                    if self.frames[i] != frames[i]:
                        break
                    idx = i + 1
                if idx < len(self.frames):
                    BuiltIn().run_keyword('Unselect Frame')
                    self.frames = []
            try:
                for i in xrange(idx, len(frames)):
                    BuiltIn().run_keyword('Select Frame', ObjectRepository.d[frames[i]].obj_value)
                    self.frames.append(frames[i])
            except:
                BuiltIn().run_keyword('Unselect Frame')
                for frame in frames:
                    BuiltIn().run_keyword('Select Frame', ObjectRepository.d[frame].obj_value)
                    self.frames.append(frame)

        object_id = ObjectRepository.get_object_id(keyword)
        return object_id

    def wait_for(self, keyword, displayed=True, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            obj = self._get_object(keyword)
            if obj is not None:
                if not displayed:
                    break
                if obj.is_displayed():
                    break
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Wait For')

    def menu_click_select(self, key1, key2, verify=None, wait=0, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            self.click_on(key1, timeout=5, wait=wait, verify=key2)
            self.click_on(key2, timeout=5, wait=wait)
            if verify is None:
                return
            start_time_i = datetime.now()
            while (datetime.now()-start_time_i).total_seconds() < 5:
                time.sleep(1)
                print('in loop')
                if self.check_exists(verify):
                    return
                print('check failed')
            try:
                self.click_on(key2, timeout=0, wait=0)
            except Exception as e:
                print(str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Menu Click Select: Timed out.')

    def hover_and_select(self, key1, key2, verify=None, wait=0, timeout=DEFAULT_TIMEOUT):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        cache = BuiltIn().get_library_instance('Selenium2Library')

        start_time = datetime.now()
        while True:
            obj1 = self._get_object(key1)
            object_id = self.get_object_id_and_select_frame(key2)
            obj2 = cache._element_find(object_id, True, False)
            obj1.click()
            ActionChains(driver).move_to_element(obj1).perform()
            time.sleep(1)
            obj2 = cache._element_find(object_id, True, False)
            #ActionChains(driver).move_to_element(obj2).perform()
            for i in xrange(0, 5):
                try:
                    time.sleep(1)
                    obj2.click()
                    return
                except:
                    pass
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Menu Click Select: Timed out.')

    def click_if_exists(self, keyword, timeout=DEFAULT_TIMEOUT, verify=None):
        start_time = time.time()
        # browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        # locator = ObjectRepository.d[keyword].obj_value

        while True:
            try:
                if self._get_object(keyword) is not None:
                    self.screenshot_page()
                    print("Clicking on '%s'." % keyword)
                    self._get_object(keyword).click()
                    # browser.execute_script("$('#{}').trigger('click')".format(locator))
                    return
                    # if verify is None:
                    #     return
                    # if self.check_exists(verify):
                    #     return
                    # print('Verify did not pass.')
                else:
                    print("Did not find '%s'." % keyword)
                    return
            except Exception as e:
                print('Error: ' + str(e))
            time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Click On: Timed out.')

    def click_on(self, keyword, timeout=DEFAULT_TIMEOUT, verify=None):
        start_time = time.time()

        while True:
            try:
                self.wait_for_ready_state()
                if self._get_object(keyword) is not None:
                    self.screenshot_page()
                    print("Clicking on '%s'." % keyword)

                    self._get_object(keyword).click()

                    time.sleep(0.5)
                    return
                    # if verify is None:
                    #     return
                    # if self.check_exists(verify):
                    #     return
                    # print('Verify did not pass.')
                else:
                    print("Did not find '%s'." % keyword)
            except Exception as e:
                print('Error: ' + str(e))
            time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Click On: Timed out.')

    def click_on_js(self, keyword, timeout=DEFAULT_TIMEOUT, js=None):
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        locator = ObjectRepository.d[keyword].obj_value

        start_time = time.time()
        while True:
            try:
                if self._get_object(keyword) is not None:
                    # self.screenshot_page()
                    print("Clicking on '%s'." % keyword)
                    if js is not None:
                        print('doing js')
                        browser.execute_script("$('#{}').trigger('click')".format(locator))
                    else:
                        browser.execute_script("$('#{}').trigger('focus')".format(locator))
                        self._get_object(keyword).click()
                        # browser.execute_script("$('#{}').trigger('blur')".format(locator))
                    return
                else:
                    print("Did not find '%s'." % keyword)
                    time.sleep(1)
            except Exception as e:
                print('Error: ' + str(e))
            time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Click On: Timed out.')

    def object_should_not_be_visible(self, keyword, timeout=DEFAULT_TIMEOUT, wait=0, iwait=0, verify=None):
        if wait:
            time.sleep(wait)
        cache = BuiltIn().get_library_instance('Selenium2Library')
        start_time = datetime.now()
        while True:
            try:
                if self._get_object(keyword) is not None:
                    # page might be reacting at this point
                    if iwait:
                        time.sleep(iwait)
                    print("Clicking on '%s'." % keyword)
                    result = self._get_object(keyword).is_displayed()
                    if result:
                        return result
                    print("Element not visible '%s'." % keyword)
                    if verify is None:
                        return
                    time.sleep(int(wait))
                    if self.check_exists(verify):
                        return
                    print('Verify did not pass.')
                else:
                    print("Did not find '%s'." % keyword)
            except Exception as e:
                print('Error: ' + str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Element not visible: Timed out.')

    def enter_text_js(self, key, text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        locator = ObjectRepository.d[key].obj_value

        while True:
            try:
                # self.wait_for_ready_state()
                if self._get_object(key) is not None:
                    # time.sleep(0.5)
                    # self._get_object(key).send_keys(Keys.BACKSPACE)
                    # browser.execute_script("$('#{}').trigger('focus')".format(locator))
                    # browser.execute_script("$('#{}').trigger('change')".format(locator))
                    # self._get_object(key).click()
                    # self._get_object(key).send_keys(Keys.BACKSPACE)
                    # self.wait_for_ready_state()
                    # browser.execute_script("$('#{}').trigger('change')".format(locator))
                    # time.sleep(0.5)
                    # browser.execute_script("$('#{}').trigger('focus')".format(locator))
                    self._get_object(key).click()
                    # time.sleep(0.5)

                    # browser.execute_script("$('#{}').trigger('keypress')".format(locator))
                    #time.sleep(0.5)
                    # self._get_object(key).clear()
                    # time.sleep(0.5)
                    # browser.execute_script("$('#{}').trigger('change')".format(locator))
                    browser.execute_script("$('#{}').value='{}';".format(locator, text))
                    browser.execute_script("$('#{}').trigger('change')".format(locator))
                    # time.sleep(0.5)
                    # self.wait_for_ready_state()
                    # time.sleep(1.0)
                    # self._get_object(key).send_keys(text)
                    # time.sleep(0.5)
                    # browser.execute_script("$('#{}').trigger('change')".format(locator))
                    # time.sleep(0.5)
                    browser.execute_script("$('#{}').trigger('blur')".format(locator))
                    # time.sleep(0.5)
                    # self.wait_for_ready_state()
                    # time.sleep(0.5)
                    return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Enter Text: Timed out.')

    def wait_for_ready_state(self, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        while True:
            ready_state = browser.execute_script('return document.readyState')
            if ready_state == 'complete':
                break
            print('wait for ready state: not ready: {}'.format(ready_state))
            time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('wait for ready state: timed out.')

    def enter_text(self, key, text, wait=0, click_first=None, timeout=DEFAULT_TIMEOUT):
        if wait:
            time.sleep(wait)
        start_time = datetime.now()
        if click_first:
            self.click_on(click_first)
            
        while True:
            try:
                if self._get_object(key) is not None:
                    self._get_object(key).clear()
                    self._get_object(key).send_keys(Keys.BACKSPACE)
                    self._get_object(key).send_keys(text)
                    result = self._get_object(key).get_attribute('value')
                    if result == text:
                        print("Entered Text '%s'." % result)
                        return
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    print("Existing text '%s' does not match text entered '%s'" % (result, text))
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Enter Text: Timed out.')

    def send_keys(self, keyword, text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            print("Typing text '%s' into text field '%s'" % (text, keyword))
            try:
                obj = self._get_object(keyword)
                print('about to send')
                obj.send_keys(text)
                return
            except Exception as e:
                time.sleep(0.5)
                print('Error: '+str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Send Keys: Timed out.')

    def click_type(self, keyword, text, if_empty=False, verify=False, if_not=None, wait=0, timeout=DEFAULT_TIMEOUT):
        if wait:
            time.sleep(wait)
        start_time = datetime.now()
        while True:
            print("Typing text '%s' into text field '%s'" % (text, keyword))
            try:
                obj = self._get_object(keyword)
                if if_not is not None:
                    val = obj.get_attribute('value')
                    if val != if_not:
                        return
                obj.click()
                time.sleep(0.25)
                obj.clear()
                time.sleep(0.25)
                obj = self._get_object(keyword)
                obj.send_keys(text)
                if not verify:
                    return
                time.sleep(0.25)
                obj = self._get_object(keyword)
                val = obj.get_attribute('value')
                if val == text:
                    return
                print('Send Keys: Text did not get entered correctly.')
                obj.clear()
            except Exception as e:
                time.sleep(0.5)
                print('Error: '+str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Click Type: Timed out.')

    def toggle_checkbox(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                print('toggle_checkbox: {}'.format(keyword))
                checkbox = self._get_object(keyword)
                checkbox.click()
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                return
            except Exception as e:
                print(str(e))
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def set_checkbox(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                checkbox = self._get_object(keyword)
                print('set_checkbox: is_selected: {}'.format(checkbox.is_selected()))
                if not checkbox.is_selected():
                    checkbox.click()
                print('set_checkbox: is_selected: {}'.format(checkbox.is_selected()))
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                return
            except Exception as e:
                print(str(e))
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def unset_checkbox(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                checkbox = self._get_object(keyword)
                print('set_checkbox: is_selected: {}'.format(checkbox.is_selected()))
                if checkbox.is_selected():
                    checkbox.click()
                print('set_checkbox: is_selected: {}'.format(checkbox.is_selected()))
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                return
            except Exception as e:
                print(str(e))
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def select_radio_option(self, group, value, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                BuiltIn().run_keyword('Select Radio Button', group, value)
                return
            except Exception as e:
                print('Error: ' + str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def select_list_item_by_index(self, keyword, index, wait=0, timeout=30):
        """Selects an item from a list."""
        if wait:
            time.sleep(wait)
        start_time = datetime.now()
        while True:
            try:
                obj = self._get_object(keyword)
                if obj.is_enabled():
                    print("Selecting item with index %s from list '%s'." % (index, keyword))
                    Select(obj).select_by_index(int(index))
                    return
            except Exception as e:
                print('Error: '+str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item By Index: Timed out.')

    def select_list_item(self, keyword, label, confirm=False, wait=0, if_not=None, timeout=DEFAULT_TIMEOUT):
        """Selects an item from a list."""
        if wait:
            time.sleep(wait)
        start_time = datetime.now()
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        while True:
            try:
                ready_state = browser.execute_script('return document.readyState')
                if ready_state != 'complete':
                    print('ready_state: {}'.format(ready_state))
                    time.sleep(1)
                else:
                    if if_not is not None:
                        val = Select(self._get_object(keyword)).first_selected_option.text
                        if val != if_not:
                            return
                    if self._get_object(keyword).is_enabled():
                        print("Selecting %s from list '%s'." % (label, keyword))
                        Select(self._get_object(keyword)).select_by_visible_text(label)
                        if not confirm:
                            return
                        time.sleep(0.25)
                        if Select(self._get_object(keyword)).first_selected_option.text == label:
                            return
            except Exception as e:
                print('Error: ' + str(e))

            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item: Timed out.')

    def select_list_item_js(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        """Selects an item from a list."""
        start_time = datetime.now()
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        locator = ObjectRepository.d[keyword].obj_value
        print('locator: {}'.format(locator))
        while True:
            try:
                ready_state = browser.execute_script('return document.readyState')
                if ready_state != 'complete':
                    print('ready_state: {}'.format(ready_state))
                    time.sleep(1)
                else:
                    obj = self._get_object(keyword)
                    if obj.is_enabled():
                        print("Selecting '{}' from list '{}'.".format(label, keyword))
                        # browser.execute_script("$('#{}').trigger('change')".format(locator))
                        # time.sleep(0.5)
                        Select(self._get_object(keyword)).select_by_visible_text(label)
                        # time.sleep(0.5)
                        browser.execute_script("$('#{}').trigger('change')".format(locator))
                        browser.execute_script("$('#{}').trigger('blur')".format(locator))
                        # time.sleep(0.5)
                        return
            except Exception as e:
                print(str(e))
                time.sleep(1)

            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item: Timed out.')

    def select_list_item_by_index_js(self, keyword, idx, timeout=DEFAULT_TIMEOUT):
        """Selects an item from a list."""
        start_time = datetime.now()
        browser = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        locator = ObjectRepository.d[keyword].obj_value
        print('locator: {}'.format(locator))
        while True:
            # try:
            obj = self._get_object(keyword)
            if obj.is_enabled():
                print("Selecting item with index '{}' from list '{}'.".format(idx, keyword))
                browser.execute_script("$('#{}').trigger('focus')".format(locator))
                time.sleep(0.5)
                obj = self._get_object(keyword)
                Select(obj).select_by_index(idx)
                time.sleep(0.5)
                browser.execute_script("$('#{}').trigger('change')".format(locator))
                time.sleep(0.5)
                return
            # except Exception as e:
            #     print(str(e))

            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item By Index JS: Timed out.')

    def select_list_item_containing(self, keyword, text, timeout=DEFAULT_TIMEOUT):
        """Selects an item that has text in it's value from a list."""

        start_time = datetime.now()
        while True:
            obj = self._get_object(keyword)
            if obj is not None and obj.is_enabled():
                break
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item Containing: Timed out looking for list.')

        while True:
            opts = Select(obj).options
            for opt in opts:
                if text in opt.text:
                    Select(obj).select_by_visible_text(opt.text)
                    if Select(obj).first_selected_option.text == opt.text:
                        return
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Select List Item Containing: Item could not be selected.')


    def get_element_text(self, obj_keyword, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        reset = False
        while True:
            exception_occurred = False
            try:
                obj_locator = self.get_object_id_and_select_frame(obj_keyword, reset=reset)
                return BuiltIn().run_keyword('Get Text', obj_locator)
            except:
                exception_occurred = True
                reset = True
                if not suppress_error:
                    raise
            if not exception_occurred:
                break
            else:
                time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out.')

    def expect_text_in_table_cell(self, obj_keyword, row, column, expected, lowercase=True, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        if lowercase:
            expected = expected.lower()
        while True:
            exception_occurred = False
            elem = self._get_object(obj_keyword)
            try:
                print("Verifying table cell '{} ({}, {})' contains exactly text '{}'.".format(obj_keyword, row, column, expected))
                actual = elem.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, column)).text
                if lowercase:
                    actual = actual.lower()
                if expected != actual:
                    message = "The text of table cell '{} ({}, {})' should have been '{}' but in fact it was '{}'.".format(obj_keyword, row, column, expected, actual)
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise AssertionError(message)
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def expect_text_containing_in_table_cell(self, obj_keyword, row, column, expected, lowercase=True, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        if lowercase:
            expected = expected.lower()
        while True:
            exception_occurred = False
            elem = self._get_object(obj_keyword)
            try:
                print("Verifying table cell '{} ({}, {})' contains text '{}'.".format(obj_keyword, row, column, expected))
                actual = elem.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, column)).text
                if lowercase:
                    actual = actual.lower()
                if expected in actual:
                    print('expected: {}.'.format(expected))
                    print('actual: {}.'.format(actual))
                    self.screenshot_page()
            except:
                exception_occurred = True
                if not suppress_error:
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def expect_date_in_table_cell(self, obj_keyword, row, column, expected, lowercase=True, expected_fmt='%m/%d/%Y', obj_fmt='%m/%d/%Y', timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        if lowercase:
            expected = expected.lower()
        while True:
            exception_occurred = False
            elem = self._get_object(obj_keyword)
            print('actual element is : {}'.format(elem))
            try:
                print("Verifying table cell '{} ({}, {})' contains exactly text '{}'.".format(obj_keyword, row, column, expected))
                actual = elem.find_element_by_xpath('.//tr[{}]/td[{}]'.format(row, column)).text
                actual = actual.strip()
                actual_dt = datetime.strptime(actual, obj_fmt)
                print('actual date is : {}'.format(actual_dt))
                expected_dt = datetime.strptime(expected, expected_fmt)
                print('expected date is : {}'.format(expected_dt))

                print('actual_dt.date(): {}'.format(actual_dt.date()))
                print('expected_dt.date(): {}'.format(expected_dt.date()))

                if actual_dt.date() != expected_dt.date():
                    print('actual date is : {}'.format(actual_dt))
                    print('expected date is : {}'.format(expected_dt))
                    message = "The date of element '%s' should have been '%s' but in fact it was '%s'." % (obj_keyword, actual_dt.date(), expected_dt.date())

                print("Table cell '{} ({}, {})' contains exactly date '{}'.".format(obj_keyword, row, column, expected_dt.date()))
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def assert_page_contains(self, text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                BuiltIn().run_keyword('Page Should Contain', text)
            except:
                exception_occurred = True
                if not suppress_error:
                    raise
            if not exception_occurred:
                break
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def assert_page_does_not_contain(self, text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                BuiltIn().run_keyword('Page Should Not Contain', text)
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    raise
            if not exception_occurred:
                break
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def expect_date(self, obj_keyword, expected, expected_fmt='%m/%d/%Y', obj_fmt='%m/%d/%Y', timeout=DEFAULT_TIMEOUT):
        """Compares the text retrieved from the object with text given.

        Fails the test if the texts don't match.
        """

        start_time = datetime.now()
        suppress_error = True

        while True:
            exception_occurred = False
            elem = self._get_object(obj_keyword)
            try:
                print("Verifying element '%s' contains exactly text '%s'." % (obj_keyword, expected))
                value = elem.get_attribute('value')
                if value is not None:
                    print("Using element's value.")
                    actual = value
                else:
                    print("Using element's text.")
                    actual = elem.text
                actual = actual.strip()
                actual_dt = datetime.strptime(actual, obj_fmt)
                expected_dt = datetime.strptime(expected, expected_fmt)
                if expected_dt != actual_dt:
                    message = "The date of element '%s' should have been '%s' but in fact it was '%s'." % (obj_keyword, expected, actual)
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise AssertionError(message)
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout / 2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def expect_text(self, obj_keyword, expected, lowercase=True, timeout=DEFAULT_TIMEOUT):
        """Compares the text retrieved from the object with text given.

        Fails the test if the texts don't match.
        """

        start_time = datetime.now()
        suppress_error = True
        if lowercase:
            expected = expected.lower()
        while True:
            exception_occurred = False
            elem = self._get_object(obj_keyword)
            try:
                print("Verifying element '%s' contains exactly text '%s'." % (obj_keyword, expected))
                value = elem.get_attribute('value')
                if value is not None:
                    print("Using element's value.")
                    actual = value
                else:
                    print("Using element's text.")
                    actual = elem.text
                actual = actual.strip()
                if lowercase:
                    actual = actual.lower()
                if expected != actual:
                    message = "The text of element '%s' should have been '%s' but in fact it was '%s'." % (obj_keyword, expected, actual)
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise AssertionError(message)
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def expect_text_contains(self, obj_keyword, expected, case_insensitive=True, timeout=DEFAULT_TIMEOUT):
            """Compares the text retrieved from the object with text given.

            Fails the test if text a does not contain text b.
            """

            start_time = datetime.now()
            suppress_error = True
            expected = str(expected)
            if case_insensitive:
                expected = expected.lower()
            while True:
                exception_occurred = False
                elem = self._get_object(obj_keyword)
                try:
                    print("Verifying element '%s' contains text '%s'." % (obj_keyword, expected))
                    value = elem.get_attribute('value')
                    if value is not None:
                        print("Using element's value.")
                        actual = value
                    else:
                        print("Using element's text.")
                        actual = elem.text
                    actual = actual.strip().replace('\n', ' ')
                    if case_insensitive:
                        actual = actual.lower()
                    if expected not in actual:
                        message = "The text of element '%s' should have contained '%s' but in fact it was '%s'." % (obj_keyword, expected, actual)
                        # BuiltIn().run_keyword('Capture Page Screenshot')
                        self.screenshot_page()
                        raise AssertionError(message)
                except:
                    exception_occurred = True
                    if not suppress_error:
                        # BuiltIn().run_keyword('Capture Page Screenshot')
                        self.screenshot_page()
                        raise
                if not exception_occurred:
                    break
                time.sleep(2)
                if (datetime.now() - start_time).total_seconds() > timeout/2:
                    suppress_error = False
                if (datetime.now() - start_time).total_seconds() > timeout:
                    self.fail_test('Expect Text: Timed out.')

    def expect_text_regex(self, obj_keyword, string, timeout=DEFAULT_TIMEOUT):
        """
        Compares the text retrieved from the object with text given using a regular expression.
        Fails the test if the texts don't match.
        """
        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                elem = self._get_object(obj_keyword)
                print("Verifying element '{}' contains regular expression '{}'.".format(obj_keyword, string))
                if elem.get_attribute('value') is not None:
                    print("Using element's value.")
                    actual = elem.get_attribute('value')
                else:
                    print("Using element's text.")
                    actual = elem.text

                if not re.match(string, actual, re.DOTALL):
                    message = "Element '%s' should have contained regular expression '%s' but "\
                          "its text was '%s'." % (obj_keyword, string, actual)
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise AssertionError(message)
            except:
                exception_occurred = True
                if not suppress_error:
                    raise
            if not exception_occurred:
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text RegEx: Timed out.')

    def check_exists(self, key):
        obj = None
        try:
            print('key is : {}'.format(key))
            obj = self._get_object(key, required=False)
            print('obj is : {}'.format(obj))
        except NoSuchElementException as e:
            print("Error: %s" % str(e))
        except Exception as e:
            print("Error: %s" % str(e))
        finally:
            if obj is None:
                return False
            return True

    def exists(self, obj_keyword, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        suppress_error = True
        reset = False
        while True:
            exception_occurred = False
            try:
                obj_locator = self.get_object_id_and_select_frame(obj_keyword, reset)
                BuiltIn().run_keyword('Page Should Contain Element', obj_locator)
            except:
                exception_occurred = True
                reset = True
                if suppress_error:
                    pass
                else:
                    raise
            if not exception_occurred:
                break
            else:
                time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Exists: Item not found.')

    def wait_for_object(self, obj_keyword, timeout=DEFAULT_TIMEOUT):
        start = datetime.now()
        while True:
            try:
                obj_locator = self.get_object_id_and_select_frame(obj_keyword)
                break
            except Exception as e:
                print('exception: ' + str(e))
                if (datetime.now() - start).total_seconds() > timeout:
                    self.fail_test('Wait For Object: Element not found.')
        end = datetime.now()
        timeout = float(timeout) - (end - start).total_seconds()
        BuiltIn().run_keyword('Wait Until Page Contains Element', obj_locator, timeout)

    def is_new_window(self, wait=1):
        if wait:
            time.sleep(int(wait))
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        return len(driver.window_handles) > len(self.windows)

    def browser_count(self):
        cache = BuiltIn().get_library_instance('Selenium2Library')
        driver = cache._current_browser()
        for window in driver.window_handles:
            pass
        
    def new_window_opened(self, wait=1):
        if wait:
            time.sleep(wait)
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        if len(driver.window_handles) > len(self.windows):
            return True
        return False

    def register_window(self, wait=0, timeout=DEFAULT_TIMEOUT, maximize=False):
        if wait:
            time.sleep(wait)
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        #driver.implicitly_wait(10)
        self.frames = []
        start_time = datetime.now()
        while True:
            time.sleep(1)
            len_sws = len(self.windows)
            len_dws = len(driver.window_handles)
            #if self.alert_present():
            #    BuiltIn().run_keyword('Fail', 'An alert appeared.')
            # remove this?
            if len_sws + 2 == len_dws:
                print('An extra window appeared.')
                print('Registered windows...')
                for w in self.windows:
                    print(w)
                print('Driver windows...')
                for w in driver.window_handles:
                    print(w)
                if (datetime.now() - start_time).total_seconds() > timeout/2:
                    self.fail_test('Register Window: An extra window appeared.')
            if len_sws + 1 == len_dws:
                break
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Register Window: Timed out. len_sws='+str(len(self.windows))+', len_dws='+str(len(driver.window_handles))+'.')

        for window in driver.window_handles:
            if window not in self.windows:
                time.sleep(2)
                self.windows.append(window)
                driver.switch_to_window(window)
                if maximize:
                    BuiltIn().run_keyword('Maximize Browser Window')
                break

    def load_browser(self, maximize=True):
        # testing
        screenshots = BuiltIn().run_keyword('get variable value', '${SCREENSHOTS}')
        if screenshots and screenshots.lower() == 'true':
            print('screenshots: yes')
            self.screenshots = True
        else:
            print('screenshots: no')

        launch = True
        try:
            driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
            self.frames = []
            len_sws = len(self.windows)
            len_dws = len(driver.window_handles)
            if len_sws == len_dws == 1:
                if self.windows[0] == driver.window_handles[0]:
                    driver.switch_to_window(driver.window_handles[0])
                    launch = False
                else:
                    BuiltIn().run_keyword('Close All Browsers')
            elif len_sws == 0 and len_dws == 1:
                hwnd = driver.window_handles[0]
                self.windows.append(hwnd)
                driver.switch_to_window(hwnd)
                if maximize:
                    BuiltIn().run_keyword('Maximize Browser Window')
                launch = False
            elif len_sws > 1:
                BuiltIn().run_keyword('Close All Browsers')
        except Exception as e:
            print('load_browser: error: {}'.format(str(e)))
        finally:
            if launch:
                url = BuiltIn().run_keyword('Get Variable Value', '${URL}')
                browser = BuiltIn().run_keyword('Get Variable Value', '${BROWSER}')
                remote_url = BuiltIn().run_keyword('Get Variable Value', '${REMOTE_URL}')

                print('url: {}'.format(url))
                print('browser: {}'.format(browser))
                print('remote_url: {}'.format(remote_url))

                if remote_url is None or remote_url == 'False':
                    BuiltIn().run_keyword('Open Browser', url, browser)
                else:
                    BuiltIn().run_keyword('Open Browser', url, browser, 'remote_url='+remote_url)
                driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
                hwnd = driver.window_handles[0]
                self.windows = [hwnd]
                print('registered window: {}'.format(hwnd))

    def close_extra_windows(self, timeout=DEFAULT_TIMEOUT):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
    #   try:
        start_time = datetime.now()
        while len(driver.window_handles) > 1:
            #driver.switch_to_window(driver.window_handles[len(driver.window_handles)-1])
            BuiltIn().run_keyword('Close Window')
            self.unregister_window()
            #self.windows.pop()
            driver.switch_to_window(self.windows[len(self.windows) - 1])
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out.')
    #   except:
    #       BuiltIn().run_keyword('Close All Browsers')

        self.windows = []
        self.frames = []

    def unregister_window(self, timeout=DEFAULT_TIMEOUT):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        self.frames = []
        start_time = datetime.now()
        while True:
            if len(self.windows) > len(driver.window_handles):
                print("Popping window '%s'." % (self.windows[len(self.windows)-1]))
                self.windows.pop()
                print("Switching to window '%s'." % (self.windows[len(self.windows)-1]))
                driver.switch_to_window(self.windows[len(self.windows)-1])
                break
            elif len(driver.window_handles) > len(self.windows):
                self.register_window(maximize=False)
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                #BuiltIn().run_keyword('Close Window')
                # need aut specific functions for this?
                #BuiltIn().run_keyword('Click On', 'Dialog_DontSend')
                self.fail_test('An error dialog appeared.')
                self.windows.pop()
                self.windows.pop()
                driver.switch_to_window(self.windows[len(self.windows)-1])
                return
            elif (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out.')
            time.sleep(1)

    def alert_present(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        try:
            driver.switch_to_alert()
            return True
        except UnexpectedAlertPresentException as e:
            return False

    def compare_dates(self, date1, format1, date2, format2):
        # Special case
        if (date1 == '00/00/0000' and date2 == '12/31/1899') or \
           (date2 == '00/00/0000' and date1 == '12/31/1899'):
            print('Match: (' + date1 + ', ' + date2 + ')')
            return

        first = datetime.strptime(date1, format1)
        second = datetime.strptime(date2, format2)
        if first == second:
            print('Match: (' + date1 + ', ' + date2 + ')')
        else:
            self.fail_test('Dates did not match.')

    def get_timestamp(self):
        return datetime.now()

    def get_random_string(self, length):
        return ''.join(random.choice(string.lowercase) for i in range(int(length)))

    def get_random_number_string(self, length):
        return ''.join(random.choice(string.digits) for i in range(int(length)))

    def get_random_alphanumeric_string(self, length):
        return ''.join(random.choice(string.lowercase + string.digits) for i in range(int(length)))

    def get_random_ssn(self):
        """
        Avoid 000, 666, and 900-999 in first part
        Pick any in next three since first part is guranteed from last
        Avoid 00 and 0000 in second and third parts
        Pick any for last three
        """

        ssn = random.sample(set('1234578'), 1)
        ssn += ''.join(random.choice(string.digits) for i in range(3))
        ssn += random.sample(set('123456789'), 2)
        ssn += ''.join(random.choice(string.digits) for i in range(3))
        return ''.join(ssn)

    def accept_alert(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        alert = driver.switch_to_alert()
        alert.accept()

    def click_random_row(self, grid):
        row_count = self.get_table_row_count(grid)
        if not row_count:
            self.fail_test('Click Random Row: Table had no rows.')
        print(str(row_count) + ' rows found.')
        rnd = random.randint(1, row_count)
        row = self._get_object(grid).find_elements_by_xpath('.//tr[{}]'.format(rnd))
        print('Clicking on row {}'.format(rnd))
        row[0].click()

    def get_date(self, date_format='%m/%d/%Y', days_modify=None, delimiter='/', no_pad=False):
        if days_modify is None:
            dt = datetime.now()
        else:
            dt = datetime.now() + timedelta(days=int(days_modify))
        if no_pad:
            return self.remove_zero_padding(dt)
        else:
            return dt.strftime(date_format)

    def remove_zero_padding(self, dt, delimiter='/'):
        return '{d.month}{delimiter}{d.day}{delimiter}{d.year}'.format(d=dt, delimiter=delimiter)

    def verify_currency_in_host(self, web_obj_key, host_obj_key, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')

        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                print("Verifying web element '%s' matches host element '%s'." % (web_obj_key, host_obj_key))
                web_obj = self._get_object(web_obj_key)
                if web_obj.get_attribute('value') is not None:
                    print("Using web element's value.")
                    actual = web_obj.get_attribute('value')
                else:
                    print("Using web element's text.")
                    actual = web_obj.text

                # expected
                expected = host.get_field(host_obj_key)
                print("Unaltered host value: {}".format(expected))
                expected = expected.strip()
                if expected[-1] == '-':
                    expected = '-' + expected[:-1]
                d_expected = Decimal(expected).quantize(Decimal('.00'))
                
                # actual
                if actual[0] == '(' and actual[-1] == ')':
                    actual = '-' + actual[1:-1]
                actual = actual.replace('$', '')
                actual = actual.replace(',', '')
                d_actual = Decimal(actual).quantize(Decimal('.00'))
                
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                if d_expected != d_actual:
                    message = "The text of element '%s' should have been '%s' but in fact it was '%s'." % (web_obj_key, expected, actual)
                    raise AssertionError(message)
                else:
                    print('Values matched: {}'.format(actual))
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def verify_date_in_host(self, web_obj_key, host_obj_key, web_fmt='%m/%d/%Y', host_fmt='%m/%d/%y', timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')

        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                print("Verifying web element '%s' matches host element '%s'." % (web_obj_key, host_obj_key))
                web_obj = self._get_object(web_obj_key)
                if web_obj.get_attribute('value') is not None:
                    print("Using web element's value.")
                    actual = web_obj.get_attribute('value')
                else:
                    print("Using web element's text.")
                    actual = web_obj.text

                actual = datetime.strptime(actual, web_fmt)
                actual = actual.strftime(host_fmt)
               
                expected = host.get_field(host_obj_key)
                print("Unaltered host value: {}".format(expected))
                expected = expected.strip()

                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                if expected != actual:
                    message = "The text of element '%s' should have been '%s' but in fact it was '%s'." % (web_obj_key, expected, actual)
                    raise AssertionError(message)
                else:
                    print('Values matched: {}'.format(actual))
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def verify_rate_in_host(self, web_obj_key, host_obj_key, web_fmt='%m/%d/%Y', host_fmt='%m/%d/%y', timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')

        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                print("Verifying web element '%s' matches host element '%s'." % (web_obj_key, host_obj_key))
                web_obj = self._get_object(web_obj_key)
                if web_obj.get_attribute('value') is not None:
                    print("Using web element's value.")
                    actual = web_obj.get_attribute('value')
                else:
                    print("Using web element's text.")
                    actual = web_obj.text

                expected = host.get_field(host_obj_key)
                print("Unaltered host value: {}".format(expected))
                expected = expected.strip()

                if actual[-1] == '%':
                    actual = actual[:-1]
                
                # testing
                d_actual = Decimal(actual)
                d_expected = Decimal(expected)

                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                if d_expected != d_actual:
                    message = "The text of element '%s' should have been '%s' but in fact it was '%s'." % (web_obj_key, expected, actual)
                    raise AssertionError(message)
                else:
                    print('Values matched: {}'.format(actual))
            except:
                exception_occurred = True
                if not suppress_error:
                    # BuiltIn().run_keyword('Capture Page Screenshot')
                    self.screenshot_page()
                    raise
            if not exception_occurred:
                break
            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Expect Text: Timed out.')

    def get_random_number(self, tonumber=7000, fromnumber=5000):
        randomnum=random.randint(fromnumber, tonumber)
        return randomnum

    def get_random_future_date(self, todate=10, fromdate=3):
        while True:
            transferdate = datetime.now() + timedelta(days=random.randint(fromdate, todate))
            if transferdate.day != 31 and transferdate.weekday() != 6:  # sunday
                    return transferdate

    def convert_date(self, dt, format='%m/%d/%Y', zero=False):
        if zero:
            print('convert_date: zero is Truthy: {}'.format(zero))
            return dt.strftime(format)
        else:
            print('convert_date: zero is Falsey: {}'.format(zero))
            return self.remove_zero_padding(dt)

    def get_day_of_date(self, dt, format='%A'):
        return dt.strftime(format)

    def get_day_number_of_date(self, dt, format='%d'):
        daynumber = dt.strftime(format)
        return self.ordinal(int(daynumber))

    def ordinal(self, n):
        if 10 <= n % 100 < 20:
            return str(n) + 'th'
        else:
            return str(n) + {1 : 'st', 2 : 'nd', 3 : 'rd'}.get(n % 10, "th")

    def convert_cd(self, cdacc):
        cdacc = cdacc.replace(cdacc, 'CD', 'CERTIFICATE')
        return cdacc

    def get_subset_of(self, *options):
        """
        Returns a subset of the given 'options' list. The subset is guaranteed to have at least one member if the options
        set is non-empty.
        """
        if not len(options):
            print('choose_from_set: options was empty')
            return
        subset = set()
        for option in options:
            if random.choice([True, False]):
                subset.add(option)
        if not len(subset):
            rand_idx = random.randint(0, len(options)-1)
            subset.add(options[rand_idx])
        return subset

    def click_button_in_cell_with_text(self, table_keyword, row, col, button_text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object(table_keyword)
                buttons = table.find_elements_by_xpath(".//tr[{}]/td[{}]/a[text()='{}']".format(row, col, button_text))
                if buttons:
                    buttons[0].click()
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def print_web_object_value(self, keyword):
        elem = self._get_object(keyword)

        value = elem.get_attribute('value')
        if value is not None:
            print("Using element's value.")
            actual = value
        else:
            print("Using element's text.")
            actual = elem.text

        print('Object Keyword: {}'.format(keyword))
        print('Object Value: {}'.format(actual))

    def get_mobile_number_format(self, mnf):
        print('Mobile Number: {}'.format(mnf))
        mnf = "({}) {}-{}".format(mnf[:3], mnf[3:6], mnf[6:])
        print('Mobile Number Format: {}'.format(mnf))
        return mnf

