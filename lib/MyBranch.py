import random
import time
from datetime import datetime
from decimal import Decimal

from robot.libraries.BuiltIn import BuiltIn

import ObjectRepository
import Web


'''
- Defect 634 - Redirect to Member Search

'''

mybranch_date_fmt = '%m/%d/%Y'

DEFAULT_TIMEOUT = 5


class MyBranchError(Exception):
    pass


class MyBranch(Web.Web):

    def __init__(self):
        super(MyBranch, self).__init__()
        self.aut = 'mybranch'
        ObjectRepository.load_objects('myBranch')

    def fail_test(self, reason, force=False):
        if not force:
            try:
                cache = BuiltIn().get_library_instance('Selenium2Library')
                object_id = self.get_object_id_and_select_frame('MicroNotes_NoThanks', reset=True)
                obj = cache._element_find(object_id, True, False)
                obj.click()
                return
            except:
                print('micronotes click failed')
        # BuiltIn().run_keyword('Capture Page Screenshot')
        BuiltIn().run_keyword('Log Source')
        self.screenshot_page()
        BuiltIn().run_keyword('Fail', reason)

    def log_out_mybranch(self):
        try:
            BuiltIn().run_keyword('Click On', 'Header_LogOut')
            return
        except:
            pass
        try:
            BuiltIn().run_keyword('Click On', 'MyBranchLogoURL')
        except:
            self.fail_test('Log Out myBranch')

        # obj = self.get_object('Account_Locked')
        # print('Object: {}'.format(obj))
        # if obj:
        #     self.load_browser()

    def enter_aria_text(self, keyword, text, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                obj = self.get_object_id_and_select_frame(keyword+'_d')
                #obj.click()
                BuiltIn().run_keyword('Click Element', obj)
                obj = self.get_object_id_and_select_frame(keyword)
                #obj.send_keys(text)
                BuiltIn().run_keyword('Input Text', obj, text)
                return
            except Exception as e:
                time.sleep(1)
                print(str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Enter K Text: Timed out.')

    def select_aria_list_item(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        """Selects an item from a Kendo list.
        
           Assumes an associated object with keyword = '<keyword>_d' exists."""
        start_time = datetime.now()
        while True:
            try:
                self._get_object(keyword+'_d').click()
                time.sleep(1)
                obj = self._get_object(keyword)
                item = obj.find_elements_by_xpath(".//li[normalize-space()='"+label+"']")
                if item:
                    item[0].click()
                    return
            except KeyError as e:
                print(str(e))
                raise
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Failed to select "{}" from list "{}".'.format(label, keyword))

    def select_kendo_dropdown(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        """
        object id must be 'id' for this to work, i.e. cant be xpath, name, css, etc.
        """
        cache = BuiltIn().get_library_instance('Selenium2Library')
        start_time = datetime.now()
        print'label is {} '.format(label)
        while True:
            try:
                locator = ObjectRepository.d[keyword].obj_value
                listbox = cache._element_find(locator+'_listbox', True, True)
                listbox_items = listbox.find_elements_by_xpath(".//li")
                if len(listbox_items) == 0:
                    self.fail_test('No options found for Kendo list "{}".'.format(keyword))

                container_list = cache._element_find(locator+'-list', True, True)
                result = container_list.find_elements_by_xpath("./div[contains(concat(' ', normalize-space(@class), ' '), ' k-list-optionlabel ')]")
                print('default value is {}'.format(result))
                if result:
                    has_default = True
                    print('found default value in dropdown')
                else:
                    has_default = False
                    print('did not find default value in dropdown')

                item_idx = -1
                for idx, li in enumerate(listbox_items):
                    li_text = li.get_attribute('textContent')
                    print('li_text is {}'.format(li_text))
                    if li_text == label:
                        #item_idx = idx + 1
                        item_idx = idx
                        print('item_idx is {} '.format(item_idx))
                        if has_default:
                           item_idx += 1
                           print('item_idx is {} '.format(item_idx))
                        break
                if item_idx == -1:
                    self.fail_test('Did not find "{}" in Kendo list "{}".'.format(label, keyword))

                js_select_script = "$('#{}').data('kendoDropDownList').select({});".format(locator, item_idx)
                cache._current_browser().execute_script(js_select_script)
                cache._current_browser().execute_script("$('#{}').data('kendoDropDownList').trigger('change');".format(locator))
                time.sleep(3)
                break
            except KeyError as e:
                print(str(e))
                raise
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Failed to select "{}" from Kendo list "{}".'.format(label, keyword))

    def select_aria_list_by_index(self, keyword, index, timeout=DEFAULT_TIMEOUT):
        """Selects an item from a Kendo list.

           Assumes an associated object with keyword = '<keyword>_d' exists."""
        start_time = time.time()
        while True:
            try:
                self._get_object(keyword+'_d').click()
                time.sleep(1)
                obj = self._get_object(keyword)
                item = obj.find_elements_by_xpath(".//li[{}]".format(index))
                if item:
                    item[0].click()
                    return
            except KeyError as e:
                print(str(e))
                raise
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Failed to select "{}" from list "{}".'.format(index, keyword))

    def get_aria_list_count(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                listobject = self._get_object(keyword)
                list_items = listobject.find_elements_by_xpath(".//li")
                list_count = len(list_items)
                print('get_aria_list_count: list_count: {}'.format(list_count))
                return list_count
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Failed to count from list "{}".'.format(keyword))

    def get_aria_list_items(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                listobject = self._get_object(keyword)
                list_items = listobject.find_elements_by_xpath(".//li")
                l = []
                for list_item in list_items:
                    l.append(list_item.get_attribute('innerHTML'))
                return l
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('Failed to retrieve items from list "{}".'.format(keyword))

    def aria_list_should_contain(self, keyword, label, timeout=DEFAULT_TIMEOUT):

        aria_list_items = self.get_aria_list_items(keyword)
        BuiltIn().run_keyword('should contain', aria_list_items, label)

    def aria_list_should_not_contain(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        aria_list_items = self.get_aria_list_items(keyword)
        BuiltIn().run_keyword('should not contain', aria_list_items, label)

    def aria_list_should_not_contain_item_containing(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        aria_list_items = self.get_aria_list_items(keyword)
        print(aria_list_items)
        for item in aria_list_items:
            print(item)
            if label in item:
                print(label)
                message = "The item containing in list '{} ({}, {})' should not have been '{}' ".format(keyword, label)
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                raise AssertionError(message)
        print("The Item  '%s' not containing in '%s' " % (keyword, label))

    def select_random_aria_list_item(self, keyword, timeout=DEFAULT_TIMEOUT):
        listcount = self.get_aria_list_count(keyword)
        random_index = random.randint(1, listcount)
        self.select_aria_list_by_index(keyword, random_index)

    def get_aria_selected_item(self, keyword, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                obj = self._get_object(keyword+'_d')
                items = obj.find_elements_by_xpath("./span/span")
                print(str(len(items)))
                print('text='+items[0].text)
                if len(items) > 0:
                    return items[0].text
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Get K Selected Item: Timed out.')

    def open_new_certificate_account(self, min_deposit, term, timeout=DEFAULT_TIMEOUT):
        """Assumes current page is "Open a New Deposit Account with Certificate Account selected."""

        start_time = datetime.now()
        while True:
            min_deposit_range = False
            try:
                rows = self.get_table_row_count('OpenNewAccounts_CDRates_Table')
                table = self._get_object('OpenNewAccounts_CDRates_Table')
                for i in xrange(1, rows + 1):

                    cell = table.find_element_by_xpath(".//tr[{}]/td[1]".format(i))
                    print('Checking row: {}'.format(i))
                    print('first cell text: {}'.format(cell.text))
                    if cell.text == min_deposit:
                        cell = table.find_element_by_xpath(".//tr[{}]/td[2]".format(i))
                        print('second cell text: {}'.format(cell.text))
                        if cell.text == term:
                            table.find_element_by_xpath(".//tr[{}]/td[5]/a".format(i)).click()
                            return
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out.')

    def open_new_money_market(self, min_deposit, timeout=DEFAULT_TIMEOUT):
        """Assumes current page is "Open a New Deposit Account with Money Market selected."""

        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('OpenNewAccounts_MoneyMarketRates_Table')
                table = self._get_object('OpenNewAccounts_MoneyMarketRates_Table')
                for i in xrange(1, rows + 1):
                    cells = table.find_elements_by_xpath(".//tr["+str(i)+"]/td[1]")
                    if cells[0].text == min_deposit:
                        table.find_elements_by_xpath(".//tr["+str(i)+"]/td[4]/a")[0].click()
                        return
            except Exception as e:
                print(str(e))

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Open New Money Market: Error opening product.')

    def count_alert_contacts(self, name, email, timeout=DEFAULT_TIMEOUT):
        cache = BuiltIn().get_library_instance('Selenium2Library')
        start_time = datetime.now()
        while True:
            total = 0
            try:
                no_contacts = cache._element_find("id=noContacts", True, False)
                if no_contacts:
                    if no_contacts.is_displayed():
                        print('page displays: "no contacts"')
                        return 0
                loading_image = cache._element_find("//div[@class='k-loading-image']", True, False)
                if not loading_image:
                    rows = self.get_table_row_count('Alerts_ManageAlertContacts_Table')
                    table = self._get_object('Alerts_ManageAlertContacts_Table')
                    for i in xrange(1, rows + 1):
                        cells = table.find_elements_by_xpath(".//tr["+str(i)+"]/td[1]")
                        if cells[0].text == name:
                            cells = table.find_elements_by_xpath(".//tr["+str(i)+"]/td[2]")
                            if cells[0].text == email:
                                total += 1
                    return total

            except Exception as e:
                print(str(e))

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def get_random_alert_contact(self, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('Alerts_ManageAlertContacts_Table')
                if not rows:
                    BuiltIn().run_keyword('Fail', 'no alert contacts found')
                random_row = random.randint(1, rows)
                return random_row

            except Exception as e:
                print(str(e))

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out')

    def get_last_alert_contact(self, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('Alerts_ManageAlertContacts_Table')
                if not rows:
                    BuiltIn().run_keyword('Fail', 'no alert contacts found')
                return rows

            except Exception as e:
                print(str(e))

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out')

    def get_alert_contact_name(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Alerts_ManageAlertContacts_Table')
                cells = table.find_elements_by_xpath(".//tr[{}]/td[1]".format(row))
                return cells[0].text
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Timed out')


    def click_delete_alert(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Alerts_Table')
                table.find_element_by_xpath(".//tr[{}]/td[5]/a[2]".format(row)).click()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def click_unlink_account(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('External_Accounts_Table')
                table.find_element_by_xpath(".//tr[{}]/td[6]/a[1]".format(row)).click()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def click_edit_alert_contact(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Alerts_ManageAlertContacts_Table')
                table.find_elements_by_xpath(".//tr[{}]/td[3]/a[text()='Edit']".format(row))[0].click()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_alert_contact(self, row, name, email, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Alerts_ManageAlertContacts_Table')
                cells = table.find_elements_by_xpath(".//tr["+str(row)+"]/td[1]")
                if cells[0].text == name:
                    cells = table.find_elements_by_xpath(".//tr["+str(row)+"]/td[2]")
                    if cells[0].text == email:
                        return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Verify Alert Contact: Timed out.')

    def click_delete_alert_contact(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Alerts_ManageAlertContacts_Table')
                table.find_elements_by_xpath(".//tr[{}]/td[3]/a[text()='Delete']".format(row))[0].click()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def click_delete_recurring_transfer(self, row, timeout=DEFAULT_TIMEOUT):
        start_time = time.time()
        while True:
            try:
                table = self._get_object('Transfers_Recurring')
                table.find_element_by_xpath(".//tr[{}]/td[8]/a/span".format(row)).click()
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if time.time() - start_time > timeout:
                self.fail_test('timed out')

    def set_overdraft_option(self, row, option):
        """
        Assumes we're not in an iframe.
        """
        if option == 'Opt-in':
            msg = 'You are opted-in'
            radio_value_to_select = 'True'
        elif option == 'Opt-out':
            msg = 'You are opted-out'
            radio_value_to_select = 'False'
        else:
            raise ValueError

        t = self.get_table_cell_value('Overdraft_Table', row, 6)
        if t == msg:
            return

        radio_group_name = 'AccountList[{}].DebitATMODProtection'.format(row-1)
        self.select_radio_option(radio_group_name, radio_value_to_select)
        self._get_object('OverDraftCoverage_Next').click()
        self._get_object('OverDraftCoverage_Submit').click()
        self._get_object('LeftNav_OverdraftCoverage_TransactionCoverage').click()

    def delete_new_message_alert_if_found(self, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        while True:
            try:
                # table = self._get_object('Alerts_Table')
                row = self.find_table_row_with_text_in_column('New Message', 'Alerts_Table', col_name='Alert Type')
                if row:
                    self.click_delete_alert(row)
                    self.click_on('DeleteAlert_Delete')
                    self.click_on('DeleteAlert_Close')
                return
            except Exception as e:
                print(str(e))
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_account_display(self, order='Account Type'):
        account_type = [            'Savings Accounts',
            'Checking and Money Market Accounts',
            'IRA Accounts',
            'Loan Accounts',
            'Credit Card Accounts',
            'Line of Credit Accounts',
            'Mortgage'
            # add and fix if needed
        ]
        asset_liability = [
            'Deposit Accounts',
            'Loan Accounts'
            # add and fix if needed
        ]

        if order == 'Account Type':
            order_list = account_type
        elif order == 'Asset/Liability':
            order_list = asset_liability
        else:
            self.fail_test('Bad argument: {}'.format(order), force=True)

        accounts_grid = self._get_object('AccountSummary_AccountsGrid')
        tables = accounts_grid.find_elements_by_xpath('./div[@class="accountsGroup"]//tr[1]/td[1]')
        pos = -1
        for table in tables:
            header = table.text.strip()
            if not header:
                self.fail_test('No text found: {}'.format(table))
            try:
                idx = order_list.index(header)
            except ValueError:
                self.fail_test('Unknown account type: {}'.format(header))
            if idx <= pos:
                self.fail_test('Account type out of order: {}'.format(idx))
            pos = idx
            print('Account type matched:  account type: {}'.format(header))

    def get_bill_pay_account(self, name=None, account=None,
                             addr1=None, addr2=None, city=None,
                             state=None, zip1=None, zip2=None):

        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        short_name = name+', *'+account[-4:]
        payees = driver.find_elements_by_xpath("//a[@class='payeeNickname']")
        #l = cache._element_find('link='+short_name)
        print('Looking for: '+short_name)
        start_time = datetime.now()
        while True:
            for idx, payee in enumerate(payees):
                print(payee.text+'=='+short_name)
                if payee.text == short_name:
                    print('Using existing payee')
                    return idx + 1
            if (datetime.now() - start_time).total_seconds() > 5:
                break
        print('Creating payee.')
        BuiltIn().run_keyword('Enter Text', 'MakePayments_PaySomeoneNew', name)
        BuiltIn().run_keyword('Click On', 'MakePayments_Add')
        BuiltIn().run_keyword('Enter Text', 'MakePayments_AccountNumber', account)
        BuiltIn().run_keyword('Enter Text', 'MakePayments_AddressLine1', addr1)
        if addr2 is not None:
            BuiltIn().run_keyword('Enter Text', 'MakePayments_AddressLine2', addr2)
        BuiltIn().run_keyword('Enter Text', 'MakePayments_City', city)
        BuiltIn().run_keyword('Select List Item', 'MakePayments_State', state)
        BuiltIn().run_keyword('Enter Text', 'MakePayments_ZipCode1', zip1)
        BuiltIn().run_keyword('Enter Text', 'MakePayments_ZipCode2', zip2)
        BuiltIn().run_keyword('Click On', 'MakePayments_Continue')
        BuiltIn().run_keyword('Click On', 'MakePayments_GoToMakePayments')
        return 1

    def make_bill_pay_payment(self, row_number, amount):
        row = str(row_number)
        time.sleep(2)
        BuiltIn().run_keyword("Input Text", "xpath=(//input[@name='curAmt'])["+row+"]", amount)
        BuiltIn().run_keyword('Click Element', "xpath=(//button[text()='Pay'])["+row+"]")

    def verify_account_cd_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)
                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    # tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        raise Exception('both debit and credit were blank')
                    amount = amount[1:]
                    r = host.find_transaction_on_sti2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    if not r:
                        self.fail_test('transaction not found')
                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_account_checking_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)

                    if 'PENDING' in tdescr:
                        continue

                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    # tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 6)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        print('both blank?!')
                    amount = amount[1:]

                    #r = host.find_transaction_on_imi2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    r = host.find_transaction_on_imi2(tdate=tdate, tamount=amount)

                    print(r)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_account_savings_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)
                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    # tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        print('both blank?!')
                    amount = amount[1:]

                    r = host.find_transaction_on_imi2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_account_am_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        """
        this needs to be updated.
        instead of checking if each of the transactions shown in mybranch exist in host
        (failing if no transactions found in mybranch)...
        start with transactions in host that should show in mybranch
        """
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                if not rows:
                    return
                    # self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))

                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)

                    if 'PENDING' in tdescr:
                        continue

                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        tamount = debit
                    elif credit:
                        tamount = credit
                    else:
                        print('both blank?!')
                    tamount = tamount[1:]
                    tbalance = tbalance[1:]

                    r = host.find_transaction_on_amhs(tdate=tdate, tdescr=tdescr, tamount=tamount, tbalance=tbalance)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def select_aria_list_item_containing(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        start_time = datetime.now()
        print('labe is {}'.format(label))
        while True:
            try:
                self._get_object(keyword+'_d').click()
                time.sleep(1)
                obj = self._get_object(keyword)
                list_items = obj.find_elements_by_xpath(".//li/span/span[1]")
                for item in list_items:
                    print('item is {}'.format(item))
                    print('found list item: {}'.format(item.text))
                    if label in item.text:
                        print("List item containing '{}' found: {}".format(label, item.text))
                        item.click()
                        return
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Failed to select "{}" from list "{}".'.format(label, keyword))

    def find_item_in_aria_list(self, keyword, label, timeout=DEFAULT_TIMEOUT):
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                #BuiltIn().run_keyword('Click On', keyword+'_d')
                obj = self.get_object_id_and_select_frame(keyword+'_d')
                #obj.click()
                BuiltIn().run_keyword('Click Element', obj)
                time.sleep(1)
                obj = self._get_object(keyword)
                item = obj.find_elements_by_xpath(".//li[normalize-space()='"+label+"']")

                list_items = obj.find_elements_by_xpath(".//li")
                print("list Items"+str(list_items))
                for i in list_items:
                    print(i)
                    print(i.text)
                    if label in i.text:
                        return True
                return False
            except KeyError as e:
                print(str(e))
                raise
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('Failed to select "{}" from list "{}".'.format(label, keyword))

    def find_scheduled_transfer1(self, date, fromaccount, toaccount, repeat, day, amount, numoftransfers, timeout=DEFAULT_TIMEOUT):
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                print(date)
                print(fromaccount)
                print(toaccount)
                print(repeat)
                print(day)
                print(amount)
                print(numoftransfers)
                table = self._get_object('Transfers_Recurring')
                rows = self.get_table_row_count('Transfers_Recurring')
                print("Total rows in table: {}".format(rows))
                if not rows:
                    self.fail_test('no scheduled transfers found')
                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    d = self.get_table_cell_value('Transfers_Recurring', row, 1)
                    if not d:
                        self.fail_test('no date found')
                    if d == date:
                        print('date found ')
                    fa = self.get_table_cell_value('Transfers_Recurring', row, 2)
                    ta = self.get_table_cell_value('Transfers_Recurring', row, 3)
                    r = self.get_table_cell_value('Transfers_Recurring', row, 4)
                    dy = self.get_table_cell_value('Transfers_Recurring', row, 5)
                    a = self.get_table_cell_value('Transfers_Recurring', row, 6)
                    nt = self.get_table_cell_value('Transfers_Recurring', row, 7)
                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')


#        find_row_in_table('TransactionsTable', '03/16/2016', *, 'ONLINE XFER CR')
#    def find_row_in_table(self, *args, timeout=DEFAULT_TIMEOUT):
        # web = BuiltIn().get_library_instance('Web')

#        table_keyword = args[0]

#        start_time = datetime.now()
#        while True:
#            try:
                #print(date)
                #print(fromaccount)
                #print(toaccount)
                #print(repeat)
                #print(day)
                #print(amount)
                #print(numoftransfers)
#                table = self._get_object(table_keyword)
#                rows = self.get_table_row_count(table_keyword)
#               print("Total rows in table: {}".format(rows))
#                if not cols:
#                    self.fail_test('no scheduled transfers found')
#                print('rows found: {}'.format(rows))
#                for row in xrange(1, rows + 1):
#                   #print('checking row: {}'.format(row))
#                    cols = table.find_elements_by_xpath('.//tr[1]/td')
#                    for col in xrange(1, cols + 1):
#                        col_value = self.get_table_cell_value(table_keyword, row, col)
#                        if col_value != args[col]:
#                            print('argument doesnt match : {}'.format(col_value))
#                            continue
#                    else:
#                        print('date does match : {}'.format(col_value))
#
#                    return row
                #return row
#            except Exception as e:
#                print(str(e))
#                pass

#           time.sleep(1)
#            if (datetime.now() - start_time).total_seconds() > timeout:
#                self.fail_test('timed out')


    def find_scheduled_transfer(self, date, fromaccount, toaccount, repeat, day, amount, numoftransfers, timeout=DEFAULT_TIMEOUT):
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('Transfers_Recurring')
                rows = self.get_table_row_count('Transfers_Recurring')
                print("Total rows in table: {}".format(rows))
                if not rows:
                    self.fail_test('no scheduled transfers found')
                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    #print('checking row: {}'.format(row))
                    row_date = self.get_table_cell_value('Transfers_Recurring', row, 1)
                    print(row_date)
                    if not row_date:
                        self.fail_test('no date found')
                    if row_date != date:
                        print('date doesnt match : {}'.format(row_date))
                        continue
                    else:
                        print('date does match : {}'.format(row_date))
                    row_from_account = self.get_table_cell_value('Transfers_Recurring', row, 2)
                    print(row_from_account)
                    if not row_from_account:
                        self.fail_test('no from account found')
                    if row_from_account != fromaccount:
                        print('row_from_account doesnt match: {)'.format(row_from_account))
                        continue
                    else:
                        print('from account does match : {}'.format(row_from_account))
                    row_to_account = self.get_table_cell_value('Transfers_Recurring', row, 3)
                    print(row_to_account)
                    if not row_to_account:
                        self.fail_test('no to account found')
                    if row_to_account != toaccount:
                        print('to account doesnt match: {}'.format(row_to_account))
                        continue
                    else:
                        print('to account does match : {}'.format(row_to_account))
                    row_repeat = self.get_table_cell_value('Transfers_Recurring', row, 4)
                    print(row_repeat)
                    if not row_repeat:
                        self.fail_test('no repeat found')
                    if row_repeat != repeat:
                        print('repeat doesnt match: {}'.format(row_repeat))
                        continue
                    else:
                        print('repeat does match : {}'.format(row_repeat))
                    row_day = self.get_table_cell_value('Transfers_Recurring', row, 5)
                    print(row_day)
                    if not row_day:
                        self.fail_test('no day found')
                    if row_day != day:
                        print('day doesnt match: {}'.format(row_day))
                        continue
                    else:
                        print('day does match : {}'.format(row_day))
                    row_amount = self.get_table_cell_value('Transfers_Recurring', row, 6)
                    print(row_amount)
                    if not row_amount:
                        self.fail_test('no amount found')
                    if row_amount != amount:
                        print('amount doesnt match:{}'.format(row_amount))
                        continue
                    else:
                        print('amount does match : {}'.format(row_amount))
                    row_remaining = self.get_table_cell_value('Transfers_Recurring', row, 7)
                    print(row_remaining)
                    if not row_remaining:
                        self.fail_test('no number of remaining transfers found')
                    if row_remaining != numoftransfers:
                        print('number of remaining transfers doesnt match:{}'.format(row_remaining))
                        continue
                    else:
                        print('number of remaining transfers does match : {}'.format(row_remaining))
                    return row
                #return row
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def get_account_balance(self, web_obj_key, timeout=DEFAULT_TIMEOUT):

        start_time = datetime.now()
        suppress_error = True
        while True:
            exception_occurred = False
            try:
                web_obj = self._get_object(web_obj_key)
                print(web_obj)
                if web_obj.get_attribute('value') is not None:
                    print("Using web element's value.")
                    balance = web_obj.get_attribute('value')
                    print(balance)
                else:
                    print("Using web element's text.")
                    balance = web_obj.text
                    print(balance)

                # Format
                if balance[0] == '(' and balance[-1] == ')':
                    balance = '-' + balance[1:-1]
                balance = balance.replace('$', '')
                balance = balance.replace(',', '')
                d_balance = Decimal(balance).quantize(Decimal('.00'))
                # BuiltIn().run_keyword('Capture Page Screenshot')
                self.screenshot_page()
                return d_balance

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

    def verify_request_stop_payment_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
#                rows = self.get_table_row_count('RequestStopPayment_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    rsp_acc = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 1)
                    rsp_start_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 2)
                    rsp_end_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 3)
                    rsp_amount = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 4)
                    rsp_payee_reason = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 5)
                    request_date = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 6)

                    r = host.find_stoppayment_on_imi5(rsp_start_no=rsp_start_no, rsp_end_no=rsp_end_no, request_date=request_date)
                    #r = host.find_stoppayment_on_imi5(request_date=request_date)
                    print('row: {}'.format(r))

                    if not r:
                        self.fail_test('request stop payment transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_request_stop_payment_single_check_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
                # rows = self.get_table_row_count('RequestStopPayment_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows + 1):
                    print('checking row: {}'.format(row))
                    rsp_acc = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 1)
                    rsp_start_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 2)
                    rsp_end_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 3)
                    rsp_amount = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 4)
                    rsp_payee_reason = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 5)
                    request_date = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 6)

                    r = host.find_stoppayment_single_check_on_imi5(rsp_start_no=rsp_start_no, request_date=request_date)
                    #r = host.find_stoppayment_single_check_on_imi5(rsp_start_no=rsp_start_no)
                    print('row: {}'.format(r))

                    if not r:
                        self.fail_test('request stop payment transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_request_stop_payment_single_check_against_host_postbatch(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
                # rows = self.get_table_row_count('RequestStopPayment_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows + 1):
                    print('checking row: {}'.format(row))
                    rsp_acc = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 1)
                    rsp_start_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 2)
                    rsp_end_no = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 3)
                    rsp_amount = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 4)
                    rsp_payee_reason = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 5)
                    request_date = self.get_table_cell_value('RequestStopPayment_TransactionsTable', row, 6)

                    #r = host.find_stoppayment_single_check_on_imi5(rsp_start_no=rsp_start_no, request_date=request_date)
                    r = host.find_stoppayment_single_check_on_imi5_postbatch(rsp_start_no=rsp_start_no)
                    print('row: {}'.format(r))

                    if not r:
                        self.fail_test('request stop payment transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_transfer_savings_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
#                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)
                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    # tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        print('both blank?!')
                    amount = amount[1:]

                    r = host.find_transaction_on_imi2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')



    def verify_transfer_checking_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
#                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)

                    if 'PENDING' in tdescr:
                        continue

                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        print('both blank?!')
                    amount = amount[1:]

                    r = host.find_transaction_on_imi2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    #r = host.find_transaction_on_imi2(tdate=tdate, tamount=amount)


                    print(r)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_transfer_am_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                #rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)

                    if 'PENDING' in tdescr:
                        continue

                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        tamount = debit
                    elif credit:
                        tamount = credit
                    else:
                        print('both blank?!')
                    tamount = tamount[1:]
                    tbalance = tbalance[1:]

                    r = host.find_transaction_on_amhs(tdate=tdate, tdescr=tdescr, tamount=tamount, tbalance=tbalance)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_transfer_heloc_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        # web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                #rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    if 'PENDING' in tdescr:
                        continue
                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 6)
                    if debit:
                        tamount = debit
                    elif credit:
                        tamount = credit
                    else:
                        print('both blank?!')
                    tamount = tamount[1:]
                    tbalance = tbalance[1:]

                    r = host.find_transaction_on_amhs(tdate=tdate, tdescr=tdescr, tamount=tamount, tbalance=tbalance)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def verify_transfer_cd_transactions_against_host(self, timeout=DEFAULT_TIMEOUT):
        host = BuiltIn().get_library_instance('Host')
        start_time = datetime.now()
        while True:
            try:
#                rows = self.get_table_row_count('AccountDetails_TransactionsTable')
                rows = 1
                if not rows:
                    self.fail_test('no transactions found')

                print('rows found: {}'.format(rows))
                for row in xrange(1, rows+1):
                    print('checking row: {}'.format(row))
                    tdate = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 1)
                    tdate = datetime.strptime(tdate, mybranch_date_fmt)
                    tdescr = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 2)
                    debit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 3)
                    credit = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 4)
                    # tbalance = self.get_table_cell_value('AccountDetails_TransactionsTable', row, 5)
                    if debit:
                        amount = debit
                    elif credit:
                        amount = credit
                    else:
                        print('both blank?!')
                    amount = amount[1:]

                    r = host.find_transaction_on_sti2(tdate=tdate, tdescr=tdescr, tamount=amount)
                    if not r:
                        self.fail_test('transaction not found')

                return
            except Exception as e:
                print(str(e))
                pass

            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('timed out')

    def select_statement_mailing_address_checkboxes(self, wait=0, timeout=DEFAULT_TIMEOUT):
        # todo
        #obj = self._get_object(keyword)
        #rows = len(obj.find_elements_by_xpath('.//tbody/tr'))
        #table = self._get_object(key)
        start_time = datetime.now()
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        #List<WebElement els = driver.findElements(By.xpath("//input[@type='checkbox']"));
        #for i in range(30):
        #List<IWebElement> checkboxes = driver.find_elements_by_xpath('.//input[@class="ac-account-list"]'));
        #checkboxes = driver.find_elements_by_css_selecotr('.//input[@class="ac-account-list"]')
        #checkboxes = driver.find_elements_by_css_selecotr('.//input[@class="profile-select-list"]')
        #for checkbox in driver.find_elements_by_class_name('profile-select-list'):
        for checkbox in driver.find_elements_by_xpath("//input[@name='PostedAccounts.AccountIndexes']"):
            #if not checkbox.isSelected():
            checkbox.click()
            if (datetime.now() - start_time).total_seconds() > timeout:
                self.fail_test('select_statement_mailing_address_checkboxes: Timed out')

    def account_is_hidden(self, account_namenumber):
        row = self.find_table_row_with_text_in_column(account_namenumber, 'Settings_AccountPreferences_Table', col_name='Account')
        if self.get_table_cell_value('Settings_AccountPreferences_Table', row, 5) == 'Yes':
            return False
        return True

    def verify_favorites_display_correctly(self, *favorites_items):
        self.verify_favorites_table_displays_correcty('Settings_MyFavoritesMenu_Table')

    def verify_favorites_table_displays_correcty(self, keyword):
        rows = self.get_table_row_count(keyword)
        print('rows found: {}'.format(rows))
        row = 2
        for row in xrange(2, rows - 1):
            print('checking row: {}'.format(row))
            label = self.get_table_cell_value('Settings_MyFavoritesMenu_Table', row, 1)
            if label in ('Accounts', 'Alerts', 'Profile', 'Support', 'Transfers & Payments'):
                continue
            print('label is: {}'.format(label))
            table = self._get_object('Settings_MyFavoritesMenu_Table')
            print('table is: {}'.format(table))
            try:
                checkbox = table.find_element_by_xpath(".//tr[" + str(row) + "]/td[2]/input[@type='checkbox']")
            except:
                continue
            print('check box is: {}'.format(checkbox))
            # BuiltIn().run_keyword('Capture Page Screenshot')
            self.screenshot_page()
            if checkbox.is_selected():
                print('checkbox: is_selected: {}'.format(checkbox.is_selected()))
                self.aria_list_should_contain('MyFavorite_Listbox', label)
            else:
                self.aria_list_should_not_contain('MyFavorite_Listbox', label)
            # BuiltIn().run_keyword('Capture Page Screenshot')
            self.screenshot_page()

    def select_delivery_preference(self, account, keyword, preference='eStatement'):
        table = self._get_object(keyword)
        row = self.find_table_row_with_text_in_column(account, keyword, col_name='Account')
        if row == -1:
            self.fail
        deliverypreferencecol = 2
        inputs = table.find_elements_by_xpath('./tbody/tr[{}]/td[{}]/input'.format(row, deliverypreferencecol))
        if not inputs:
            self.fail
        if preference == 'eStatement':
            radio = table.find_elements_by_xpath('./tbody/tr[{}]/td[{}]/input'.format(row, deliverypreferencecol))[0]
        else:
            radio = table.find_elements_by_xpath('./tbody/tr[{}]/td[{}]/input'.format(row, deliverypreferencecol))[1]
        radio.click()