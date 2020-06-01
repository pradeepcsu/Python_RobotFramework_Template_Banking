*** Settings ***
Library           Selenium2Library
Resource          Omnia Keywords.txt
Documentation     Test documentation for Omnia test suite.
Suite Setup       Open Omnia    ${BROWSER}    ${REGION}    # Load the web page based on the region and the browser based by the type.
Suite Teardown    Close All Browsers    # Close all open browsers.
