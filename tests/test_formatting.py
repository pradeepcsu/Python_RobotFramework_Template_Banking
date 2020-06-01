

import unittest
import locale
locale.setlocale(locale.LC_ALL, '')
from lib.py.common import strip_currency

class TestFormatting(unittest.TestCase):
    """
    def strip_currency(curr):
    if not curr:
        return
    if curr[0] == '(' and curr[-1] == ')':
        curr = '-' + curr[1:-1]
    return curr.replace('$', '').replace(',', '').strip()

    x.xx

    """
    def test_from_mybranch(self):
        input_ = '$4.56'
        result = strip_currency(input_)
        self.assertEqual(result, '4.56')

    def test_from_host(self):
        input_ = '7.56'
        result = strip_currency(input_)
        self.assertEqual(result, '7.56')

    def test_from_host_negative(self):
        input_ = '(4.55)'
        result = strip_currency(input_)
        self.assertEqual(result, '-4.55')

    def test_from_host_cents(self):
        input_ = '0.56'
        result = strip_currency(input_)
        self.assertEqual(result, '0.56')

    def test_from_host_cents_withoutzero(self):
        input_ = '.56'
        result = strip_currency(input_)
        self.assertEqual(result, '0.56')

    def test_from_host_cents_withextrazero(self):
        input_ = '0.560'
        result = strip_currency(input_)
        self.assertEqual(result, '0.56')