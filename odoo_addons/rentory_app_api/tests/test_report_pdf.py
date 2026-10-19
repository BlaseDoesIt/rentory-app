import base64

from odoo.exceptions import UserError
from odoo.tests import tagged
from odoo.tests.common import TransactionCase


@tagged('post_install', '-at_install')
class TestReportPdf(TransactionCase):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.order = cls.env['rentory.order'].create({
            'customer_name': "Test",
            'customer_phone': "0000",
        })

    def test_prints_a_rentory_document(self):
        data = self.order.rentory_app_report_pdf('rentory.report_price_review')
        self.assertTrue(base64.b64decode(data).startswith(b'%PDF'))

    def test_refuses_other_reports(self):
        with self.assertRaises(UserError):
            self.order.rentory_app_report_pdf('account.report_invoice')
        with self.assertRaises(UserError):
            self.order.rentory_app_report_pdf('rentory.no_such_report')
