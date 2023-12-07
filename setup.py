import codecs, multiprocessing, os, sys, subprocess, stat, re
from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
with codecs.open(os.path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

# https://packaging.python.org/guides/single-sourcing-package-version/
def read(*parts):
    with codecs.open(os.path.join(here, *parts), 'r') as fp:
        return fp.read()

def find_version(*file_paths):
    version_file = read(*file_paths)
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


setup(
    name='cppyy-cling',
    description='Re-packaged Cling, as backend for cppyy',
    long_description=long_description,
    url='https://root.cern.ch/cling',

    maintainer='Wim Lavrijsen',
    maintainer_email='WLavrijsen@lbl.gov',

    version=find_version('python', 'cppyy_backend', '_version.py'),

    license='LLVM: UoI-NCSA; ROOT: LGPL 2.1',

    classifiers=[
        'Development Status :: 6 - Mature',

        'Intended Audience :: Developers',
        'Intended Audience :: Science/Research',

        'Topic :: Software Development',
        'Topic :: Software Development :: Interpreters',

        'License :: OSI Approved :: University of Illinois/NCSA Open Source License',
        'License :: OSI Approved :: GNU Lesser General Public License v2 or later (LGPLv2+)',

        'Operating System :: POSIX',
        'Operating System :: POSIX :: Linux',
        'Operating System :: MacOS :: MacOS X',

        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: C',
        'Programming Language :: C++',

        'Natural Language :: English'
    ],

    keywords='interpreter development',

    setup_requires=['wheel'],

    package_data={'cppyy_backend': ['cmake/*.cmake', 'pkg_templates/*.in', 'pkg_templates/*.py']},

    package_dir={'': 'python'},
    packages=find_packages('python', include=['cppyy_backend']),

    entry_points={
        "console_scripts": [
            "cling-config = cppyy_backend._cling_config:main",
            "genreflex = cppyy_backend._genreflex:main",
            "rootcling = cppyy_backend._rootcling:main",
            "cppyy-generator = cppyy_backend._cppyy_generator:main",
        ],
    },

    zip_safe=False,
)
