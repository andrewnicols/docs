import re
import sys

from io import open

try:
    from setuptools import setup, find_packages

except ImportError:
    print('''
Error: devdocs require setuptools to install.
'''.strip())

    sys.exit(1)

DOCS_REQUIRES = (
    'sphinx-multiversion',
    'sphinx_rtd_theme',
    'myst-parser',
    'linkify-it-py',
)

if __name__ == '__main__':
  setup(
      name='Moodle Developer Documentation',
      description='Developer documentation for Moodle LMS',
      license='GPLv3',
      url='https://develop.moodle.org',
      project_urls={
          'Documentation': 'https://develop.moodle.org',
      },
      extras_require={
          'docs': DOCS_REQUIRES,
      },
  )
