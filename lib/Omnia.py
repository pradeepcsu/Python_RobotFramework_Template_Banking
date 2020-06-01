import time
from datetime import datetime

from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.common.action_chains import ActionChains

import ObjectRepository


class Omnia(object):

    def __init__(self):
        self.run = {}
        ObjectRepository.load_objects('Omnia')

    def go_back_to_member_search(self):

        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        try:
            while len(driver.window_handles) > 1:
                #driver.switch_to_window(driver.window_handles[len(driver.window_handles)-1])
                BuiltIn().run_keyword('Close Window')
                self.unregister_window()
                #self.windows.pop()
                driver.switch_to_window(self.windows[len(self.windows) - 1])
            if web._get_object('Members_Search', required=False, timeout=0) is None:
                BuiltIn().run_keyword('Close All Browsers')
        except:
            BuiltIn().run_keyword('Close All Browsers')

        self.windows = []
        self.frames = []

    def open_ump_from_search_results(self, cis):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        row = web._find_table_row_with_text_in_column('Members_SearchResults_Grid', cis, 3, timeout=5)
        table = web._get_object('Members_SearchResults_Grid')
        ActionChains(driver).double_click(table.find_element_by_xpath('.//tr[' + str(row) + ']/td[3]')).perform()

    def open_account_from_ump(self, account, loc=False):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        web.click_on('LeftNav_Tree_Accounts')
        account = account.replace('X', '*')
        row = web._find_table_row_with_text_in_column('UMP_Accounts_Grid', account, 2)
        if loc:
            row += 1
        cell = web._get_object('UMP_Accounts_Grid').find_element_by_xpath('.//tr[' + str(row) + ']/td[2]')
        cell.click()
        ActionChains(driver).double_click(cell).perform()
        BuiltIn().run_keyword('Register Window')

    def open_account_from_grid(self, grid, account, loc=False):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        account = account.replace('X', '*')
        row = web._find_table_row_with_text_in_column(grid, account, 2)
        if loc:
            row += 1
        cell = web._get_object(grid).find_element_by_xpath('.//tr[' + str(row) + ']/td[2]')
        cell.click()
        ActionChains(driver).double_click(cell).perform()
        BuiltIn().run_keyword('Register Window')
    
    def select_mmach_account(self, account):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        account = account.replace('X', '*')
        row = web._find_table_row_with_text_in_column('UMP_MMACHAccounts_Grid', account, 2)
        cell = web._get_object('UMP_MMACHAccounts_Grid').find_element_by_xpath('.//tr['+str(row)+']/td[1]/input')
        cell.click()

    def wait_for_fee_reversal_page_to_load(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        frt = web._get_object('FeeReversal_Type')
        while not frt.is_enabled():
            time.sleep(1)

    def add_service_request(self, sr, timeout=60):
        cache = BuiltIn().get_library_instance('Selenium2Library')
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                BuiltIn().run_keyword('Click On', 'Ribbon_AddServiceRequest')
                if sr == 'CD Maintenance':
                    l = 'Ribbon_AddServiceRequest_CDMaintenance'
                elif sr == 'Check Copy':
                    l = 'Ribbon_AddServiceRequest_CheckCopy'
                elif sr == 'Check Order':
                    l = 'Ribbon_AddServiceRequest_CheckOrder'
                elif sr == 'Fee Reversal':
                    l = 'Ribbon_AddServiceRequest_FeeReversal'
                elif sr == 'Loan Action':
                    l = 'Ribbon_AddServiceRequest_LoanAction'
                elif sr == 'Loan Payoff Quote':
                    l = 'Ribbon_AddServiceRequest_LoanPayoffQuote'
                elif sr == 'Official Check':
                    l = 'Ribbon_AddServiceRequest_OfficialCheck'
                elif sr == 'Statement Copy':
                    l = 'Ribbon_AddServiceRequest_StatementCopy'
                elif sr == 'Stop Payment':
                    l = 'Ribbon_AddServiceRequest_StopPayment'
                elif sr == 'Title Request':
                    l = 'Ribbon_AddServiceRequest_TitleRequest'
                elif sr == 'Transaction Dispute':
                    l = 'Ribbon_AddServiceRequest_TransactionDispute'
                elif sr == 'Update Account Detail':
                    l = 'Ribbon_AddServiceRequest_UpdateAccountDetail'
                elif sr == 'Update CC Statement Type':
                    l = 'Ribbon_AddServiceRequest_UpdateCCStatementType'
                elif sr == 'Update Rewards Program':
                    l = 'Ribbon_AddServiceRequest_UpdateRewardsProgram'
                elif sr == 'Western Union Speedpay':
                    l = 'Ribbon_AddServiceRequest_WesternUnionSpeedpay'
                elif sr == 'Western Union Transfer':
                    l = 'Ribbon_AddServiceRequest_WesternUnionTransfer'
                #obj = web.get_object_id_and_select_frame(l)
                #link = cache._element_find(obj)
                #if link is not None:
                #    BuiltIn().run_keyword('Click On', l)
                #    break
                BuiltIn().run_keyword('Click On', l)
                BuiltIn().run_keyword('Register Window')
                return
            except Exception as e:
                print(str(e))

            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Add Service Request')

    def add_new_note(self, text):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        textfields = driver.find_elements_by_tag_name('textarea')
        textfields[0].send_keys(text)

    def put_text(self, object_id, text):
        web = BuiltIn().get_library_instance('Web')
        obj = web._get_object(object_id)
        obj.send_keys(text)

    def save_and_close_service_request(self):
        BuiltIn().run_keyword('Click On', 'Ribbon_SaveClose')
        self.run['sr_timestamp'] = datetime.now()
        BuiltIn().run_keyword('Unregister Window')

    def open_last_member_activity(self, timestamp):
        web = BuiltIn().get_library_instance('Web')
        username = web._get_object('UserName').text
        self.open_member_activity(timestamp, username)

    def open_member_activity(self, timestamp, username, timeout=120):
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            web.click_on('UMP_Activities_RefreshGrid')
            rows = web._get_table_row_count('UMP_Activities_Grid')
            print('Found %s rows in Activities grid.' % rows)
            time.sleep(2)
            table = web._get_object('UMP_Activities_Grid')
            time.sleep(1)
            # Let table load
#             i = 0
#             while i < 5:
#                 i += 1 
#                 created_on = table.find_element_by_xpath('.//tbody/tr[1]/td[9]/nobr').text
#                 if created_on == '':
#                     time.sleep(1)
#                 else:
#                     break
            
            try:
                for row in xrange(1, rows+1):
                    created_on = table.find_element_by_css_selector('tbody tr:nth-child('+str(row)+') td:nth-child(9) nobr').get_attribute('innerHTML')
                    if created_on == '':
                        continue
                    created_on = datetime.strptime(created_on, '%m/%d/%Y %I:%M %p')
                    minutes = divmod((timestamp - created_on).total_seconds(), 60)[0]
                    if minutes < 2:
                        created_by = table.find_element_by_xpath('.//tbody/tr['+str(row)+']/td[8]').text
                        if username == created_by:
                            table.find_element_by_xpath('.//tbody/tr['+str(row)+']/td[2]//a').click()
                            BuiltIn().run_keyword('Register Window')
                            return
            except Exception as e:
                print("Error: "+str(e))

            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Open Member Activity: Timed out.')

    def open_account_activity(self, timestamp, timeout=120):
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            #BuiltIn().run_keyword('Wait For', 'AD_Activities_Grid')
            BuiltIn().run_keyword('Click On', 'AccountActivities_RefreshGrid')
            rows = web._get_table_row_count('AD_Activities_Grid')
            print('Found %s activities in grid.' % rows)
            username = web._get_object('UserName').text
            table = web._get_object('AD_Activities_Grid')
            print("Username is '%s'." % username)
            try:
                for row in xrange(1, rows+1):
                    print("Checking row %s." % row)
                    created_on = table.find_element_by_xpath('.//tbody/tr['+str(row)+']/td[9]').text
                    created_on = datetime.strptime(created_on, '%m/%d/%Y %I:%M %p')
                    print(str(timestamp))
                    #timestamp = datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')
                    minutes = divmod((timestamp - created_on).total_seconds(), 60)[0]
                    if minutes < 2:
                        created_by = table.find_element_by_xpath('.//tbody/tr['+str(row)+']/td[8]').text
                        print("Verifying 'Created By', '%s' ? '%s'" % (username, created_by))
                        if username == created_by:
                            #ActionChains(driver).double_click(table.find_element_by_xpath('.//tbody/tr['+str(row)+']')).perform()
                            table.find_element_by_xpath('.//tbody/tr['+str(row)+']/td[2]//a').click()
                            BuiltIn().run_keyword('Register Window')
                            return
            except Exception as e:
                print("Error: "+str(e))

            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Find Service Request')

    def _check_for_error(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        try:
            alert = driver.switch_to_alert()
            print(alert.text)
            alert.dismiss()
        except:
            print('no alert')
            pass

    def verify_regarding_account(self):
        web = BuiltIn().get_library_instance('Web')
        print(web._get_object('SR_RegardingAccount').text)

    def verify_member_icons(self):
        """This function uses Host to validate member icons in Omnia."""

        web = BuiltIn().get_library_instance('Web')
        host = BuiltIn().get_library_instance('Host')

        BuiltIn().run_keyword('Nav Screen', 'rmc2')

        if host.is_presidents_club():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_PresidentsClub'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_PresidentsClub'))

        if host.is_employee():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_Employee'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_Employee'))

        if host.is_board_of_directors():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_BoardOfDirectors'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_BoardOfDirectors'))

        if host.is_deceased():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_Deceased'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_Deceased'))

        if host.is_ssig():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_SSIG'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_SSIG'))

        if host.is_youth():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_Youth'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_Youth'))

        BuiltIn().run_keyword('Nav Screen', 'rmc3')

        if host.is_senior():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_Senior'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_Senior'))

        if host.is_freedom50():
            BuiltIn().run_keyword('Page Should Contain Image', web.get_object_id_and_select_frame('Header_Freedom50'))
        else:
            BuiltIn().run_keyword('Page Should Not Contain Image', web.get_object_id_and_select_frame('Header_Freedom50'))

    #FIX
    #FIX
    #FIX
    def verify_account(self, account1, account2):
        account1 = account1.replace('X', '*')
        account2 = account2.replace('X', '*')
        print("Verifying account '%s' matches account '%s'." % (account1, account2))
        if account1 not in account2 and account2 not in account1:
            message = "Account '%s' did not match account '%s'." % (account1, account2)
            raise AssertionError(message)

    def count_active_campaigns(self, timeout=60):
        """Assumes the current page is the member's UMP."""

        web = BuiltIn().get_library_instance('Web')
        table = web._get_object('UMP_Campaigns_Grid')
        start_time = datetime.now()
        while True:
            try:
                count = 0
                rows = web._get_table_row_count('UMP_Campaigns_Grid')
                for row in xrange(1, rows + 1):
                    results = table.find_elements_by_xpath('.//tr[' + str(row) + ']/td[6]')
                    if len(results) > 0:
                        if results[0].text in ['Active', 'Launched']:
                            count += 1
                return str(count)
                #count = table.find_elements_by_xpath(".//tr/td[position()=6 and text()='Active']")
            except Exception as e:
                print(str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'count_active_campaigns: Timed out')

    def count_open_opportunities(self, timeout=60):
        """Assumes the current page is the Oppurtunities page."""

        BuiltIn().run_keyword('Wait For', 'Opportunities_Grid')
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            table = web._get_object('Opportunities_Grid')
            try:
                count = 0
                rows = web._get_table_row_count('Opportunities_Grid')
                for row in xrange(1, rows + 1):
                    results = table.find_elements_by_xpath('.//tr['+str(row)+']/td[8]')
                    if len(results) > 0:
                        if results[0].text == 'Open':
                            count += 1
                return str(count)
            except Exception as e:
                print(str(e))

            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'count_open_opportunities: Timed out')
                    

    def set_lookup_edit(self, keyword, text):
        BuiltIn().run_keyword('Click On', keyword)
        web = BuiltIn().get_library_instance('Web')
        obj = web._get_object(keyword)
        obj.send_keys(text)

    def open_address_change(self, timestamp, timeout=60):
        """Matches an Address Change with Creaded on date within 3 minutes of timestamp."""

        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            try:
                table = web._get_object('AddressChanges_Grid')
                rows = web._get_table_row_count('AddressChanges_Grid')
                for row in xrange(1, rows + 1):
                    print('Checking row: '+str(row))
                    results = table.find_elements_by_xpath('.//tr['+str(row)+']/td[3]')
                    if len(results) == 0:
                        print('Cell not found.')
                        continue
                    dt = results[0].text
                    dt = datetime.strptime(dt, '%m/%d/%Y %I:%M %p')
                    timestamp = BuiltIn().get_variable_value('${timestamp}')
                    print('Comparing: '+str(dt)+' and '+str(timestamp)+'.')
                    if (timestamp - dt).total_seconds() < 3*60:
                        print('Match.')
                        table.find_element_by_xpath('.//tr['+str(row)+']/td[1]/input').click()
                        table.find_element_by_xpath('.//tr['+str(row)+']/td[2]//a').click()
                        BuiltIn().run_keyword('Register Window')
                        return
            except Exception as e:
                print(str(e))

            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Open Address Change: Timed out')

    def format_ssn(self, tin):
        tin = tin.replace('-', '')
        tin = tin[:3] + '-' + tin[3:5] + '-' + tin[5:]
        return tin

    def open_scheduled_transfer(self, from_account, to_account, amount, frequency, timeout=60):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            table = web._get_object('UMP_ScheduledTransfer_Grid')
            try:
                row = table.find_elements_by_xpath(".//tr[./td[2]//text()='"+from_account+"' and ./td[6]//text()='"+to_account+"' and ./td[10][contains(.,'"+amount+"')] and ./td[11]//text()='"+frequency+"']")
                if len(row) > 0:
                    print('Found '+str(len(row))+' results.')
                    row[len(row)-1].click()
                    ActionChains(driver).double_click(row[len(row)-1]).perform()
                    BuiltIn().run_keyword('Register Window')
                    return
            except:
                if (datetime.now() - start_time).total_seconds() > timeout:
                    BuiltIn().run_keyword('Capture Page Screenshot')
                    BuiltIn().run_keyword('Fail', 'Delete Scheduled Transfer: Timed out')

    def delete_scheduled_transfer(self, from_account, to_account, amount, frequency, timeout=60):
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            table = web._get_object('UMP_ScheduledTransfer_Grid')
            try:
                row = table.find_elements_by_xpath(".//tr[./td[2]//text()='"+from_account+"' and ./td[6]//text()='"+to_account+"' and ./td[10][contains(.,'"+amount+"')] and ./td[11]//text()='"+frequency+"']")
                if len(row) > 0:
                    print('Found '+str(len(row))+' results. Removing the last one.')
                    row[len(row)-1].click()
                    BuiltIn().run_keyword('Click On', 'Ribbon_DeleteScheduledTransfer')
                    BuiltIn().run_keyword('Register Window')
                    BuiltIn().run_keyword('Click On', 'Popup_OK')
                    BuiltIn().run_keyword('Unregister Window')
                    return
            except:
                if (datetime.now() - start_time).total_seconds() > timeout:
                    BuiltIn().run_keyword('Capture Page Screenshot')
                    BuiltIn().run_keyword('Fail', 'Delete Scheduled Transfer: Timed out')

    def open_open_opportunity(self, timeout=60):
        """Opens an Opportunity that has status equal to 'Open'."""
        
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            table = web._get_object('Opportunities_Grid')
            try:
                rows = web._get_table_row_count('Opportunities_Grid')
                for row in xrange(1, rows + 1):
                    results = table.find_elements_by_xpath('.//tr['+str(row)+']/td[8]')
                    if len(results) > 0:
                        status = results[0].text
                        if status == 'Open':
                            table.find_element_by_xpath('.//tr['+str(row)+']/td[2]//a').click()
                            BuiltIn().run_keyword('Register Window')
                            return
            except:
                if (datetime.now() - start_time).total_seconds() > timeout:
                    BuiltIn().run_keyword('Capture Page Screenshot')
                    BuiltIn().run_keyword('Fail', 'Open Open Opportunity: Timed out')

    def select_transaction_to_dispute(self, timeout=60):
        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            table = web._get_object('TransactionDispute_Grid')
            try:
                rows = web._get_table_row_count('TransactionDispute_Grid')
                for row in xrange(1, rows + 1):
                    checkbox = table.find_elements_by_xpath(".//tr["+str(row)+"]/td[1]/input[@type='checkbox']")
                    if len(checkbox) > 0:
                        checkbox[0].click()
                        return
            except:
                if (datetime.now() - start_time).total_seconds() > timeout:
                    BuiltIn().run_keyword('Capture Page Screenshot')
                    BuiltIn().run_keyword('Fail', 'Select Transaction To Dispute: Timed out')


