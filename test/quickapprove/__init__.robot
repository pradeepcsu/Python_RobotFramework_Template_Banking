*** Settings ***
Library           Selenium2Library
Resource          quickapprove_keywords.robot
Documentation     Test documentation for the QuickApprove test suite.
Suite Setup       Open QuickApprove    ${BROWSER}    ${REGION}    # Load the web page based on the region and the browser based by the type.
Suite Teardown    Close All Browsers    # Close all open browsers.
