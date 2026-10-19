import base64

from odoo import models
from odoo.exceptions import UserError


class RentoryOrder(models.Model):
    _inherit = 'rentory.order'

    def rentory_app_report_pdf(self, report_name):
        """Render one Rentory document for this order and return it as base64.

        Public on purpose: JSON-2 can only call public methods. Guarded so it
        prints nothing a user could not already print in Odoo:

        * only reports named ``rentory.*`` that are bound to ``rentory.order``;
        * only orders the caller can read (record rules included);
        * rendered as the caller, so the report's own group rules apply.
        """
        self.ensure_one()
        if not isinstance(report_name, str) or not report_name.startswith('rentory.'):
            raise UserError(self.env._("Only Rentory's own documents can be printed from the app."))
        Report = self.env['ir.actions.report']
        report = Report._get_report_from_name(report_name)
        if not report or report.model != self._name:
            raise UserError(self.env._(
                "%(report)s is not a document of a rental order.", report=report_name,
            ))
        self.check_access('read')
        pdf, _kind = Report._render_qweb_pdf(report.report_name, res_ids=self.ids)
        return base64.b64encode(pdf).decode()
