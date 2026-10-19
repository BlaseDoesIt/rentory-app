{
    'name': "Rentory App API",
    'version': '19.0.1.0.0',
    'category': 'Rentory',
    'summary': "Lets the Rentory app print Rentory's documents over JSON-2.",
    'description': """
The Rentory app talks to Odoo over the JSON-2 API with each person's API key.
Odoo's own `/report/pdf/...` pages want a browser session and send an API
key to the login page, so the app cannot print through them.

This adds one public method, `rentory.order.rentory_app_report_pdf`, which
renders one of Rentory's own order documents (report names starting with
`rentory.`) for orders the caller can read, and returns the PDF as base64.

Nothing else changes: no fields, no views, no data.
""",
    'author': "Kosai Alhafez",
    'website': "https://blasedoesit.com",
    'depends': ['rentory'],
    'data': [],
    'installable': True,
    'application': False,
    'license': 'LGPL-3',
}
