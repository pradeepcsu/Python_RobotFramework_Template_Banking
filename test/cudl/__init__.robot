*** Settings ***
# Library           Selenium2Library
# Resource          myBranch Keywords.txt
# Documentation     Test documentation for myBranch test suite.
# Suite Setup       Open CUDL Website    ${BROWSER}    ${REGION}    # Load the web page based on the region and the browser based by the type.
# Suite Teardown    Close All Browsers    # Close all open browsers.
