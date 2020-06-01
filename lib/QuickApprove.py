# TODO

# Verify Radio Button
# update_application: Fix for "Multiple Records Found"
# Application Info: Fix possible invalid phone numbers, e.g. (210)000-0000
# Generate Card Number: Sometimes times out with error.

import time
from datetime import datetime

from robot.libraries.BuiltIn import BuiltIn

import ObjectRepository
import Web


class QuickApprove(Web.Web):

    def __init__(self):
        super(QuickApprove, self).__init__()
        self.aut = 'quickapprove'
        ObjectRepository.load_objects('QuickApprove')

    def fail_test(self, reason, force=False):
        self.screenshot_page()
        BuiltIn().run_keyword('Fail', reason)

    def close_error(self):
        driver = BuiltIn().get_library_instance('Selenium2Library')._current_browser()
        time.sleep(4)
        if len(driver.window_handles) > len(self.windows):
            self.register_window()
            BuiltIn().run_keyword('Close Window')
            self.unregister_window()

    def fill_applicant_info(self, ssn, existing):
        self.send_keys('Applicant_SSNvalue', ssn)
        self.click_on('Applicant_QueryHost')
        if self.is_new_window():
            self.register_window()
            self.click_on('Applicant_QueryHost_UpdateApp')
            self.unregister_window()
        # General Information
        self.click_type('Applicant_FirstName', self.get_random_string(6), if_empty=True)
        self.click_type('Applicant_LastName', self.get_random_string(6), if_empty=True)
        self.click_type('Applicant_HomePhoneNumber', '2105555100', if_empty=True)
        self.click_type('Applicant_DOB', '7/20/1980', if_empty=True)
        self.select_list_item('Applicant_EmploymentStatus', 'EMPLOYED')
        self.click_type('Applicant_EmploymentDuration_Year', '2')
        self.click_type('Applicant_Employer', 'Test', if_empty=True)
        self.select_list_item('Applicant_Occupation', 'CONSTRUCTION')
        time.sleep(1)
        self.click_type('Applicant_GrossIncome', '5000', if_empty=True)
        # Primary ID Card
        self.click_type('Applicant_PrimaryID_Number', self.get_random_alphanumeric_string(8), if_empty=True)
        self.select_list_item('Applicant_PrimaryID_State', 'TX')
        self.click_type('Applicant_PrimaryID_Issued', '8/4/2000', if_empty=True)
        self.click_type('Applicant_PrimaryID_Expire', '8/4/2017', if_empty=True)
        # Address
        self.click_type('Applicant_Address', '123 Testing Street', if_empty=True)
        self.click_type('Applicant_Zip', '78249', if_empty=True)
        #self.click_on('Applicant_City')
        # These should be automatically filled in
        #self.send_keys('Applicant_City', 'SAN ANTONIO')
        #self.select_list_item('Applicant_State', 'TX')
        self.select_list_item('Applicant_OccupancyStatus', 'RENT')
        time.sleep(1)
        self.click_type('Applicant_OccupancyDuration_Years', '2')
        # Click Twice
        self.click_on('Applicant_QueryHost')
        self.click_on('Applicant_QueryHost')
        if self.is_new_window():
            self.register_window()
            if self.check_exists('FieldOfMemebership_002'):
                self.click_on('FieldOfMemebership_002')
                self.click_on('FieldOfMemebership_SaveClose')
            else:
                self.click_on('Applicant_QueryHost_UpdateApp')
            self.unregister_window()

    def get_debit_card_account_numbers(self):
        table = self._get_object('CreateNewAccounts_DebitCardsTable')
        rows = table.find_elements_by_xpath('.//tr')
        nums = []
        for row in rows:
            td = row.find_elements_by_xpath('./td[4]')
            if len(td) > 0:
                nums.append(td[0].text)
        return nums
    
    def generate_card_number(self, timeout=60):
        start_time = datetime.now()
        while True:
            try:
                self.click_on('ATMInfo_AddCard_Generate', wait=1)
                while self.get_object_value('ATMInfo_AddCard_AccountNumber_1') == '':
                    time.sleep(1)
                    if self.alert_present():
                        self.close_alert()
                    if (datetime.now() - start_time).total_seconds() > timeout:
                        BuiltIn().run_keyword('Capture Page Screenshot')
                        BuiltIn().run_keyword('Fail', 'Generate Card Number: Timed out waiting for card number.')
                return
            except Exception as e:
                print('Error: '+str(e))
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Generate Card Number: Timed out with error.')
                
    
    def wait_for_account_numbers(self, timeout=60):
        start_time = datetime.now()
        while True:
            try:
                table = self._get_object('AccountSummary_Table')
                rows = table.find_elements_by_xpath('.//tr')
                filled = True
                for row in rows:
                    td = row.find_elements_by_xpath('./td[3]')
                    if len(td) > 0:
                        if td[0].text == '':
                            filled = False
                if filled == True:
                    return
            except Exception as e:
                print(str(e))
                time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Wait For Account Numbers: Timed out.')

    def update_application(self, expect_popup=False, timeout=60):
        self.click_on('Applicant_QueryHost')
        if self.new_window_opened():
            self.register_window()
            self.click_on('Applicant_QueryHost_UpdateApp')
            self.unregister_window()
        else:
            if expect_popup:
                start_time = datetime.now()
                while True:
                    self.click_on('Applicant_QueryHost')
                    if self.new_window_opened():
                        self.register_window()
                        self.click_on('Applicant_QueryHost_UpdateApp')
                        self.unregister_window()
                        return
                    if (datetime.now() - start_time).total_seconds() > timeout:
                        BuiltIn().run_keyword('Capture Page Screenshot')
                        BuiltIn().run_keyword('Fail', 'Update Application: Timed out.')
        
        
        
    def override_debit_bureau_results(self, ssn=None, timeout=120):
        start_time = datetime.now()
        while True:
            time.sleep(1)
            print('Checking if exists')
            if self.check_exists('Underwriting_Qualifile_Decision_1'):
                print('exists')
                break
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Capture Page Screenshot')
                BuiltIn().run_keyword('Fail', 'Override Debit Bureau Results: Timed out.')

        for idx in xrange(1, 5):
            item = 'Underwriting_Qualifile_Decision_'+str(idx)
            if self.check_exists(item):
                decision = self.get_element_text(item)
                print('Decision: '+decision)
                if decision == 'REVIEW':
                    print('Overriding...')
                    self.click_on('Underwriting_Override_'+str(idx))
                    self.register_window()
                    self.select_list_item('Underwriting_Override_Reason', 'Legal')
                    self.click_on('Underwriting_Override_OK')
                    self.unregister_window()
                elif decision == 'NOT RUN':
                    self.click_on('Underwriting_ManualEntry_'+str(idx))
                    self.register_window()
                    self.click_type('Underwriting_ManualEntry_SSNValidation_1', ssn)
                    self.click_on('ApplicationReq_Edit_Save')
                    self.unregister_window()

            else:
                return

    def write_to_file(self, *args):
        output_dir = BuiltIn().get_variable_value('${OUTPUT DIR}')
        print(output_dir)
        with open(output_dir+'\\New Accounts.csv', 'a') as f:
            first = True
            f.write('\n')
            for arg in args:
                if first:
                    f.write(arg)
                    first = False
                else:
                    f.write(','+arg)
            f.close()
