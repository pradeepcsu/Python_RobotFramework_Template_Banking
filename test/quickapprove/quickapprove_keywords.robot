*** Settings ***
Library           Selenium2Library
Library           QuickApprove

*** Variables ***
${QAT} =    https://quickapprove-qa.qatssfcu.org
${UAT} =    https://quickapprove-uat.devssfcu.org

*** Keywords ***
Open QuickApprove
    [Arguments]    ${BROWSER}    ${REGION}
    ${URL}    Set Variable If
    ...    "${REGION}" == "QAT"    ${QAT}
    ...    "${REGION}" == "UAT"    ${UAT}
    Set Global Variable    ${URL}
    Set Global Variable    ${BROWSER}
    Open Browser    ${URL}    ${BROWSER}
    Log    ${browser}
    Log In QuickApprove

Log In QuickApprove
    Maximize Browser Window
    Enter Text    Login_User    autotest10
    Click On    Login_Login
    ${result} =    Check Exists    Login_Security_Answer1
    Run Keyword If    ${result} == True    Fill Security Info
    Enter Text    Login_Security_Password    ssfcu123
    Click On    Login_Security_SignIn

Fill Security Info
    Enter Text    Login_Security_Answer1    test
    Enter Text    Login_Security_Answer2    test
    Click On    Login_Security_RegisterComputer_Y
    Click On    Login_Security_Continue


