from docutils import nodes
from docutils.parsers.rst import Directive

from sphinx.locale import _
from sphinx.util.docutils import SphinxDirective

class tracker_node(nodes.Element):
    pass

def tracker_role(role, rawtext, issuekey, lineno, inliner, options=None, content=None):
    link = "https://tracker.moodle.org/browse/{0}".format(
        issuekey
    )
    anchor = issuekey
    link_node = nodes.reference(issuekey, anchor, refuri = link)

    return [link_node], []

def setup(app):
    app.add_role('tracker', tracker_role)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
