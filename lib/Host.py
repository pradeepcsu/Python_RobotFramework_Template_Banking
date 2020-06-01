

#
# Add check in 'open_tsso' to verify region is correct if already logged in.
#


import re
import time
from datetime import datetime

from enum import Enum
from py.common import strip_currency
from robot.libraries.BuiltIn import BuiltIn
from win32com.client import Dispatch

from lib.py import common
import ObjectRepository
from lib.py.postgres import *

host_date_fmt = '%m/%d/%y'
DEFAULT_TIMEOUT = 5
find_timeout = 60


class TssoCommand(Enum):

    TE_CLEAR = '@C'
    TE_ENTER = '@E'
    TE_HOME = '@0'
    TE_PF1 = '@1'
    TE_PF2 = '@2'
    TE_PF3 = '@3'
    TE_PF4 = '@4'
    TE_PF13 = '@d'
    TE_PF14 = '@e'
    TE_TAB = '@T'


class Host(object):

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        ObjectRepository.load_objects('Host')

    def get_login_info(self, username, region):
        con = None
        cur = None
        # standardize the region
        region = region.lower()
        try:
            con = connect_db()
            cur = con.cursor()
            cur.execute("select id, pw from host.users where username=%s and region=%s", (username, region))
            results = cur.fetchall()
            if not results:
                BuiltIn().run_keyword('Fail', 'host user not found for region: {}, {}'.format(username, region))
            login = results[0][0]
            password = results[0][1]
        except:
            raise  # todo
        finally:
            if cur:
                cur.close()
            if con:
                con.close()
        return login, password

    def open_tsso(self):
        hep_file_location = os.getenv('AppData') + '\\Hummingbird\\Connectivity\\14.00\\Profile\\TSSO.hep'
        # hep_file_location = os.path.join(os.getenv('AppData'), 'Hummingbird/Connectivity/14.00/Profile/TSSO.hep')
        host = Dispatch('HostExplorer')
        session_id = None
        if host.CurrentHost is None:
            session_id = host.StartSession(hep_file_location)

        ObjectRepository.d['term'] = host.HostFromProfile('TSSO.hep')
        ObjectRepository.d['term'].WaitConnected(60)

        signed_on = False
        if session_id is None:
            # Check to see if still signed on.
            self.term(TssoCommand.TE_CLEAR.value)
            self.term(TssoCommand.TE_CLEAR.value)
            self.term('RMLP')
            self.term(TssoCommand.TE_ENTER.value)
            field0 = self.get_field_by_id(0)
            if 'Command ===>' in field0:
                signed_on = True

        if not signed_on:
            self.sign_in_tsso()

        BuiltIn().run_keyword('Term', TssoCommand.TE_CLEAR.value)

    def sign_in_tsso(self):
        region = BuiltIn().get_variable_value('${REGION}')
        login, password = self.get_login_info(os.getenv('UserName').lower(), region)

        if region == 'QA':
            BuiltIn().run_keyword('Term', 'ssfqa')
        elif region == 'UAT2':
            BuiltIn().run_keyword('Term', 'ssfuat2')
        elif region == 'DEV2':
            BuiltIn().run_keyword('Term', 'ssfdev2')
        else:
            BuiltIn().run_keyword('Fail', 'Unknown region: {}'.format(region))
            return

        self.term(TssoCommand.TE_ENTER.value)
        self.term(TssoCommand.TE_CLEAR.value)
        self.term('tsso')
        self.term(TssoCommand.TE_ENTER.value)
        BuiltIn().run_keyword('Set Field', 'screen_UserLogin', login)
        BuiltIn().run_keyword('Set Field', 'screen_UserPassword', password)
        BuiltIn().run_keyword('Term', TssoCommand.TE_ENTER.value)
        msg = self.get_field('screen_message')
        if 'EMPL SIGNED' in msg:
            self.term('Y')
            self.term(TssoCommand.TE_ENTER.value)
            if 'FORCED OFF' in self.get_field_by_id(57):
                print('Sign on successful')
            else:
                BuiltIn().run_keyword('Fail', 'Failed to log into TSSO.')
        elif 'SIGN ON IS SUCCESSFUL' in self.get_field_by_id(57):
            print('Sign on successful')
        else:
            BuiltIn().run_keyword('Fail', 'Failed to log into TSSO.')

    def get_bcr_date(self):
        self.term(TssoCommand.TE_CLEAR.value)
        self.term(TssoCommand.TE_HOME.value)
        self.term('imb0')
        self.term(TssoCommand.TE_ENTER.value)
        bcr_date = self.get_field('imb0_currDate')
        bcr_date = bcr_date[0:2]+'/'+bcr_date[2:4]+'/'+bcr_date[4:]
        return bcr_date

    def nav_screen(self, screen):
        self.term(TssoCommand.TE_HOME.value)
        self.term(screen)
        self.term(TssoCommand.TE_ENTER.value)

    def go_to_account_screen(self, account, screen):
        BuiltIn().run_keyword('Term', TssoCommand.TE_CLEAR.value)
        BuiltIn().run_keyword('Term', '{};{}'.format(screen, account))
        BuiltIn().run_keyword('Term', TssoCommand.TE_ENTER.value)
        if screen.lower() in ('imi2', 'imi3', 'imi5', 'sti2'):
            self.term(TssoCommand.TE_ENTER.value)
        elif screen.lower()[:2] == 'am':
            self.term(account)
            self.term(TssoCommand.TE_ENTER.value)

    def go_to_member_screen(self, cis, screen):
        self.term(TssoCommand.TE_CLEAR.value)
        self.term('{};nb{}'.format(screen, cis))
        self.term(TssoCommand.TE_ENTER.value)

    def query_member_host(self, cis):
        BuiltIn().run_keyword('Term', TssoCommand.TE_CLEAR.value)
        BuiltIn().run_keyword('Term', TssoCommand.TE_CLEAR.value)
        BuiltIn().run_keyword('Term', 'rmlp;nb' + cis)
        BuiltIn().run_keyword('Term', TssoCommand.TE_ENTER.value)

    def open_account_host(self, account):
        BuiltIn().run_keyword('Nav Screen', 'rmab')
        idx = self.find_account_host(account)
        if idx == 0:
            BuiltIn().run_keyword('Fail', 'Account not found in Host.')
        else:
            self.set_field('rmab_AccountSelect' + str(idx), 'x')
        BuiltIn().run_keyword('Term', TssoCommand.TE_ENTER.value)

    def get_new_member(self, timeout=DEFAULT_TIMEOUT):
        """ Currently only used for QuickApprove to create new data."""

        start_time = datetime.now()
        while True:
            self.term(TssoCommand.TE_CLEAR.value)
            ssn = common.get_random_ssn()
            self.term('rmlp;tn'+ssn)
            self.term(TssoCommand.TE_ENTER.value)
            if self.check_message('UNABLE TO LOCATE CUSTOMER'):
                return ssn
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Fail', 'Get New Member: Timed out.')

    def get_new_or_non_pc_member(self, timeout=DEFAULT_TIMEOUT):
        """ Currently only used for QuickApprove to create new data."""

        web = BuiltIn().get_library_instance('Web')
        start_time = datetime.now()
        while True:
            self.term(TssoCommand.TE_CLEAR.value)
            ssn = web.get_random_ssn()
            self.term('rmlp;tn'+ssn)
            self.term(TssoCommand.TE_ENTER.value)
            if self.check_message('UNABLE TO LOCATE CUSTOMER'):
                return (ssn, False)
            self.nav_screen('rmc2')
            if not self.is_presidents_club():
                return (ssn, True)
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Fail', 'Get New Or Non PC Member: Timed out.')

    def find_account_host(self, account):
        idx = 1
        while not re.match('[0]*' + account, self.get_field('rmab_Account' + str(idx))):
            if idx == 7:
                if self.check_message('LAST PAGE'):
                    return 0
                self.term(TssoCommand.TE_PF1.value)
                idx = 0
            idx += 1

        return idx

    def check_message(self, msg):
        if not self.host_field_exists('screen_message'):
            return False
        if msg in self.get_field('screen_message'):
            return True
        else:
            return False

    def get_code_word(self):
        """Assumes a member is accessed in Host."""

        BuiltIn().run_keyword('Nav Screen', 'rmc2')
        while True:
            for idx in xrange(1, 3):
                custid_type = self.get_field('rmc2_CustId_Type_' + str(idx))
                if custid_type == 'SC':
                    return self.get_field('rmc2_CustId_IdNum_Value_' + str(idx))
                elif custid_type == '':
                    return ''
            BuiltIn().run_keyword('Term', TssoCommand.TE_PF13.value)

    def get_email_address(self):
        """Assumes a member is accessed in Host."""

        BuiltIn().run_keyword('Nav Screen', 'rmce')
        start_time = time.time()
        while True:
            email_type = self.get_field('rmce_EmailType')
            email_addr = self.get_field('rmce_EAddr')
            if email_type == 'E':
                return email_addr
            elif email_addr == '':
                return ''
            BuiltIn().run_keyword('Term', TssoCommand.TE_PF1.value)
            if time.time() - start_time > 30:
                BuiltIn().run_keyword('Fail', 'Get Email Address: Timed out')

    def is_presidents_club(self):
        u1 = self.get_field('rmc2_UserField1')
        if len(u1) > 1 and re.match('[PKLNS]', u1[1]):
            return True
        else:
            return False

    def is_ssig(self):
        u2 = self.get_field('rmc2_UserField2')
        if len(u2) > 9 and re.match('[ABCDEFGHXYZ]', u2[9]):
            return True
        else:
            return False

    def is_employee(self):
        oed_code = self.get_field('rmc2_OEDCode')
        if oed_code == 'E':
            return True
        else:
            return False

    def is_youth(self):
        u1 = self.get_field('rmc2_UserField1')
        if len(u1) > 2 and u1[2] == 'Y':
            return True
        else:
            return False

    def is_senior(self):
        dob = self.get_field('rmc3_DateOfBirth')
        # Special case
        if dob == '00/00/0000':
            return False
        dob = datetime.strptime(dob, '%m/%d/%Y')
        if (datetime.now() - dob).total_seconds() / (365.25*24*60*60) >= 65:
            return True
        else:
            return False

    def is_board_of_directors(self):
        u1 = self.get_field('rmc2_UserField1')
        if len(u1) > 5 and u1[5] == 'B':
            return True
        else:
            return False

    def is_deceased(self):
        u1 = self.get_field('rmc2_UserField1')
        if len(u1) > 6 and u1[6] == 'D':
            return True
        else:
            return False

    def is_freedom50(self):
        self.nav_screen('rmab')
        while not self.check_message('FIRST'): # Go to first RMAB page
            self.term(TssoCommand.TE_PF2.value)

        while True:
            for idx in xrange(1, 8):
                if self.get_field('rmab_AccountSelect' + str(idx)) != '_':
                    return False
                if self.get_field('rmab_AccountStatus' + str(idx)) != '':
                    
                    account_type = self.get_field('rmab_AccountAppl' + str(idx))
                    if account_type == 'IM':
                        self.set_field('rmab_AccountSelect' + str(idx), 'x')
                        self.term(TssoCommand.TE_ENTER.value)
                        self.term(TssoCommand.TE_PF1.value)
                        if re.match('[CGEL]', self.get_field('imi1_SvcChrg_Type')):
                            return True
                        self.term(TssoCommand.TE_HOME.value)
                        self.term('rmab')
                        self.term(TssoCommand.TE_ENTER.value)
                    elif account_type in ['RF', 'PL', 'ST']:
                        # we are past the IM accounts
                        return False

            if self.check_message('LAST'):
                return False
            self.term(TssoCommand.TE_PF1.value)

    def term(self, text):
        ObjectRepository.d['term'].Keys(text)
        ObjectRepository.d['term'].WaitPSUpdated(0.5, True)

    def host_next_page(self):
        ObjectRepository.d['term'].Keys(TssoCommand.TE_PF1.value)
        ObjectRepository.d['term'].WaitPSUpdated(0.5, True)

    def set_field(self, field, text):
        self._field_obj(field).Text = text
        if self._field_obj(field).Text != text:
            BuiltIn().run_keyword('Fail', 'Failed to set the host field.')

    def get_field(self, field):
        return self._field_obj(field).Text

    def print_host_object_value(self, field):
        t = self.get_field(field)
        print('Keyword: {}'.format(field))
        print('Value: {}'.format(t))

    def get_field_by_id(self, field):
        return ObjectRepository.d['term'].Fields(field).Text

    def host_field_exists(self, field):
        if self._field_obj(field).Pos == -1:
            return False
        else:
            return True
            
    def wait_for_field(self, field, displayed=True, timeout=30):
        start_time = datetime.now()
        while True:
            if self.host_field_exists(field):
                break
            time.sleep(1)
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Fail', 'Wait For Field')
    
    def _field_obj(self, field):
        field_id = ObjectRepository.d[field].obj_id
        if field_id == 'id':
            return ObjectRepository.d['term'].Fields(ObjectRepository.d[field].obj_value)
        else:
            field_id = ObjectRepository.d['term'].FieldId(ObjectRepository.d[field].obj_id)
            return ObjectRepository.d['term'].Fields(field_id)

    def expect_field(self, obj_keyword, text, timeout=DEFAULT_TIMEOUT):
        """
        Compares the text retrieved from the object with text given.

        Fails the test if the texts don't match.
        """

        start_time = datetime.now()
        suppress_error = True

        while True:
            exception_occurred = False
            try:
                BuiltIn().run_keyword('Unselect Frame')
                self.current_frame = None
                obj_locator = self.obj(obj_keyword)
                BuiltIn().run_keyword('Element Text Should Be', obj_locator, text)
            except:
                exception_occurred = True
                if not suppress_error:
                    raise
            
            if not exception_occurred:
                break

            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Fail', 'Select List Item ... Item could not be selected.')

    def expect_field_regex(self, obj_keyword, string, timeout=DEFAULT_TIMEOUT):
        """
        Compares the text retrieved from the object with text given using a regular expression.

        Fails the test if the texts don't match.
        """

        start_time = datetime.now()
        suppress_error = True

        while True:
            exception_occurred = False
            try:
                BuiltIn().run_keyword('Unselect Frame')
                self.current_frame = None
                elem = self._get_obj(obj_keyword)
                if elem is None:
                    BuiltIn().run_keyword('Fail', 'Expect Text RegEx ... did not find the object.')

                print("Verifying element '%s' contains regular expression '%s'."
                                % (obj_keyword, string))
                if not re.match(string, elem.text, re.DOTALL):
                    message = "Element '%s' should have contained regular expression '%s' but "\
                          "its text was '%s'." % (obj_keyword, string, elem.text)
                    raise AssertionError(message)
            except:
                exception_occurred = True
                if not suppress_error:
                    raise

            if not exception_occurred:
                break

            time.sleep(2)
            if (datetime.now() - start_time).total_seconds() > timeout/2:
                suppress_error = False
            if (datetime.now() - start_time).total_seconds() > timeout:
                BuiltIn().run_keyword('Fail', 'Expect Text RegEx ... timed out.')

    def verify_name(self, name):
        self.nav_screen('rmi1')
        host_member_name = self.get_field('rmi1_MemberName')
        sn = name.split()
        for w in sn:
            if w not in host_member_name:
                message = "Name '%s' did not match name from Host '%s'." % (name, host_member_name)
                raise AssertionError(message)

    def find_stoppayment_on_imi5(self, request_date=None, rsp_amount=None, rsp_start_no=None, rsp_end_no=None, rsp_payee_reason=None, stop_payment_type=None, timeout=find_timeout):
        rows = 7
        start_time = datetime.now()
        rsp_request_dt = datetime.strptime(request_date, '%m/%d/%Y')
        stop_payment_type = "range"
        if stop_payment_type:
            typ_target = "STR"

        print('find_stoppayment_on_imi5:  low serial: {}  high serial: {}  reason: {}  date: {}'.format(rsp_start_no, rsp_end_no, rsp_payee_reason, rsp_request_dt))
        while True:
            for row in xrange(1, rows+1):
                #if self.get_field('imi5_select_{}'.format(row)) != '_':
                    #break

                row_text = self.get_field('imi5_row_{}'.format(row))
                print('row {} text: "{}"'.format(row, row_text))
                if not row_text:
                    break

                row_text2 = self.get_field('imi5_row_{}_A'.format(row))
                print('row {} text: "{}"'.format(row, row_text2))
                if not row_text2:
                    break

                r_typ = row_text2[54:54+3].strip()
                print('r_typ in host is {} :'.format(r_typ))

                if r_typ != typ_target:
                    continue

                r_low_ser = row_text[12:12+4].strip()
                r_high_ser = row_text[23:23+4].strip()
                r_amount = row_text[40:40+4].strip
                r_date = row_text[67:67+8].strip()

                if r_low_ser == " ":
                    continue

                if r_high_ser == " ":
                    continue

                if r_date == " ":
                    continue

                r_date_dt = datetime.strptime(r_date, '%m/%d/%y')

                print('r_low_ser: {}  r_high_ser: {}  r_date_dt: {}'.format(r_low_ser, r_high_ser, r_date_dt))
                if rsp_start_no is not None:
                    if rsp_start_no != r_low_ser:
                        print("check starting no argument '{}' did not match low serial found '{}'.".format(rsp_start_no, r_low_ser))
                        continue
                if rsp_end_no is not None:
                    if rsp_end_no != r_high_ser:
                        print("check ending no argument '{}' did not match high serial found '{}'.".format(rsp_end_no, r_high_ser))
                        continue
                if rsp_request_dt is not None:
                    if rsp_request_dt != r_date_dt:
                        print("Date argument '{}' did not match date found '{}'.".format(rsp_request_dt, r_date_dt))
                        continue
                #if ttime is not None:
                    # TODO
                   # pass
                print('Match on row {}!'.format(row))
                return row

            self.term(TssoCommand.TE_PF1.value)
            if self.check_message('CANNOT'):
                return 0
            elif self.check_message('INVALID'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

    def find_stoppayment_single_check_on_imi5(self, request_date=None, rsp_amount=None, rsp_start_no=None, rsp_end_no=None, rsp_payee_reason=None, stop_payment_type=None, timeout=find_timeout):
        rows = 7
        start_time = datetime.now()
        rsp_request_dt = datetime.strptime(request_date, '%m/%d/%Y')
        stop_payment_type = "range"
        print(stop_payment_type)
        if stop_payment_type:
            typ_target = "STP"

        #print('find_stoppayment_on_imi5:  low serial: {}  reason: {}'.format(rsp_start_no, rsp_payee_reason))
        print('find_stoppayment_on_imi5:  low serial: {}  reason: {}  date: {}'.format(rsp_start_no, rsp_payee_reason, rsp_request_dt))

        while True:
            for row in xrange(1, rows+1):
                #if self.get_field('imi5_select_{}'.format(row)) != '_':
                    #break

                row_text = self.get_field('imi5_row_{}'.format(row))
                print('row {} text: "{}"'.format(row, row_text))
                if not row_text:
                    break

                row_text2 = self.get_field('imi5_row_{}_A'.format(row))
                print('row {} text: "{}"'.format(row, row_text2))
                if not row_text2:
                    break

                r_typ = row_text2[54:54+3].strip()
                print('r_typ in host is {} :'.format(r_typ))

                if r_typ != typ_target:
                    continue

                r_low_ser = row_text[12:12+4].strip()
                r_high_ser = row_text[23:23+4].strip()
                r_amount = row_text[40:40+4].strip
                r_date = row_text[67:67+8].strip()

                if r_date == " ":
                    continue

                if r_high_ser == " ":
                    continue

                r_date_dt = datetime.strptime(r_date, '%m/%d/%y')

                print('r_low_ser: {}  r_high_ser: {}  r_date_dt: {}'.format(r_low_ser, r_high_ser, r_date_dt))
                if rsp_start_no is not None:
                    if rsp_start_no != r_low_ser:
                        print("check starting no argument '{}' did not match low serial found '{}'.".format(rsp_start_no, r_low_ser))
                        continue
                if rsp_end_no is not None:
                    if rsp_end_no != r_high_ser:
                        print("check ending no argument '{}' did not match high serial found '{}'.".format(rsp_end_no, r_high_ser))
                        continue
                if rsp_request_dt is not None:
                    if rsp_request_dt != r_date_dt:
                        print("Date argument '{}' did not match date found '{}'.".format(rsp_request_dt, r_date_dt))
                        continue

                #if ttime is not None:
                    # TODO
                   # pass
                print('Match on row {}!'.format(row))
                return row

            self.term(TssoCommand.TE_PF1.value)
            if self.check_message('CANNOT'):
                return 0
            elif self.check_message('INVALID'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

    def find_stoppayment_single_check_on_imi5_postbatch(self, request_date=None, rsp_amount=None, rsp_start_no=None, rsp_end_no=None, rsp_payee_reason=None, stop_payment_type=None,timeout=find_timeout):
        rows = 7
        start_time = datetime.now()
        #rsp_request_dt = datetime.strptime(request_date, '%m/%d/%Y')
        stop_payment_type = "range"
        if stop_payment_type:
            typ_target = "STP"

        print('find_stoppayment_on_imi5:  low serial: {}  reason: {}'.format(rsp_start_no, rsp_payee_reason))
        # print('find_stoppayment_on_imi5:  low serial: {}  reason: {}  date: {}'.format(rsp_start_no, rsp_payee_reason, rsp_request_dt))

        while True:
            for row in xrange(1, rows + 1):
                # if self.get_field('imi5_select_{}'.format(row)) != '_':
                # break

                row_text = self.get_field('imi5_row_{}'.format(row))
                print('row {} text: "{}"'.format(row, row_text))
                if not row_text:
                    break

                row_text2 = self.get_field('imi5_row_{}_A'.format(row))
                print('row {} text: "{}"'.format(row, row_text2))
                if not row_text2:
                    break

                r_typ = row_text2[54:54 + 3].strip()
                print('r_typ in host is {} :'.format(r_typ))

                if r_typ != typ_target:
                    continue

                r_low_ser = row_text[12:12 + 4].strip()
                r_high_ser = row_text[23:23 + 4].strip()
                r_amount = row_text[40:40 + 4].strip
                r_date = row_text[67:67 + 8].strip()

                if r_date == " ":
                    continue

                if r_high_ser == " ":
                    continue

                r_date_dt = datetime.strptime(r_date, '%m/%d/%y')

                print('r_low_ser: {}  r_high_ser: {}  r_date_dt: {}'.format(r_low_ser, r_high_ser, r_date_dt))
                if rsp_start_no is not None:
                    if rsp_start_no != r_low_ser:
                        print("check starting no argument '{}' did not match low serial found '{}'.".format(rsp_start_no,r_low_ser))
                        continue
                if rsp_end_no is not None:
                    if rsp_end_no != r_high_ser:
                        print("check ending no argument '{}' did not match high serial found '{}'.".format(rsp_end_no,r_high_ser))
                        continue
                #if rsp_request_dt is not None:
                # if rsp_request_dt != r_date_dt:
                # print("Date argument '{}' did not match date found '{}'.".format(rsp_request_dt, r_date_dt))
                # continue

                # if ttime is not None:
                # TODO
                # pass
                print('Match on row {}!'.format(row))
                return row

            self.term(TssoCommand.TE_PF1.value)
            if self.check_message('CANNOT'):
                return 0
            elif self.check_message('INVALID'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

    def find_transaction_on_sti2(self, tdate=None, tamount=None, tdescr=None, tcode=None, timeout=find_timeout):
        rows = 15
        if tcode == 'RTE':
            tcode = 'INT'
        start_time = datetime.now()
        tdate = tdate.strftime(host_date_fmt)
        while True:
            for row in xrange(1, rows+1):
                row_text = self.get_field('sti2_row_{}'.format(row))
                print('row {} text: {}'.format(row, row_text))
                if not row_text:
                    break
                rdate = row_text[36:36+9].strip()
                rcode = row_text[46:46+3].strip().lstrip('0')
                rdescr = row_text[56:56+17].strip()
                ramount = row_text[25:25+9].strip()
                print('rdate: {}  rcode: {}  rdescr: {}  ramount: {}'.format(rdate, rcode, rdescr, ramount))
                if tdate is not None:
                    if tdate != rdate:
                        print("Date argument '{}' did not match date found '{}'.".format(tdate, rdate))
                        continue
                if tamount is not None:
                    if tamount != ramount:
                        print("Amount argument '{}' did not match amount found '{}'.".format(tamount, ramount))
                        continue
                if tdescr is not None:
                    if tdescr != rdescr and rdescr not in tdescr:
                        print("Description argument '{}' did not match description found '{}'.".format(tdescr, rdescr))
                        continue
                if tcode is not None:
                    if tcode != rcode:
                        print("Tran code argument '{}' did not match tran code found '{}'".format(tcode, rcode))
                        continue
                print('Match on row {}!'.format(row))
                return row
            self.term(TssoCommand.TE_PF1.value)
            if self.check_message('CANNOT'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

    def find_transaction_on_imi2(self, tdate=None, tamount=None, tdescr=None, tcode=None, ttime=None, timeout=find_timeout):
        rows = 15
        start_time = datetime.now()
        tdate = tdate.strftime('%m/%d')

        print('find_transaction_on_imi2:  date: {}  amount: {}  descr: {}  code: {}  time: {}'.format(tdate, tamount, tdescr, tcode, ttime))
        while True:
            for row in xrange(1, rows+1):
                if self.get_field('imi2_select_{}'.format(row)) != '_':
                    break

                row_text = self.get_field('imi2_row_{}'.format(row))
                print('row {} text: "{}"'.format(row, row_text))
                if not row_text:
                    break

                rdate = row_text[:5].strip()
                rcode = row_text[30:30+4].strip().lstrip('0')
                rdescr = row_text[53:53+22].strip()
                ramount = row_text[35:35+15].strip()

                print('rdate: {}  rcode: {}  rdescr: {}  ramount: {}'.format(rdate, rcode, rdescr, ramount))
                if tdate is not None:
                    if tdate != rdate:
                        print("Date argument '{}' did not match date found '{}'.".format(tdate, rdate))
                        continue
                if tamount is not None:
                    if strip_currency(tamount) != strip_currency(ramount):
                        print("Amount argument '{}' did not match amount found '{}'.".format(tamount, ramount))
                        continue
                if tdescr is not None:
                    if tdescr != rdescr and rdescr not in tdescr:
                        print("Description argument '{}' did not match description found '{}'.".format(tdescr, rdescr))
                        continue
                if tcode is not None:
                    if tcode != rcode:
                        print("Tran code argument '{}' did not match tran code found '{}'".format(tcode, rcode))
                        continue
                if ttime is not None:
                    # TODO
                    pass
                print('Match on row {}!'.format(row))
                return row

            self.term(TssoCommand.TE_PF1.value)
            if self.check_message('CANNOT'):
                return 0
            elif self.check_message('1ST'):
                return 0
            elif self.check_message('INVALID'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

    def find_transaction_on_amhs(self, tdate=None, tamount=None, tdescr=None, tcode=None, tbalance=None, timeout=find_timeout):
        rows = 14
        start_time = datetime.now()
        tdate = tdate.strftime('%m/%d/%y')
        while True:
            for row in xrange(1, rows+1):

                rdate = self.get_field('amhs_effDate_{}'.format(row)).strip()
                rcode = self.get_field('amhs_tran_{}'.format(row)).strip().lstrip('0')
                rdescr = self.get_field('amhs_description_{}'.format(row)).strip()
                amount_balance = self.get_field('amhs_amount_balance_{}'.format(row))
                ramount = amount_balance[:17].strip()
                rbalance = amount_balance[17:].strip()
                print('rdate: {}  rcode: {}  rdescr: {}  ramount: {} (amount_balance: {})'.format(rdate, rcode, rdescr, ramount, amount_balance))

                if tdate is not None:
                    if tdate != rdate:
                        print("Date argument '{}' did not match date found '{}'.".format(tdate, rdate))
                        continue
                if tamount is not None:
                    if tamount != ramount:
                        print("Amount argument '{}' did not match amount found '{}'.".format(tamount, ramount))
                        continue
                if tdescr is not None:
                    if tdescr != rdescr and rdescr not in tdescr:
                        print("Description argument '{}' did not match description found '{}'.".format(tdescr, rdescr))
                        continue
                if tcode is not None:
                    if tcode != rcode:
                        print("Tran code argument '{}' did not match tran code found '{}'".format(tcode, rcode))
                        continue
                if tbalance is not None:
                    if tbalance != rbalance:
                        print("Balance argument '{}' did not match balance found '{}'.".format(tbalance, rbalance))
                        continue

                print('Match on row {}!'.format(row))
                return row

            self.term(TssoCommand.TE_PF3.value)
            if self.check_message('END OF DATA'):
                return 0
            if (datetime.now() - start_time).total_seconds() > timeout:
                return 0

